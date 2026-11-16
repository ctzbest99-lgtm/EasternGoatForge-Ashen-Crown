#!/usr/bin/env python3
"""Ashen Crown balance sim (feature/balance-pass, extended through Act III). Mirrors the GML
battle formulas: damage = max(1, ATK - floor(DEF/2)); magic uses MDEF instead of DEF; skill power
floors; Guard halves the next hit (enemy) or all hits until next round (party); buffs tick at round
start; SPD order with a <1 tiebreak. The extended rows also model criticals (Cutthroat), Kael's
Last Stand, bleed, the Debtman's bind (Slow) / Collect / stance / yield, the two-phase boss shift at
50% HP, magic AoE (Warden ring), Sera's Mend / Smite, the wood's Fade / Blinding Dust / Drowsy Dust,
the Matriarch's Ash Breath, and the garrison Field Surgeon's heal.
Run: python3 tools/balance_sim.py   (prints the markdown tables used in DECISIONS)."""
import random, math, statistics, sys

# ---- party growth (mirrors scr_game_constants / scr_progression) --------------------------
BASE = {"kael": dict(hp=30, atk=6, df=2, mdef=2, spd=10, mp=6),
        "taren": dict(hp=36, atk=8, df=3, mdef=2, spd=9, mp=12)}
LOW = dict(hp=4, atk=1, df=1, mdef=1, mp=2, spd=1)      # level-ups to L2..L7 (Chapter 1, unchanged)
HIGH = dict(hp=10, atk=2, df=2, mdef=1, mp=3, spd=1)    # level-ups to L8+ (LEVEL_UP_*_GROWTH_HIGH)
TIER_LEVEL = 8

def member(mid, level, weapon, armor):
    b = BASE[mid]; s = dict(b)
    for L in range(2, level + 1):
        g = HIGH if L >= TIER_LEVEL else LOW
        s["hp"] += g["hp"]; s["atk"] += g["atk"]; s["df"] += g["df"]; s["mp"] += g["mp"]; s["spd"] += g["spd"]
        s["mdef"] += g["mdef"]
    s["atk"] += weapon; s["df"] += armor
    return dict(id=mid, name=mid.title(), max_hp=s["hp"], hp=s["hp"], atk=s["atk"], df=s["df"],
                mdef=s["mdef"], spd=s["spd"], mp=s["mp"], buffs=[], guard=False, side="party")

# ---- enemies (mirrors scr_enemy_database after this pass) ---------------------------------
E = {
 "crown_patrolman":   dict(hp=44, atk=13, df=12, spd=11, ai=[("attack",2),("thrust",2),("brace",1)]),
 "crown_crossbowman": dict(hp=36, atk=14, df=8,  spd=13, ai=[("attack",1)]),
 "occupation_soldier":dict(hp=50, atk=12, df=14, spd=8,  ai=[("attack",2),("slash",2),("guard",1)]),
 "bandit_veteran":    dict(hp=42, atk=13, df=10, spd=14, ai=[("attack",1)]),
 "grey_ash_wolf":     dict(hp=36, atk=13, df=8,  spd=20, ai=[("attack",4),("flavor",1)]),
 "reeve_calder":      dict(hp=130, atk=15, df=16, spd=10, mp=20, boss=True,
                           ai=[("heavy",3),("guard",1),("shout",2)], alone=[("heavy",3),("guard",1)]),
 # Chapter 1 reference (unchanged)
 "blackguard":        dict(hp=450, atk=12, df=8, spd=9, boss=True, ai=[("attack",1)]),
}
POWER = {"attack":1, "thrust":1.2, "slash":1.1, "heavy":1.3}

def dmg(atk, df, power=1.0):
    d = max(1, atk - df // 2)
    if power != 1: d = max(1, math.floor(d * power))
    return d

def stat(a, k):
    base = a[k]; pct = sum(b[1] for b in a["buffs"] if b[0] == k)
    return max(1 if k in ("atk",) else 0, round(base * (1 + pct)))

def tick(a):
    nb = []
    for b in a["buffs"]:
        if b[2] < 0: nb.append(b); continue
        t = b[2] - 1
        if t > 0: nb.append((b[0], b[1], t))
    a["buffs"] = nb

def mk_enemy(eid):
    e = dict(E[eid]); e.update(id=eid, max_hp=e["hp"], buffs=[], guard=False, side="enemy",
                               mp=e.get("mp", 0), stance=False, yielded=False, phase=1)
    return e

def pick(ai, e, allies, hurt=False):
    opts = []
    for s, w in ai:
        if s == "shout" and (allies == 0 or e["mp"] < 6): continue
        if s == "brace" and any(b[0] == "df" for b in e["buffs"]): continue
        if s == "heal" and not hurt: continue      # Field Surgeon only heals a hurt ally
        if s == "fade" and e.get("veiled", 0) > 0: continue  # skill cond "not_veiled"
        opts.append((s, w))
    r = random.uniform(0, sum(w for _, w in opts))
    for s, w in opts:
        r -= w
        if r < 0: return s
    return opts[-1][0]

def fight(party, eids, calder_stance=True, max_rounds=60):
    enemies = [mk_enemy(x) for x in eids]
    has_adds = enemies[0].get("boss") and len(enemies) > 1
    turns_on = {i: 0 for i in range(len(enemies))}; party_turns = 0; dmg_taken = 0
    for rnd in range(1, max_rounds + 1):
        for a in party + enemies: tick(a)
        for p in party: p["guard"] = False
        order = [a for a in party + enemies if a["hp"] > 0]
        order.sort(key=lambda a: stat(a, "spd") + random.random() * 0.99, reverse=True)
        for a in order:
            if a["hp"] <= 0: continue
            live_e = [e for e in enemies if e["hp"] > 0 and not e["yielded"]]
            live_p = [p for p in party if p["hp"] > 0]
            if not live_e or not live_p: break
            if a["side"] == "party":
                party_turns += 1
                # policy: Taren opens with Rallying Cry, Cleaves 2+ enemies, else hits the weakest add, then the boss
                if a["id"] == "taren" and rnd == 1 and a["mp"] >= 4 and len(live_p) > 1:
                    a["mp"] -= 4
                    for p in live_p: p["buffs"] = [b for b in p["buffs"] if b[0] != "atk"] + [("atk", .25, 3)]
                    continue
                if a["id"] == "taren" and len(live_e) >= 2 and a["mp"] >= 3:
                    a["mp"] -= 3
                    for e in live_e:
                        d = dmg(stat(a, "atk"), stat(e, "df"), 0.6)
                        if e["guard"]: d = max(1, d // 2); e["guard"] = False
                        e["hp"] -= d; turns_on[enemies.index(e)] += 1.0 / len(live_e)
                    continue
                tgt = min(live_e, key=lambda e: (e.get("boss", False), e["hp"]))
                d = dmg(stat(a, "atk"), stat(tgt, "df"))
                if tgt["guard"]: d = max(1, d // 2); tgt["guard"] = False
                tgt["hp"] -= d; turns_on[enemies.index(tgt)] += 1
                if tgt["hp"] <= 0 and tgt["id"] == "reeve_calder": tgt["hp"] = 1; tgt["yielded"] = True
            else:
                allies = len(live_e) - 1
                ai = a["ai"]
                if a.get("alone") and allies == 0: ai = a["alone"]
                s = pick(ai, a, allies)
                if s in ("guard",): a["guard"] = True; continue
                if s == "brace": a["buffs"].append(("df", .5, 2)); continue
                if s == "flavor": continue
                if s == "shout":
                    a["mp"] -= 6
                    for e in live_e: e["buffs"] = [b for b in e["buffs"] if b[0] != "atk"] + [("atk", .25, 3)]
                    continue
                t = random.choice(live_p)
                d = dmg(stat(a, "atk"), stat(t, "df"), POWER[s])
                if t["guard"]: d = max(1, d // 2)
                t["hp"] -= d; dmg_taken += d
            # Calder stance when the adds fall
            if has_adds and calder_stance:
                c = enemies[0]
                if not c["stance"] and c["hp"] > 0 and all(e["hp"] <= 0 for e in enemies[1:]):
                    c["stance"] = True; c["buffs"] += [("atk", .25, -1), ("df", .15, -1)]
        live_e = [e for e in enemies if e["hp"] > 0 and not e["yielded"]]
        if not live_e: return dict(win=True, rounds=rnd, party_turns=party_turns, turns_on=turns_on,
                                   hp_left=sum(max(0, p["hp"]) for p in party) / sum(p["max_hp"] for p in party))
        if all(p["hp"] <= 0 for p in party): break
    return dict(win=False, rounds=rnd, party_turns=party_turns, turns_on=turns_on, hp_left=0)

def run(label, level, members, eids, n=4000, gear=None):
    gear = gear or {}
    res = [fight([member(m, level, *gear.get(m, (0, 0))) for m in members], eids) for _ in range(n)]
    wins = [r for r in res if r["win"]]
    wr = len(wins) / n
    def avg(f): return statistics.mean(f(r) for r in wins) if wins else float("nan")
    return dict(label=label, level=level, members="+".join(m.title() for m in members), win=wr,
                rounds=avg(lambda r: r["rounds"]), pturns=avg(lambda r: r["party_turns"]),
                boss=avg(lambda r: r["turns_on"][0]), hp=avg(lambda r: r["hp_left"]))

# Gear at the start of Chapter 2 (end of Chapter 1): Blackguard's Longsword +5 (Kael),
# Leather Armor +2 and Iron Helm +1 (Kael). Taren: Bastard Sword +3, Traveller's Brigandine +2 (new Ch2 starting armour, PLACEHOLDER).
GEAR = {"kael": (5, 3), "taren": (3, 2)}

def hits_to_kill(level, mid, eid):
    m = member(mid, level, *GEAR[mid]); e = E[eid]
    return math.ceil(e["hp"] / dmg(m["atk"], e["df"]))

if __name__ == "__main__":
    random.seed(7)
    rows = []
    for L in (8, 9, 10):
        rows.append(run("Millhaven: 1 Patrolman", L, ["kael"], ["crown_patrolman"], gear=GEAR))
        rows.append(run("Millhaven: Patrolman + Crossbowman", L, ["kael"], ["crown_patrolman", "crown_crossbowman"], gear=GEAR))
        rows.append(run("Millhaven: 2 Bandit Veterans", L, ["kael"], ["bandit_veteran", "bandit_veteran"], gear=GEAR))
        rows.append(run("Millhaven: 2 Grey Ash Wolves", L, ["kael"], ["grey_ash_wolf", "grey_ash_wolf"], gear=GEAR))
        rows.append(run("Calder + 2 Occupation Soldiers", L, ["kael", "taren"], ["reeve_calder", "occupation_soldier", "occupation_soldier"], gear=GEAR))
    print("| Fight | Lv | Party | Win % | Rounds | Party turns | Turns on Calder | Party HP left |")
    print("|---|---|---|---|---|---|---|---|")
    for r in rows:
        boss = f"{r['boss']:.1f}" if "Calder" in r["label"] else "—"
        print(f"| {r['label']} | {r['level']} | {r['members']} | {r['win']*100:.0f}% | {r['rounds']:.1f} | {r['pturns']:.1f} | {boss} | {r['hp']*100:.0f}% |")
    print()
    print("| Level | Kael ATK / DEF / HP | Taren ATK / DEF / HP | Hits (Kael) to kill: Occ. Soldier | Patrolman | Crossbowman | Bandit Vet. | Grey Wolf | Calder (pre-stance) |")
    print("|---|---|---|---|---|---|---|---|---|")
    for L in (7, 8, 9, 10):
        k = member("kael", L, *GEAR["kael"]); t = member("taren", L, *GEAR["taren"])
        print(f"| {L} | {k['atk']} / {k['df']} / {k['max_hp']} | {t['atk']} / {t['df']} / {t['max_hp']} | "
              + " | ".join(str(hits_to_kill(L, "kael", e)) for e in ["occupation_soldier", "crown_patrolman", "crown_crossbowman", "bandit_veteran", "grey_ash_wolf", "reeve_calder"]) + " |")

# ---- Chapter 3: Valemere Road and the Debtman (feature/chapter3) --------------------------
# Party data mirrors scr_party: Lyra joins at Kael's level with the Twin Daggers (+2 ATK) and no
# Chapter 3 road patrols (scr_enemy_scaled at 10/10/11, band 10-13): the Act II crown and bandit
# entries are level 8 and were too weak for the road, so the table spawns these instead.
E.update({
 "crown_patrolman_road":   dict(hp=53, atk=16, df=13, mdef=7, spd=11, weak="lightning",
                                ai=[("attack", 2), ("thrust", 2), ("brace", 1)]),
 "crown_crossbowman_road": dict(hp=42, atk=18, df=13, mdef=7, spd=13, weak="lightning", ai=[("attack", 1)]),
 "bandit_veteran_road":    dict(hp=62, atk=19, df=15, mdef=8, spd=14, ai=[("attack", 1)]),
})
# armour. Chapter 3 gear assumes Len's Chain Mail (+4 DEF) has been bought for Kael (+ Iron Helm)
# and Taren; without it, knock roughly 2 DEF off each and expect a few more rounds.
# Enemies mirror scr_enemy_scaled (dock_thug common 11, debt_collector elite 12, debtman boss 12
# for a party of 3) and their kits in scr_skill_data.
BASE["lyra"] = dict(hp=24, atk=7, df=1, mdef=2, spd=14, mp=6)     # Chapter 3
BASE["caelan"] = dict(hp=22, atk=8, df=1, mdef=5, spd=9, mp=16)    # Chapter 4, no weapon, no skills
E.update({
 "bandit":         dict(hp=18,  atk=5,  df=1,  spd=8,  ai=[("attack", 1)]),
 "dock_thug":      dict(hp=62,  atk=19, df=15, spd=9,  ai=[("attack", 1)]),
 "debt_collector": dict(hp=142, atk=24, df=19, spd=10, ai=[("attack", 1)]),
 "debtman":        dict(hp=256, atk=25, df=20, spd=12, boss=True, yields=True,
                        ai=[("attack", 3), ("reel", 2), ("collect", 2), ("bind", 1)]),
})
POWER.update({"reel": 1.25, "collect": 0.8})
GEAR_CH3 = {"kael": (5, 5), "taren": (3, 4), "lyra": (2, 0)}
GEAR_LATE = dict(GEAR_CH3, caelan=(0, 0))   # no Chapter 4/5 gear upgrades exist yet

# Chapter 4 (Hollow Sanctuary) and Chapter 5 (Blackwood Road Garrison) enemies. scr_enemy_scaled:
# common 14 = 79 / 23 / 21; elite 15 = 172 / 27 / 25; boss 16 for 4 = 558 HP; common 16 = 93/27/25;
# elite 17 = 200 / 31 / 29; boss 18 for 4 = 642 HP. Extras (def_add, hp_mult, weakness) applied.
E.update({
 "ward_sentinel":     dict(hp=89,  atk=28, df=24, mdef=11, spd=7,  weak="lightning", ai=[("attack", 1)]),
 "glyph_wisp":        dict(hp=67,  atk=28, df=21, mdef=11, spd=15, ai=[("attack", 1), ("mote", 2)]),
 "aethari_automaton": dict(hp=196, atk=33, df=25, mdef=12, spd=9,  weak="lightning", ai=[("attack", 1)]),
 "sanctuary_warden":  dict(hp=643, atk=39, df=28, mdef=13, spd=8, boss=True,   # 514 base x1.25, atk_add 2
                           ai=[("attack", 2), ("ring", 1)],
                           phase_ai={2: [("attack", 2), ("ring", 2)]},
                           phase2_at=0.5, phase2_atk=0.20),
 "garrison_pikeman":  dict(hp=107, atk=38, df=25, mdef=13, spd=10, ai=[("attack", 2), ("pike", 2)]),
 "garrison_field_surgeon": dict(hp=86, atk=34, df=25, mdef=13, spd=12, ai=[("attack", 2), ("heal", 3)]),
 "garrison_knight":   dict(hp=232, atk=39, df=29, mdef=14, spd=9,  ai=[("attack", 3), ("guard", 1)]),
 "commander_hailen":  dict(hp=900, atk=57, df=32, mdef=15, spd=12, boss=True,   # 600 base x1.5, atk_add 14
                           ai=[("attack", 3), ("glint", 2)]),
})
POWER.update({"pike": 1.2, "glint": 1.4})
MAG_POWER = {"mote": 1.1, "ring": 0.7}      # ATK vs MDEF; ring hits the whole party
HEAL_AMOUNT, HEAL_THRESHOLD = 30, 0.6        # BATTLE_HEAL_ALLY_THRESHOLD
WEAK_MULT = 1.5                               # BATTLE_WEAKNESS_MULTIPLIER
# Caelan (CHAPTER4_SCRIPT.md §6): one spell per element, magic vs MDEF, 4/4/5 MP.
CAELAN_SPELLS = (("lightning", 1.35, 5, "arc_bolt"), ("ice", 1.2, 4, "frost_lance"), ("fire", 1.2, 4, "ember"))

CRIT_BASE, CRIT_CUTTHROAT, CRIT_MULT = 0.05, 0.15, 1.5
BLIND_MISS = 0.5                              # BATTLE_BLIND_MISS_CHANCE
BLEED_PCT, SLOW_PCT, BIND_CHANCE = 0.06, 0.5, 0.7
LAST_STAND = dict(atk=0.15, df=0.10)

def st3(a, k):
    """Stat with Last Stand, Slow and buffs, in the GML order (base -> passive -> slow -> buffs)."""
    base = a[k]
    if a.get("id") == "kael" and k in ("atk", "df") and 0 < a["hp"] < a["max_hp"] * 0.25:
        base = base * (1 + LAST_STAND[k])
    if k == "spd" and a.get("slow", 0) > 0:
        base = base * SLOW_PCT
    pct = sum(b[1] for b in a["buffs"] if b[0] == k)
    v = int(base * (1 + pct) + 0.5)
    return max(1, v) if k in ("atk", "spd") else max(0, v)

def crit_roll(a):
    return random.random() < CRIT_BASE + (CRIT_CUTTHROAT if a.get("id") == "lyra" else 0)

def hit(a, tgt, power=1.0, defense="df"):
    d = max(1, st3(a, "atk") - st3(tgt, defense) // 2)
    if power != 1:
        d = max(1, math.floor(d * power))
    if crit_roll(a):
        d = max(1, math.floor(d * CRIT_MULT))
    if tgt["guard"]:
        d = max(1, d // 2)
        tgt["guard"] = False
    return d

def focus(live_e, boss_focus=True):
    """Party policy. When `boss_focus` (the Debtman, whose stance punishes clearing the adds) the
    boss is hit first; otherwise the weakest enemy dies first."""
    bosses = [e for e in live_e if e.get("boss")]
    if boss_focus and bosses: return bosses[0]
    return min(live_e, key=lambda e: e["hp"])

def fight_ext(party, eids, boss_focus=True, max_rounds=60, boss_hp_mult=1.0):
    enemies = [mk_enemy(x) for x in eids]
    if boss_hp_mult != 1.0:                     # a what-if lever for tuning passes
        for e in enemies:
            if e.get("boss"):
                e["max_hp"] = round(e["max_hp"] * boss_hp_mult)
                e["hp"] = e["max_hp"]
    boss = enemies[0] if enemies[0].get("boss") else None
    turns_on = {i: 0 for i in range(len(enemies))}
    party_turns = 0
    def damage(a, tgt, power=1.0, weight=1.0, defense="df", element=None):
        if tgt.get("veiled", 0) > 0: return 0            # Fade: attacks miss it
        if defense == "df" and a.get("blind", 0) > 0 and random.random() < BLIND_MISS: return 0
        d = hit(a, tgt, power, defense)
        if element and tgt.get("weak") == element: d = max(1, math.floor(d * WEAK_MULT))
        tgt["hp"] -= d
        turns_on[enemies.index(tgt)] += weight
        if tgt["hp"] <= 0 and tgt.get("yields"):
            tgt["hp"] = 1; tgt["yielded"] = True
        return d
    for rnd in range(1, max_rounds + 1):
        for a in party + enemies:
            tick(a)
            if a.get("slow", 0) > 0: a["slow"] -= 1
            if a.get("blind", 0) > 0: a["blind"] -= 1
            if a.get("veiled", 0) > 0: a["veiled"] -= 1   # Fade lasts until the next round
            if a.get("bleed", 0) > 0 and a["hp"] > 1:
                a["hp"] = max(1, a["hp"] - max(1, math.floor(a["max_hp"] * BLEED_PCT)))
                a["bleed"] -= 1
        for p in party: p["guard"] = False
        order = [a for a in party + enemies if a["hp"] > 0]
        order.sort(key=lambda a: st3(a, "spd") + random.random() * 0.99, reverse=True)
        for a in order:
            if a["hp"] <= 0: continue
            live_e = [e for e in enemies if e["hp"] > 0 and not e["yielded"]]
            live_p = [p for p in party if p["hp"] > 0]
            if not live_e or not live_p: break
            if a["side"] == "party":
                if a.get("sleep", 0) > 0:
                    a["sleep"] -= 1
                    continue                                  # asleep: the turn is skipped
                party_turns += 1
                if a["id"] == "taren" and rnd == 1 and a["mp"] >= 4 and len(live_p) > 1:
                    a["mp"] -= 4
                    for p in live_p:
                        p["buffs"] = [b for b in p["buffs"] if b[0] != "atk"] + [("atk", .25, 3)]
                    continue
                if a["id"] == "taren" and len(live_e) >= 2 and a["mp"] >= 3:
                    a["mp"] -= 3
                    for e in live_e: damage(a, e, 0.6, 1.0 / len(live_e))  # Cleave splits one turn
                    continue
                tgt = focus(live_e, boss_focus)
                if a["id"] == "caelan":
                    cast = None
                    for _el, _pw, _cost, _id in CAELAN_SPELLS:
                        if a["mp"] >= _cost:
                            cast = (_el, _pw, _cost)
                            if tgt.get("weak") == _el: break
                    if cast is not None:
                        a["mp"] -= cast[2]
                        damage(a, tgt, cast[1], 1.0, "mdef", cast[0])
                        continue
                if a["id"] == "sera":
                    hurt = min(live_p, key=lambda p: p["hp"] / p["max_hp"])
                    if a["mp"] >= 4 and hurt["hp"] < hurt["max_hp"] * HEAL_THRESHOLD:
                        a["mp"] -= 4                        # Mend: +30 to the most-hurt ally
                        hurt["hp"] = min(hurt["max_hp"], hurt["hp"] + HEAL_AMOUNT)
                        continue
                    if a["mp"] >= 5 and tgt.get("weak") == "holy":
                        a["mp"] -= 5                        # Smite: 1.3 holy, x1.5 on the holy-weak
                        damage(a, tgt, 1.3, 1.0, "df", "holy")
                        continue
                if a["id"] == "lyra" and a["mp"] >= 4 and not tgt.get("bleed"):
                    a["mp"] -= 4
                    damage(a, tgt, 0.9)
                    if random.random() < 0.8: tgt["bleed"] = 3
                    continue
                if a["id"] == "lyra" and a["mp"] >= 3:
                    a["mp"] -= 3
                    for _ in range(2):
                        if tgt["hp"] > 0 and not tgt["yielded"]: damage(a, tgt, 0.7)
                    continue
                damage(a, tgt)
            else:
                allies = len(live_e) - 1
                ai = a["ai"]
                if a.get("phase_ai") and a.get("phase", 1) in a["phase_ai"]: ai = a["phase_ai"][a["phase"]]
                elif a.get("alone") and allies == 0: ai = a["alone"]
                hurt = any(p["hp"] < p["max_hp"] * HEAL_THRESHOLD for p in live_p)
                s = pick(ai, a, allies, hurt)
                if s == "guard": a["guard"] = True; continue
                if s == "brace": a["buffs"].append(("df", .5, 2)); continue
                if s == "flavor": continue
                if s == "shout":
                    a["mp"] -= 6
                    for e in live_e:
                        e["buffs"] = [b for b in e["buffs"] if b[0] != "atk"] + [("atk", .25, 3)]
                    continue
                if s == "heal":
                    t = min(live_e, key=lambda e: e["hp"] / e["max_hp"])
                    t["hp"] = min(t["max_hp"], t["hp"] + HEAL_AMOUNT)
                    continue
                if s == "ring":                                  # magic, hits every living member
                    for p in live_p: p["hp"] -= hit(a, p, MAG_POWER[s], defense="mdef")
                    continue
                if s == "breath":                                # Matriarch: 0.8 physical, whole party
                    for p in live_p: p["hp"] -= hit(a, p, POWER[s])
                    continue
                if s == "fade":
                    a["veiled"] = 1
                    continue
                if s in ("blind", "sleep"):
                    t = random.choice(live_p)
                    chance = 0.7 if s == "blind" else 0.5
                    if random.random() < chance:
                        t[s] = 3 if s == "blind" else 2
                    continue
                t = random.choice(live_p)
                if s == "bind":
                    if random.random() < BIND_CHANCE: t["slow"] = 2
                    continue
                if s in MAG_POWER:
                    t["hp"] -= hit(a, t, MAG_POWER[s], defense="mdef")
                    continue
                d = hit(a, t, POWER[s])
                t["hp"] -= d
                if t.get("sleep", 0) > 0: t["sleep"] = 0      # a hit wakes a sleeper
                if s == "collect": a["hp"] = min(a["max_hp"], a["hp"] + d)
            if a["side"] == "enemy" and a.get("phase2_at") and a.get("phase", 1) == 1 \
                    and 0 < a["hp"] <= a["max_hp"] * a["phase2_at"]:
                a["phase"] = 2
                a["buffs"] += [("atk", a.get("phase2_atk", 0.20), -1)]
            if boss and boss is not a and boss["hp"] > 0 and not boss.get("stance"):
                if all(e["hp"] <= 0 or e["yielded"] for e in enemies if e is not boss):
                    boss["stance"] = True
                    boss["buffs"] += [("atk", .30, -1), ("spd", .30, -1)]
        live_e = [e for e in enemies if e["hp"] > 0 and not e["yielded"]]
        if not live_e or (boss is not None and boss.get("yielded")):
            # A yielding boss ends the battle as a victory with his adds still standing
            # (same rule as Reeve Calder).
            return dict(win=True, rounds=rnd, party_turns=party_turns, turns_on=turns_on,
                        hp_left=sum(max(0, p["hp"]) for p in party) / sum(p["max_hp"] for p in party),
                        deaths=sum(1 for p in party if p["hp"] <= 0))
        if all(p["hp"] <= 0 for p in party): break
    return dict(win=False, rounds=rnd, party_turns=party_turns, turns_on=turns_on, hp_left=0,
                deaths=sum(1 for p in party if p["hp"] <= 0))

def run_ext(label, level, members, eids, gear=None, boss_focus=True, n=4000, boss_hp_mult=1.0):
    gear = GEAR_CH3 if gear is None else gear
    res = [fight_ext([member(m, level, *gear[m]) for m in members], eids, boss_focus=boss_focus,
                     boss_hp_mult=boss_hp_mult)
           for _ in range(n)]
    wins = [r for r in res if r["win"]]
    def avg(f): return statistics.mean(f(r) for r in wins) if wins else float("nan")
    return dict(label=label, level=level, members="+".join(m.title() for m in members),
                win=len(wins) / n, rounds=avg(lambda r: r["rounds"]), pturns=avg(lambda r: r["party_turns"]),
                boss=avg(lambda r: r["turns_on"][0]), hp=avg(lambda r: r["hp_left"]),
                deaths=avg(lambda r: r["deaths"]))

def run_c3(label, level, members, eids, n=4000):
    return run_ext(label, level, members, eids, gear=GEAR_CH3, boss_focus=True, n=n)

def c3_tables():
    random.seed(11)
    rows = []
    for L in (10, 11, 12):
        rows.append(run_c3("Valemere Rd: Patrolman", L, ["kael", "taren"], ["crown_patrolman_road"]))
        rows.append(run_c3("Valemere Rd: Crossbowman", L, ["kael", "taren"], ["crown_crossbowman_road"]))
        rows.append(run_c3("Valemere Rd: Bandit Veteran", L, ["kael", "taren"], ["bandit_veteran_road"]))
        rows.append(run_c3("Valemere Rd: Patrolman + Crossbowman", L, ["kael", "taren"], ["crown_patrolman_road", "crown_crossbowman_road"]))
        rows.append(run_c3("Valemere Rd: Veteran + Patrolman", L, ["kael", "taren"], ["bandit_veteran_road", "crown_patrolman_road"]))
        rows.append(run_c3("Debtman + Dock Thug + Debt Collector", L, ["kael", "taren", "lyra"],
                           ["debtman", "dock_thug", "debt_collector"]))
    print()
    print("| Fight | Lv | Party | Win % | Rounds | Party turns | Turns on Debtman | Party HP left |")
    print("|---|---|---|---|---|---|---|---|")
    for r in rows:
        boss = f"{r['boss']:.1f}" if "Debtman" in r["label"] else "—"
        print(f"| {r['label']} | {r['level']} | {r['members']} | {r['win']*100:.0f}% | {r['rounds']:.1f} | {r['pturns']:.1f} | {boss} | {r['hp']*100:.0f}% |")
    print()
    print("| Level | Kael ATK / DEF / HP | Taren ATK / DEF / HP | Lyra ATK / DEF / HP | Hits to kill: Debtman (K/T/L) | Dock Thug (K/T/L) | Debt Collector (K/T/L) |")
    print("|---|---|---|---|---|---|---|")
    for L in (10, 11, 12):
        members = {m: member(m, L, *GEAR_CH3[m]) for m in ("kael", "taren", "lyra")}
        cells = {m: f"{members[m]['atk']} / {members[m]['df']} / {members[m]['max_hp']}" for m in members}
        def kh(eid):
            e = E[eid]
            return "/".join(str(math.ceil(e["hp"] / max(1, members[m]["atk"] - e["df"] // 2))) for m in ("kael", "taren", "lyra"))
        print(f"| {L} | {cells['kael']} | {cells['taren']} | {cells['lyra']} | {kh('debtman')} | {kh('dock_thug')} | {kh('debt_collector')} |")

def ch45_tables():
    """Chapter 4 (Hollow Sanctuary) and Chapter 5 (Blackwood Road Garrison)."""
    random.seed(23)
    PARTY = ["kael", "taren", "lyra", "caelan"]   # Caelan joins in Ch 4; Sera is still held in Ch 5
    SANCTUARY = [
        ("Sanctuary: Sentinel + Wisp", ["ward_sentinel", "glyph_wisp"]),
        ("Sanctuary: 2 Wisps + Sentinel", ["glyph_wisp", "glyph_wisp", "ward_sentinel"]),
        ("Sanctuary: Automaton + Wisp", ["aethari_automaton", "glyph_wisp"]),
        ("Sanctuary Warden + Ward Sentinel", ["sanctuary_warden", "ward_sentinel"]),
    ]
    GARRISON = [
        ("Garrison: Pikeman + Surgeon", ["garrison_pikeman", "garrison_field_surgeon"]),
        ("Garrison: 2 Pikemen + Surgeon", ["garrison_pikeman", "garrison_pikeman", "garrison_field_surgeon"]),
        ("Garrison: Knight + Surgeon", ["garrison_knight", "garrison_field_surgeon"]),
        ("Hailen + Garrison Pikeman", ["commander_hailen", "garrison_pikeman"]),
    ]
    print()
    for title, band, fights in (("Hollow Sanctuary (Chapter 4)", (13, 14, 15), SANCTUARY),
                                ("Blackwood Road Garrison (Chapter 5)", (16, 17, 18), GARRISON)):
        rows = [run_ext(label, L, PARTY, eids, gear=GEAR_LATE, boss_focus=False)
                for L in band for label, eids in fights]
        print(f"**{title}** — {'/'.join(PARTY)}")
        print()
        print("| Fight | Lv | Win % | Rounds | Party turns | Turns on boss | Party HP left |")
        print("|---|---|---|---|---|---|---|")
        for r in rows:
            boss = "—"
            if "Warden +" in r["label"] or "Hailen" in r["label"]: boss = f"{r['boss']:.1f}"
            print(f"| {r['label']} | {r['level']} | {r['win']*100:.0f}% | {r['rounds']:.1f} | {r['pturns']:.1f} | {boss} | {r['hp']*100:.0f}% |")
        print()
    print("| Level | Kael ATK/DEF/HP | Taren ATK/DEF/HP | Lyra ATK/DEF/HP | Caelan ATK/DEF/HP | Hits to kill Warden (K/T/L/C) | Hits to kill Hailen (K/T/L/C) |")
    print("|---|---|---|---|---|---|---|")
    for L in (13, 14, 15, 16, 17, 18):
        ms = {m: member(m, L, *GEAR_LATE[m]) for m in PARTY}
        def kh(eid):
            e = E[eid]
            return "/".join(str(math.ceil(e["hp"] / max(1, ms[m]["atk"] - e["df"] // 2))) for m in PARTY)
        print(f"| {L} | " + " | ".join(f"{ms[m]['atk']} / {ms[m]['df']} / {ms[m]['max_hp']}" for m in PARTY)
              + f" | {kh('sanctuary_warden')} | {kh('commander_hailen')} |")

def ch4_prejoin_table():
    """The sanctuary before Caelan joins: Kael + Taren + Lyra, Chapter 3 gear, no fourth member."""
    random.seed(31)
    PARTY3 = ["kael", "taren", "lyra"]
    fights = [
        ("Sanctuary: Sentinel + Wisp", ["ward_sentinel", "glyph_wisp"]),
        ("Sanctuary: 2 Wisps + Sentinel", ["glyph_wisp", "glyph_wisp", "ward_sentinel"]),
        ("Sanctuary: Automaton + Wisp", ["aethari_automaton", "glyph_wisp"]),
        ("Sanctuary: 1 Sentinel", ["ward_sentinel"]),
        ("Sanctuary: 2 Wisps", ["glyph_wisp", "glyph_wisp"]),
    ]
    print()
    print("**Hollow Sanctuary before Caelan (Chapter 4)** — Kael + Taren + Lyra (3 members)")
    print()
    print("| Fight | Lv | Win % | Rounds | Party turns | Party HP left |")
    print("|---|---|---|---|---|---|")
    for L in (13, 14, 15):
        for label, eids in fights:
            r = run_ext(label, L, PARTY3, eids, gear=GEAR_CH3, boss_focus=False)
            print(f"| {r['label']} | {L} | {r['win']*100:.0f}% | {r['rounds']:.1f} | {r['pturns']:.1f} | {r['hp']*100:.0f}% |")
    print()

# ---- Act III: the Blackwood (Chapters 6–8, docs/story/ACT3_OUTLINE.md, PROPOSED) ----------
# Party data mirrors scr_party: Sera joins for Act III (28 HP / 4 ATK / 4 DEF, MDEF 5, SPD 8,
# MP 12) carrying the Holy Sword, which has no stats yet (atk_bonus 0). Gear is unchanged from
# Chapter 5 — there are no Act III weapons or armour in the item data.
BASE["sera"] = dict(hp=28, atk=4, df=4, mdef=5, spd=8, mp=12)
GEAR_LATE["sera"] = (0, 0)
# scr_enemy_scaled: level 18 = 125 / 40 / 29 / MDEF 15; 19 = 134 / 43 / 31 / 16; 20 = 143 / 46 /
# 33 / 17. Role (elite x2 HP, boss x1.2 x party size) then hp_mult / def_add applied.
E.update({
 "shade_stalker":   dict(hp=125, atk=40, df=29, mdef=15, spd=19, weak="holy",
                         ai=[("attack", 3), ("fade", 1)]),
 "briar_hulk":      dict(hp=175, atk=40, df=29, mdef=15, spd=5, weak="fire", ai=[("attack", 1)]),
 "lost_one":        dict(hp=125, atk=40, df=29, mdef=15, spd=8, weak="holy", ai=[("attack", 1)]),
 "night_moth_swarm":dict(hp=94,  atk=43, df=31, mdef=16, spd=16, weak="fire",
                         ai=[("attack", 2), ("blind", 2), ("sleep", 1)]),
 # The Act III bosses as they are now in scr_enemy_database (ACT3_OUTLINE.md §7, tuned here):
 # burn_line_hulk = briar_hulk at boss scale, hp_mult 2.1 (the Hulk's x1.4 and the boss x1.2 x 4)
 # and atk_add 12; door_warden_boss = the elite at boss scale with hp_mult 2.0 and +3 DEF;
 # blackwood_matriarch carries hp_mult 1.5. ward_sentinel_late is the level-20 Sentinel the
 # Chapter 8 adds need (the level-14 one dies in a single hit at 20).
 "burn_line_hulk":  dict(hp=1260, atk=55, df=32,  mdef=15, spd=5,  weak="fire", boss=True,
                         ai=[("attack", 1)]),
 "blackwood_matriarch": dict(hp=1029, atk=49, df=36, mdef=17, spd=13, weak="holy", boss=True,
                         ai=[("attack", 2), ("breath", 1)],
                         phase_ai={2: [("attack", 2), ("breath", 2)]},
                         phase2_at=0.5, phase2_atk=0.25),
 "door_warden":     dict(hp=268, atk=45, df=36, mdef=16, spd=6, weak="lightning", ai=[("attack", 1)]),
 "door_warden_boss":dict(hp=1286, atk=46, df=37, mdef=16, spd=6, weak="lightning", boss=True,
                         ai=[("attack", 1)]),
 "ward_sentinel_late": dict(hp=143, atk=46, df=36, mdef=17, spd=7, weak="lightning", ai=[("attack", 1)]),
})
POWER.update({"breath": 0.8})

def ch6_tables():
    """Act III (Chapters 6-8, Blackwood). PROPOSED numbers from docs/story/ACT3_OUTLINE.md §7."""
    random.seed(41)
    WITH_CAELAN = ["kael", "taren", "lyra", "caelan"]
    WITH_SERA = ["kael", "taren", "lyra", "sera"]
    BAND = [
        ("Wood: 2 Shade Stalkers", ["shade_stalker", "shade_stalker"]),
        ("Wood: Lost One + Briar Hulk", ["lost_one", "briar_hulk"]),
        ("Wood: 2 Moth Swarms + Lost One", ["night_moth_swarm", "night_moth_swarm", "lost_one"]),
        ("Doors: Door Warden + 2 Moths", ["door_warden", "night_moth_swarm", "night_moth_swarm"]),
    ]
    # The groups that ship in scr_encounter_tables: grp_burn_line_hulk, grp_blackwood_matriarch
    # (the Matriarch's existing one Stalker add) and grp_door_warden_boss.
    BOSSES = [
        ("Ch 6: Burn-Line Hulk + Stalker", ["burn_line_hulk", "shade_stalker"]),
        ("Ch 7: Matriarch + Stalker", ["blackwood_matriarch", "shade_stalker"]),
        ("Ch 8: Door Warden + 2 Sentinels", ["door_warden_boss", "ward_sentinel_late", "ward_sentinel_late"]),
    ]
    print()
    print("**Blackwood band sanity (Chapter 6, level 18)** — Kael / Taren / Lyra / Caelan")
    print()
    print("| Fight | Win % | Rounds | Party turns | Party HP left |")
    print("|---|---|---|---|---|")
    for label, eids in BAND:
        r = run_ext(label, 18, WITH_CAELAN, eids, gear=GEAR_LATE, boss_focus=False)
        print(f"| {r['label']} | {r['win']*100:.0f}% | {r['rounds']:.1f} | {r['pturns']:.1f} | {r['hp']*100:.0f}% |")
    print()
    print("**Act III bosses** — win % and rounds. \"Hits on boss\" counts party hits, so Lyra's")
    print("Twin Cut (two hits per turn) scores 2. \"Deaths\" is the average party members down at the win.")
    print()
    print("| Fight | Lv | Party | Win % | Rounds | Party turns | Hits on boss | Deaths | Party HP left |")
    print("|---|---|---|---|---|---|---|---|---|")
    CHAPTER_LEVEL = {"Ch 6": 18, "Ch 7": 19, "Ch 8": 20}
    for label, eids in BOSSES:
        for L in sorted({CHAPTER_LEVEL[label.split(":")[0]], 20}):
            for members in (WITH_CAELAN, WITH_SERA):
                r = run_ext(label, L, members, eids, gear=GEAR_LATE, boss_focus=True)
                print(f"| {r['label']} | {L} | {r['members']} | {r['win']*100:.0f}% | {r['rounds']:.1f} | "
                      f"{r['pturns']:.1f} | {r['boss']:.1f} | {r['deaths']:.2f} | {r['hp']*100:.0f}% |")
    print()
    print("| Level | Kael ATK/DEF/HP | Taren ATK/DEF/HP | Lyra ATK/DEF/HP | Caelan ATK/DEF/HP | Sera ATK/DEF/HP | Hits to kill Hulk (K/T/L) | Matriarch (K/T) | Door Warden (K/T/L) |")
    print("|---|---|---|---|---|---|---|---|---|")
    for L in (18, 19, 20):
        ms = {m: member(m, L, *GEAR_LATE[m]) for m in ("kael", "taren", "lyra", "caelan", "sera")}
        def kh(eid, who):
            e = E[eid]
            return "/".join(str(math.ceil(e["hp"] / max(1, ms[m]["atk"] - e["df"] // 2))) for m in who)
        print(f"| {L} | " + " | ".join(f"{ms[m]['atk']} / {ms[m]['df']} / {ms[m]['max_hp']}"
                                       for m in ("kael", "taren", "lyra", "caelan", "sera"))
              + f" | {kh('burn_line_hulk', ('kael','taren','lyra'))} | {kh('blackwood_matriarch', ('kael','taren'))}"
              + f" | {kh('door_warden_boss', ('kael','taren','lyra'))} |")
    print()
    print("**HP lever** (x boss HP only, chapter level, party of four with Caelan): what a future")
    print("pass would buy, and the record of why the shipped numbers sit where they do.")
    print()
    print("**What if the bosses had more HP?** (x boss HP only, chapter level, party of four)")
    print()
    print("| Fight | Lv | HP x | Win % | Rounds | Deaths | Party HP left |")
    print("|---|---|---|---|---|---|---|")
    for label, level, eids in (("Ch 6: Hulk + 2 Stalkers", 18, BOSSES[0][1]),
                               ("Ch 7: Matriarch + Stalker", 19, BOSSES[1][1]),
                               ("Ch 8: Warden + 2 Sentinels", 20, BOSSES[2][1])):
        for mult in (1.0, 1.25, 1.5):
            r = run_ext(label, level, WITH_CAELAN, eids, gear=GEAR_LATE, boss_focus=True,
                        n=2000, boss_hp_mult=mult)
            print(f"| {r['label']} | {level} | {mult:.1f} | {r['win']*100:.0f}% | {r['rounds']:.1f} | "
                  f"{r['deaths']:.2f} | {r['hp']*100:.0f}% |")
    print()

# ---- Batches 7–8 template check (scr_enemy_scaled) ---------------------------------------
def scaled(role, level, party=1, hp_mult=1.0, def_add=0):
    d = level - 9
    hp, atk, df = 44 + 9 * d, 13 + 3 * d, 11 + 2 * d
    if role == "elite": hp *= 2; atk += 2; df += 2
    if role == "boss": hp = round(hp * 1.2 * max(1, party)); atk += 3; df += 3
    return dict(hp=round(hp * hp_mult), atk=atk, df=df + def_add)

def template_table():
    print()
    print("| Enemy level | Role | HP / ATK / DEF | Kael hits to kill (same level, Ch2 gear) | Damage to Kael per hit |")
    print("|---|---|---|---|---|")
    for L in (11, 14, 17, 19):
        k = member("kael", L, *GEAR["kael"])
        for role, party in (("common", 1), ("elite", 1), ("boss", 4)):
            e = scaled(role, L, party)
            print(f"| {L} | {role}{' (party 4)' if role == 'boss' else ''} | {e['hp']} / {e['atk']} / {e['df']} | "
                  f"{math.ceil(e['hp'] / dmg(k['atk'], e['df']))} | {dmg(e['atk'], k['df'])} of {k['max_hp']} HP |")

if __name__ == "__main__" and "--templates" in sys.argv:
    template_table()

if __name__ == "__main__":
    c3_tables()
    ch45_tables()
    ch4_prejoin_table()
    ch6_tables()

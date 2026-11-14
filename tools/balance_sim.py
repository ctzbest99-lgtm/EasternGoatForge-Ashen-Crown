#!/usr/bin/env python3
"""Ashen Crown balance sim (feature/balance-pass). Mirrors the GML battle formulas:
damage = max(1, ATK - floor(DEF/2)); skill power floors; Guard halves the next hit (enemy) or
all hits until next round (party); buffs tick at round start; SPD order with a <1 tiebreak.
No in-battle healing exists, so a fight is "won" only if the party survives on its own HP.
Run: python3 tools/balance_sim.py   (prints the markdown tables used in DECISIONS)."""
import random, math, statistics, sys

# ---- party growth (mirrors scr_game_constants / scr_progression) --------------------------
BASE = {"kael": dict(hp=30, atk=6, df=2, spd=10, mp=6),
        "taren": dict(hp=36, atk=8, df=3, spd=9, mp=12)}
LOW = dict(hp=4, atk=1, df=1, mp=2, spd=1)      # level-ups to L2..L7 (Chapter 1, unchanged)
HIGH = dict(hp=10, atk=2, df=2, mp=3, spd=1)    # level-ups to L8+ (LEVEL_UP_*_GROWTH_HIGH)
TIER_LEVEL = 8

def member(mid, level, weapon, armor):
    b = BASE[mid]; s = dict(b)
    for L in range(2, level + 1):
        g = HIGH if L >= TIER_LEVEL else LOW
        s["hp"] += g["hp"]; s["atk"] += g["atk"]; s["df"] += g["df"]; s["mp"] += g["mp"]; s["spd"] += g["spd"]
    s["atk"] += weapon; s["df"] += armor
    return dict(id=mid, name=mid.title(), max_hp=s["hp"], hp=s["hp"], atk=s["atk"], df=s["df"],
                spd=s["spd"], mp=s["mp"], buffs=[], guard=False, side="party")

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
                               mp=e.get("mp", 0), stance=False, yielded=False)
    return e

def pick(ai, e, allies):
    opts = []
    for s, w in ai:
        if s == "shout" and (allies == 0 or e["mp"] < 6): continue
        if s == "brace" and any(b[0] == "df" for b in e["buffs"]): continue
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

# ---- Batches 7–8 template check (scr_enemy_scaled) ---------------------------------------
def scaled(role, level, party=1, hp_mult=1.0, def_add=0):
    d = level - 9
    hp, atk, df = 44 + 7 * d, 13 + 2 * d, 11 + 2 * d
    if role == "elite": hp *= 2; atk += 2; df += 2
    if role == "boss": hp = round(hp * 1.5 * max(1, party)); atk += 3; df += 3
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

/// scr_skill_data — data-driven skill table for party members and enemies (feature/battle-upgrade).
///
/// Every skill is a struct:
///   id, name        — lookup id and display name
///   mp_cost         — MP spent when the skill resolves (0 = free)
///   target          — relative to the user: "single" (one opponent), "all" (every living opponent),
///                     "self", "ally" (one living ally, self included), "all_allies" (user's whole living side)
///   effect          — "damage" | "buff" | "guard" | "heal" | "flavor" (visual / message only) | "passive"
///   power           — damage multiplier on the normal Attack formula (damage) or HP amount (heal)
///   element         — "none" or an element id; matching the target's `weakness` multiplies damage
///                     by BATTLE_WEAKNESS_MULTIPLIER
///   dmg_type        — "phys" (ATK vs DEF) or "mag" (ATK vs MDEF)
///   buffs           — [{ stat: "atk"|"def"|"mdef"|"spd", pct, turns }] applied by "buff" skills (turns -1 = rest of battle)
///   resists         — passive only: status ids the owner ignores (e.g. "fear", "stun")
///   anim            — battle clip played by the user (missing clips never block the state machine)
///   verb            — message text after the user's name, e.g. "braces!"
///   cond            — AI-only gate: "" | "has_allies" (needs another living member on its side) | "no_def_buff"
///   fx_frame        — attack frame (0-based) that spawns the projectile; -1 = spawn when the hit lands
///   projectile      — optional sprite name flown from user to target (e.g. moth dust), with projectile_frames
///   status          — "status" effect: status id ("blind" | "sleep" | "veiled" ...), status_turns, status_chance
///   steal_min / _max — "steal" effect: damage plus this much shared gold (returned if the thief is beaten)
///   (effects added for batches 7–8: "status", "steal"; target "ally_lowest" = most-hurt living ally)
///   placeholder     — true when any number is not approved (all of them, for now)
///   desc            — one-line help text for the Skill menu
///
/// Taren's kit text is canon (STORY_BIBLE.md §5.5, CHAPTER2_SCRIPT.md WF_CALDER_SYS_03 / 03B):
///   Rallying Cry raises the party's Attack for 3 turns; Cleave hits all enemies for reduced damage;
///   Unbowed (passive) resists Fear and Stun. MP costs and percentages are [O] — the numbers below
///   are PLACEHOLDERS and are listed in docs/DECISIONS_AND_OPEN_QUESTIONS.md.

function scr_skill_make(_id, _name, _mp, _target, _effect, _power = 1, _anim = "attack", _verb = "") {
    return {
        id: _id,
        name: _name,
        mp_cost: _mp,
        target: _target,
        effect: _effect,
        power: _power,
        element: "none",
        dmg_type: "phys",
        buffs: [],
        resists: [],
        anim: _anim,
        verb: _verb,
        cond: "",
        fx_frame: -1,
        projectile: "",
        projectile_frames: 1,
        status: "",
        status_turns: 0,
        status_chance: 1,
        steal_min: 0,
        steal_max: 0,
        placeholder: true,
        desc: ""
    };
}

/// Skill struct by id (cached in global.skill_cache; treat the result as read-only).
/// Unknown ids fall back to a plain Attack so bad data cannot crash a battle.
function scr_skill_get(_skill_id) {
    if (!variable_global_exists("skill_cache") || !is_struct(global.skill_cache)) global.skill_cache = {};
    var _key = is_string(_skill_id) ? _skill_id : string(_skill_id);
    if (variable_struct_exists(global.skill_cache, _key)) return global.skill_cache[$ _key];
    var _built = scr_skill_build(_key);
    global.skill_cache[$ _key] = _built;
    return _built;
}

function scr_skill_build(_skill_id) {
    var _s;
    switch (_skill_id) {
        // ---- Shared -------------------------------------------------------------------------
        case "attack":
            _s = scr_skill_make("attack", "Attack", 0, "single", "damage", 1, "attack", "attacks");
            _s.placeholder = false;
            return _s;

        // ---- Taren Holt (canon kit text; PLACEHOLDER numbers) -----------------------------
        case "rallying_cry":
            _s = scr_skill_make("rallying_cry", "Rallying Cry", 4, "all_allies", "buff", 0, "skill_rally", "raises a Rallying Cry!"); // spr_taren_skill_rally_strip6
            _s.buffs = [{ stat: "atk", pct: 0.25, turns: 3 }]; // 3 turns is canon; +25% and 4 MP are PLACEHOLDER
            _s.desc = "Party ATK up for 3 turns.";
            return _s;
        case "cleave":
            _s = scr_skill_make("cleave", "Cleave", 3, "all", "damage", 0.6, "skill_cleave", "Cleaves"); // spr_taren_skill_cleave_strip6
            _s.desc = "Hit all enemies, reduced damage."; // 60% power and 3 MP are PLACEHOLDER
            return _s;
        case "unbowed":
            _s = scr_skill_make("unbowed", "Unbowed", 0, "self", "passive", 0, "", "");
            _s.resists = ["fear", "stun"]; // canon: resists Fear and Stun (no enemy inflicts either yet)
            _s.placeholder = false;
            _s.desc = "Passive: resists Fear and Stun.";
            return _s;

        // ---- Chapter 1 enemy kits (keep Chapter 1 behaviour: specials are visual only) -----
        case "wolf_howl":
            return scr_skill_make("wolf_howl", "Howl", 0, "self", "flavor", 0, "howl", "howls!");
        case "wretch_scream":
            return scr_skill_make("wretch_scream", "Scream", 0, "self", "flavor", 0, "scream", "screams!");
        case "spider_web":
            return scr_skill_make("spider_web", "Web", 0, "single", "flavor", 0, "cast", "casts a web! (visual only)");
        case "shield_wall":
            return scr_skill_make("shield_wall", "Shield Wall", 0, "self", "guard", 0, "guard", "raises a Shield Wall!");
        case "bg_shieldbash":
            return scr_skill_make("bg_shieldbash", "Shield Bash", 0, "single", "damage", 1, "shieldbash", "");
        case "bg_lunge":
            return scr_skill_make("bg_lunge", "Dark Lunge", 0, "single", "damage", 1, "lunge", "");
        case "bg_oath":
            return scr_skill_make("bg_oath", "Blood Oath", 0, "self", "flavor", 0, "oath", "swears a Blood Oath!");
        case "bg_execution":
            return scr_skill_make("bg_execution", "Execution", 0, "single", "damage", 1, "execution", "");

        // ---- Act II enemy kits (Design batch 6; PLACEHOLDER numbers) -----------------------
        case "thrust": // crown_patrolman
            return scr_skill_make("thrust", "Thrust", 0, "single", "damage", 1.2, "attack", "");
        case "brace": // crown_patrolman
            _s = scr_skill_make("brace", "Brace", 0, "self", "buff", 0, "brace", "braces! (DEF up)");
            _s.buffs = [{ stat: "def", pct: 0.5, turns: 2 }];
            _s.cond = "no_def_buff";
            return _s;
        case "crossbow_bolt": // crown_crossbowman: bolt spawns on attack frame index 3
            _s = scr_skill_make("crossbow_bolt", "Bolt", 0, "single", "damage", 1, "attack", "");
            _s.fx_frame = 3;
            return _s;
        case "slash": // occupation_soldier
            return scr_skill_make("slash", "Slash", 0, "single", "damage", 1.1, "attack", "");
        case "soldier_guard": // occupation_soldier
            return scr_skill_make("soldier_guard", "Guard", 0, "self", "guard", 0, "guard", "raises his shield!");
        case "heavy_strike": // reeve_calder
            return scr_skill_make("heavy_strike", "Heavy Strike", 0, "single", "damage", 1.3, "attack", "");
        case "calder_guard": // reeve_calder
            return scr_skill_make("calder_guard", "Guard", 0, "self", "guard", 0, "guard", "takes a guard!");
        case "calder_shout": // reeve_calder: "a shout that buffs his soldiers"
            _s = scr_skill_make("calder_shout", "Rallying Shout", 6, "all_allies", "buff", 0, "shout", "shouts orders! (Crown ATK up)");
            _s.buffs = [{ stat: "atk", pct: 0.25, turns: 3 }];
            _s.cond = "has_allies";
            return _s;

        // ---- Batch 7 kits (Wrenfield elite, Lower City, Hollow Sanctuary, Garrison) — PLACEHOLDER --
        case "sergeant_rally": // crown_sergeant: rally that buffs allies (cast clip)
            _s = scr_skill_make("sergeant_rally", "Rally", 0, "all_allies", "buff", 0, "cast", "rallies the line! (ATK up)");
            _s.buffs = [{ stat: "atk", pct: 0.2, turns: 3 }];
            _s.cond = "has_allies";
            return _s;
        case "cutpurse_steal": // cutpurse: light hit + steals shared gold
            _s = scr_skill_make("cutpurse_steal", "Steal", 0, "single", "steal", 0.6, "steal", "");
            _s.steal_min = 8;
            _s.steal_max = 20;
            return _s;
        case "debtman_reel": // debtman: hook reel / yank
            return scr_skill_make("debtman_reel", "Hook Reel", 0, "single", "damage", 1.25, "reel", "");
        case "wisp_mote": // glyph_wisp: light mote (magic), mote spawns on cast frame 3
            _s = scr_skill_make("wisp_mote", "Mote", 0, "single", "damage", 1.1, "cast", "");
            _s.dmg_type = "mag";
            _s.fx_frame = 3;
            _s.projectile = "spr_glyph_wisp_mote_strip3";
            _s.projectile_frames = 3;
            return _s;
        case "warden_ring": // sanctuary_warden: ring pulse, hits everyone
            _s = scr_skill_make("warden_ring", "Ring Pulse", 0, "all", "damage", 0.7, "special", "");
            _s.dmg_type = "mag";
            return _s;
        case "surgeon_heal": // garrison_field_surgeon: heals the most-hurt ally (sage pulse)
            _s = scr_skill_make("surgeon_heal", "Field Dressing", 0, "ally_lowest", "heal", 30, "cast", "dresses a wound!");
            _s.cond = "ally_hurt";
            return _s;
        case "pike_thrust": // garrison_pikeman
            return scr_skill_make("pike_thrust", "Pike Thrust", 0, "single", "damage", 1.2, "attack", "");
        case "hailen_glint": // commander_hailen: blessed-steel glint (white / steel only)
            return scr_skill_make("hailen_glint", "Steel Glint", 0, "single", "damage", 1.4, "special", "");

        // ---- Batch 8 kits (Act III, the Blackwood) — PLACEHOLDER ---------------------------
        case "shade_fade": // shade_stalker: fades out; attacks miss it until the next round
            _s = scr_skill_make("shade_fade", "Fade", 0, "self", "status", 0, "special", "fades into the dark!");
            _s.status = "veiled";
            _s.status_turns = 1;
            _s.cond = "not_veiled";
            return _s;
        case "moth_blind": // night_moth_swarm: blinding dust (dust spawns on cast frame 3)
            _s = scr_skill_make("moth_blind", "Blinding Dust", 0, "single", "status", 0, "cast", "");
            _s.status = "blind";
            _s.status_turns = 3;
            _s.status_chance = 0.7;
            _s.fx_frame = 3;
            _s.projectile = "spr_night_moth_swarm_dust_strip4";
            _s.projectile_frames = 4;
            return _s;
        case "moth_sleep": // night_moth_swarm: sleeping dust
            _s = scr_skill_make("moth_sleep", "Drowsy Dust", 0, "single", "status", 0, "cast", "");
            _s.status = "sleep";
            _s.status_turns = 2;
            _s.status_chance = 0.5;
            _s.fx_frame = 3;
            _s.projectile = "spr_night_moth_swarm_dust_strip4";
            _s.projectile_frames = 4;
            return _s;
        case "matriarch_breath": // blackwood_matriarch: ash-breath / bellow, hits everyone
            return scr_skill_make("matriarch_breath", "Ash Breath", 0, "all", "damage", 0.8, "special", "");
    }
    show_debug_message("[skill] Unknown skill id '" + string(_skill_id) + "'; using Attack.");
    return scr_skill_build("attack");
}

/// True if `_skill_id` is a passive (never listed under the Skill command).
function scr_skill_is_passive(_skill_id) {
    return scr_skill_get(_skill_id).effect == "passive";
}

/// Active skills an actor can pick from the Skill menu (passives filtered out).
function scr_skill_list_active(_actor) {
    var _out = [];
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "skills") || !is_array(_actor.skills)) return _out;
    for (var _i = 0; _i < array_length(_actor.skills); _i++) {
        if (!scr_skill_is_passive(_actor.skills[_i])) array_push(_out, _actor.skills[_i]);
    }
    return _out;
}

function scr_skill_can_afford(_actor, _skill_id) {
    if (!is_struct(_actor)) return false;
    var _mp = variable_struct_exists(_actor, "mp") ? _actor.mp : 0;
    return _mp >= scr_skill_get(_skill_id).mp_cost;
}

/// True when the skill needs the player to pick a target (single opponent or one ally).
function scr_skill_needs_target(_skill_id) {
    var _t = scr_skill_get(_skill_id).target;
    return (_t == "single" || _t == "ally"); // "ally_lowest" is AI-only (picked automatically)
}

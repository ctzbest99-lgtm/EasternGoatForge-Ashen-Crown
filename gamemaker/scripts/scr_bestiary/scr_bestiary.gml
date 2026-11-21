/// scr_bestiary — the Bestiary record (Adventure menu, spec §12).
/// global.game.bestiary is { "<enemy_id>": { seen: bool, defeated: int } } and is saved
/// (SAVE_SCHEMA_VERSION 3+). Nothing here changes combat balance.
///
/// Canon pass (2026-11-18): the descriptions in scr_bestiary_desc() restate the story
/// docs and enemy data instead of inventing lore. Bestiary text uses "Architects" per
/// the naming rule, and open questions (the Ash, the Crownveil, the Aethari's fate)
/// stay unanswered. Each line fits scr_bestiary_desc_fit()'s 72-character budget.

/// Every enemy the database knows about, in Bestiary order (Act 1 onward).
function scr_bestiary_ids() {
    return [
        "bandit", "fallen_knight", "ash_wolf", "ashen_wretch", "grave_spider", "hollow_soldier",
        "ashbound_hunter", "emberwake", "crown_patrolman", "crown_crossbowman", "bandit_veteran", "grey_ash_wolf",
        "occupation_soldier", "crown_sergeant", "blackguard", "reeve_calder",
        "dock_thug", "cutpurse", "debt_collector", "debtman",
        "ward_sentinel", "glyph_wisp", "aethari_automaton", "sanctuary_warden",
        "garrison_pikeman", "garrison_field_surgeon", "garrison_knight", "commander_hailen",
        "shade_stalker", "briar_hulk", "burn_line_hulk", "lost_one", "night_moth_swarm", "door_warden",
        "door_warden_boss", "blackwood_matriarch",
        "crown_guard_elite", "barrow_husk", "oath_iron", "grave_moth",
        "magistrate_vell", "barrow_warden", "forgotten_king"
    ];
}

/// Number of entries the Bestiary lists.
function scr_bestiary_count() {
    return array_length(scr_bestiary_ids());
}

/// The bestiary struct, created on demand (also repairs an older save's payload).
function scr_bestiary_init() {
    scr_game_state_init();
    if (!variable_struct_exists(global.game, "bestiary") || !is_struct(global.game.bestiary)) {
        global.game.bestiary = {};
    }
    return global.game.bestiary;
}

/// One enemy's record, created on first use. Safe to call on any id.
/// Ids that share another enemy's record: the same creature at a different level. Level variants
/// exist for later acts (the level-20 Ward Sentinel, the Chapter 3 road patrols), so their kills
/// are recorded on the base creature's row instead of adding a second entry with the same name
/// that nobody can tell apart.
function scr_bestiary_alias(_enemy_id) {
    switch (_enemy_id) {
        case "ward_sentinel_late":      return "ward_sentinel";
        case "crown_patrolman_road":    return "crown_patrolman";
        case "crown_crossbowman_road":  return "crown_crossbowman";
        case "bandit_veteran_road":     return "bandit_veteran";
        // Emberwake's early boss fight and its later ordinary appearances are one creature.
        case "emberwake_boss":          return "emberwake";
        case "emberwake_late":          return "emberwake";
    }
    return _enemy_id;
}

function scr_bestiary_record(_enemy_id) {
    var _b = scr_bestiary_init();
    var _key = string(_enemy_id);
    if (!variable_struct_exists(_b, _key) || !is_struct(_b[$ _key])) {
        _b[$ _key] = { seen: false, defeated: 0 };
    }
    var _r = _b[$ _key];
    if (!variable_struct_exists(_r, "seen")) _r.seen = false;
    if (!variable_struct_exists(_r, "defeated")) _r.defeated = 0;
    return _r;
}

/// Called at battle start for every enemy on the field.
function scr_bestiary_mark_seen(_enemy_id) {
    if (!is_string(_enemy_id) && !is_real(_enemy_id)) return;
    var _r = scr_bestiary_record(scr_bestiary_alias(_enemy_id));
    _r.seen = true;
}

/// Called when an enemy is beaten (or yields, ending its part in the fight).
function scr_bestiary_mark_defeated(_enemy_id) {
    if (!is_string(_enemy_id) && !is_real(_enemy_id)) return;
    var _r = scr_bestiary_record(scr_bestiary_alias(_enemy_id));
    _r.seen = true;
    _r.defeated += 1;
}

function scr_bestiary_is_seen(_enemy_id) {
    var _b = scr_bestiary_init();
    var _key = string(scr_bestiary_alias(_enemy_id));
    if (!variable_struct_exists(_b, _key) || !is_struct(_b[$ _key])) return false;
    return variable_struct_exists(_b[$ _key], "seen") && _b[$ _key].seen;
}

function scr_bestiary_defeated_count(_enemy_id) {
    var _r = scr_bestiary_record(_enemy_id);
    return max(0, _r.defeated);
}

/// How many entries have been encountered (the "12/43" counter).
function scr_bestiary_seen_total() {
    var _ids = scr_bestiary_ids();
    var _n = 0;
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (scr_bestiary_is_seen(_ids[_i])) _n += 1;
    }
    return _n;
}

/// Illustration sprite for a Bestiary entry: frame 0 of that enemy's battle idle sheet.
/// Returns -1 when the enemy has no art (the pane then draws a "?" plate).
function scr_bestiary_sprite(_enemy_id) {
    var _kind = scr_battle_kind_from_id(_enemy_id);
    if (!is_string(_kind) || _kind == "") _kind = string(_enemy_id);
    var _candidates = [
        "spr_" + _kind + "_idle_strip4",
        "spr_" + _kind + "_idle_strip8",
        "spr_" + _kind + "_idle_strip6",
        "spr_" + _kind + "_idle_strip2",
        "spr_" + _kind + "_idle_p2_strip8",
        "spr_" + _kind + "_idle"
    ];
    for (var _i = 0; _i < array_length(_candidates); _i++) {
        var _s = scr_sprite_index(_candidates[_i]);
        if (scr_sprite_is_valid(_s)) return _s;
    }
    return -1;
}

/// The monster plate on the Bestiary pane: a sunken frame with the enemy's idle frame
/// centred inside it. `_seen` false draws the same art as a black silhouette, the usual
/// bestiary convention: the shape teases an unrecorded monster without naming it.
/// `_x,_y,_w,_h` is the frame's box; the sprite is scaled to fit and never enlarged past 1x.
function scr_bestiary_draw_illustration(_enemy_id, _seen, _x, _y, _w, _h) {
    draw_set_alpha(1);
    // A recorded monster sits on a lighter plate; an unrecorded one on near-black, so a
    // silent silhouette never reads as "just a dark sprite".
    draw_set_color(_seen ? make_color_rgb(26, 30, 40) : make_color_rgb(10, 12, 18));
    draw_rectangle(_x, _y, _x + _w - 1, _y + _h - 1, false);
    draw_set_color(MENU_COL_A);
    draw_rectangle(_x, _y, _x + _w - 1, _y + _h - 1, true);

    var _spr = scr_bestiary_sprite(_enemy_id);
    if (!scr_sprite_is_valid(_spr)) {
        scr_menu_text(_x + _w * 0.5 - 3, _y + _h * 0.5 - 4, "?", MENU_COL_A);
        return;
    }
    var _sw = max(1, sprite_get_width(_spr));
    var _sh = max(1, sprite_get_height(_spr));
    var _scale = min(_w / _sw, _h / _sh, 1);
    var _dw = _sw * _scale;
    var _dh = _sh * _scale;
    var _px = _x + (_w - _dw) * 0.5 + sprite_get_xoffset(_spr) * _scale;
    var _py = _y + (_h - _dh) * 0.5 + sprite_get_yoffset(_spr) * _scale;

    // Contact shadow, so the monster stands on the plate instead of floating.
    draw_set_color(make_color_rgb(6, 7, 10));
    draw_ellipse(_px - _dw * 0.26, _py + _dh - 2, _px + _dw * 0.26, _py + _dh + 1, false);

    if (_seen) {
        draw_sprite_ext(_spr, 0, _px, _py, _scale, _scale, 0, c_white, 1);
    } else {
        draw_sprite_ext(_spr, 0, _px, _py, _scale, _scale, 0, c_black, 1);
    }
    draw_set_alpha(1);
}

/// Bestiary stats for one enemy, read from the combat database (no balance changes).
function scr_bestiary_entry(_enemy_id) {
    var _data = scr_get_enemy_data(_enemy_id);
    var _out = {
        id: string(_enemy_id),
        name: string(_enemy_id),
        short_name: "",
        level: 1,
        role: "",
        hp: 0,
        attack: 0,
        defense: 0,
        mdef: 0,
        spd: 0,
        weakness: "",
        area: "",
        xp: 0,
        gold: 0,
        seen: scr_bestiary_is_seen(_enemy_id),
        defeated: scr_bestiary_defeated_count(_enemy_id),
        desc: scr_bestiary_desc(_enemy_id)
    };
    if (is_struct(_data)) {
        if (variable_struct_exists(_data, "name")) _out.name = string(_data.name);
        if (variable_struct_exists(_data, "short_name")) _out.short_name = string(_data.short_name);
        if (variable_struct_exists(_data, "level")) _out.level = _data.level;
        if (variable_struct_exists(_data, "role")) _out.role = string(_data.role);
        if (variable_struct_exists(_data, "max_hp")) _out.hp = _data.max_hp;
        if (variable_struct_exists(_data, "attack")) _out.attack = _data.attack;
        if (variable_struct_exists(_data, "defense")) _out.defense = _data.defense;
        if (variable_struct_exists(_data, "mdef")) _out.mdef = _data.mdef;
        if (variable_struct_exists(_data, "spd")) _out.spd = _data.spd;
        if (variable_struct_exists(_data, "weakness")) _out.weakness = string(_data.weakness);
        if (variable_struct_exists(_data, "xp_reward")) _out.xp = _data.xp_reward;
        if (variable_struct_exists(_data, "gold_reward")) _out.gold = _data.gold_reward;
    }
    _out.area = scr_enemy_battle_area(_enemy_id);
    return _out;
}

/// Region label used by the Bestiary detail pane.
function scr_bestiary_area_label(_area) {
    switch (string(_area)) {
        case "forest":      return "Greyhaven / ashfall";
        case "watchtower":  return "Old Watchtower";
        case "crownveil":   return "Crownveil";
        case "saltreach":   return "Saltreach";
        case "ironspine":   return "Ironspine";
        case "blackwood":   return "Blackwood";
        case "frost":       return "Rimehold";
        default:            return (_area == "") ? "Unknown" : string(_area);
    }
}

/// Keep a description inside the Bestiary pane's three-line budget (148 px at 6 px per
/// glyph = 24 characters a line, so 72 characters before wrapping costs a fourth line). Anything longer is cut at a word boundary and closed with an ellipsis, so a future
/// entry can never push the "Weak" / "Found" rows off the plate.
function scr_bestiary_desc_fit(_desc, _max = 72) {
    var _s = string(_desc);
    if (string_length(_s) <= _max) return _s;
    var _cut = _max;
    while (_cut > 0 && string_char_at(_s, _cut) != " ") _cut -= 1;
    if (_cut <= 0) _cut = _max;
    return string_copy(_s, 1, _cut) + "...";
}

/// One-line description per enemy, kept inside the Bestiary pane's 72-character budget.
function scr_bestiary_desc(_enemy_id) {
    switch (string(_enemy_id)) {
        case "bandit":                  return "A road bandit outside Greyhaven; fights with a cheap shot.";
        case "fallen_knight":           return "A Fallen Knight in Watchtower plate; slow and hard to put down.";
        case "ash_wolf":                return "A lean wolf of the ash fields and the old road.";
        case "ashen_wretch":            return "A body that will not lie still.";
        case "grave_spider":            return "A grave spider of the Watchtower; fast and venomous.";
        case "hollow_soldier":          return "A Watchtower soldier's shape, still in its armor.";
        case "ashbound_hunter":         return "An Ashbound hunter; it tracks the party and fears cold.";
        case "emberwake":              return "A firebird of the Old Road; it fights with flame.";
        case "crown_patrolman":         return "A Crown patrolman on the Millhaven road; spear and shield.";
        case "crown_crossbowman":       return "A Crown crossbowman; holds the back rank.";
        case "occupation_soldier":      return "A Crown occupation soldier at Wrenfield's checkpoints.";
        case "bandit_veteran":          return "A bandit veteran of the Millhaven road.";
        case "grey_ash_wolf":           return "A grey ash wolf of the Millhaven road.";
        case "crown_sergeant":          return "A Crown sergeant holding the Wrenfield approach.";
        case "blackguard":              return "The Watchtower's Blackguard; plate, blade and three phases.";
        case "reeve_calder":            return "Wrenfield's occupation reeve; he yields and withdraws.";
        case "dock_thug":               return "Hired muscle in Valemere's Lower City.";
        case "cutpurse":                return "A Lower City cutpurse; lifts coin mid-fight.";
        case "debt_collector":          return "A Lower City collector who works for the Debtman.";
        case "debtman":                 return "The Lower City enforcer called the Debtman; he yields.";
        case "ward_sentinel":           return "Architect stonework, still standing its watch.";
        case "glyph_wisp":              return "A mote of old glyph-light; quick and fragile.";
        case "aethari_automaton":       return "Architect clockwork, still doing work nobody needs.";
        case "sanctuary_warden":        return "The Hollow Sanctuary's Warden; it guards the inner door.";
        case "garrison_pikeman":        return "A Blackwood Road Garrison pikeman; reach and drill.";
        case "garrison_field_surgeon":  return "The garrison's field surgeon; it mends the line mid-fight.";
        case "garrison_knight":         return "A garrison knight; plate, shield and patience.";
        case "commander_hailen":        return "Commander Hailen of the Blackwood Road Garrison.";
        case "shade_stalker":           return "A Blackwood shade with claws; holy light cuts it.";
        case "briar_hulk":              return "A thorn-grown hulk of the Blackwood; slow and hard to kill.";
        case "lost_one":                return "A Lost One of the Blackwood; still facing the shrine.";
        case "night_moth_swarm":        return "A cloud of Blackwood moths; their dust blinds and sleeps.";
        case "door_warden":             return "An Architect door-warden; it does not speak.";
        case "blackwood_matriarch":     return "The rooted matriarch of the glade; she does not yield.";
        case "crown_guard_elite":       return "Crown Guard elite; clean plate and a guard detail.";
        case "barrow_husk":             return "A body the barrow kept; slow and hard to put down.";
        case "oath_iron":               return "Crown oath-work; it holds the barrow door shut.";
        case "grave_moth":              return "A barrow moth; its dust brings blindness and sleep.";
        case "magistrate_vell":         return "Coleford's magistrate; a career clerk who yields.";
        case "barrow_warden":           return "A Crown construct set to keep the tomb shut.";
        case "forgotten_king":          return "A king's corpse kept by oath-work in the tomb.";
        case "burn_line_hulk":          return "The briar hulk that grew into Cinderhollow's burn line.";
        case "door_warden_boss":        return "The Door Warden at the sealed Architect doors.";
    }
    return "No record yet.";
}

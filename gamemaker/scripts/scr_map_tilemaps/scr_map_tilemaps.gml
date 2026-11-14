/// scr_map_tilemaps: shared helpers for building tile layers and spawning marker objects.
/// Tileset asset: ts_zone1 (from game/tilesets/ts_zone1.png, 16x16, no offset/spacing).
/// Tile 0 is empty, tile 1 is the collision tile.
///
/// Reconciled with the existing repo:
/// - obj_player already collides with a Tile layer named exactly "Collision"
///   (see obj_player Create). This script also appends that tilemap to
///   obj_player.collision_targets after the map is built, in case Create ran first.
/// - Markers spawn the existing obj_encounter_trigger, obj_encounter_zone (table_id /
///   enemy_table API unchanged), and obj_interactable. New: obj_zone_entrance.
/// - After a battle, obj_game_controller Room Start still restores the saved
///   position or the town respawn, and wins over the map's player_start placement
///   because Room Start runs after room Creation Code.
#macro MAP_TILESET ts_zone1

/// Layer names/depths. Create these Tile layers in the Room Editor (same names) so
/// obj_player finds "Collision" in its Create event; any that are missing are created
/// here at the listed depth.
/// Keep your Instances layer at depth 0. Ground/Decoration draw below the player.
/// Overhead is at a very low depth so it stays in front even when obj_player uses
/// `depth = -y` (sprites PR): at y=4800, depth=-4800, which would otherwise draw
/// in front of an Overhead layer at -100.
function scr_map_layer_defs() {
    return [
        { name: "Ground",     key: "ground",    depth: 400,    visible: true  },
        { name: "Decoration", key: "decor",     depth: 300,    visible: true  },
        { name: "Overhead",   key: "overhead",  depth: -10000, visible: true  },
        { name: "Collision",  key: "collision", depth: 500,    visible: false },
        { name: "Markers",    key: "markers",   depth: 600,    visible: false }
    ];
}

function scr_map_get_tilemap(_layer_name, _depth, _w, _h) {
    var _lay = layer_get_id(_layer_name);
    if (_lay == -1) _lay = layer_create(_depth, _layer_name);
    var _tm = layer_tilemap_get_id(_lay);
    if (_tm == -1) {
        _tm = layer_tilemap_create(_lay, 0, 0, MAP_TILESET, _w, _h);
    } else if (tilemap_get_width(_tm) < _w || tilemap_get_height(_tm) < _h) {
        tilemap_set_width(_tm, _w);
        tilemap_set_height(_tm, _h);
    }
    return _tm;
}

/// Little-endian u16 per tile, row-major. Returns false if the Included File is missing.
function scr_map_load_bin(_tm, _fname, _w, _h) {
    if (!file_exists(_fname)) return false;
    var _b = buffer_load(_fname);
    if (_b == -1) return false;
    if (buffer_get_size(_b) < _w * _h * 2) { buffer_delete(_b); return false; }
    buffer_seek(_b, buffer_seek_start, 0);
    for (var _y = 0; _y < _h; _y++) {
        for (var _x = 0; _x < _w; _x++) {
            var _t = buffer_read(_b, buffer_u16);
            if (_t != 0) tilemap_set(_tm, _t, _x, _y);
        }
    }
    buffer_delete(_b);
    return true;
}

/// One CSV row per tile row, comma separated. (_ox, _oy) = tile offset of this chunk.
function scr_map_load_csv(_tm, _fname, _ox, _oy) {
    if (!file_exists(_fname)) return false;
    var _f = file_text_open_read(_fname);
    var _y = 0;
    while (!file_text_eof(_f)) {
        var _line = file_text_read_string(_f);
        file_text_readln(_f);
        if (string_length(_line) == 0) continue;
        var _cells = string_split(_line, ",");
        for (var _x = 0; _x < array_length(_cells); _x++) {
            var _t = real(_cells[_x]);
            if (_t != 0) tilemap_set(_tm, _t, _ox + _x, _oy + _y);
        }
        _y++;
    }
    file_text_close(_f);
    return true;
}

/// _data = struct of flat row-major arrays keyed like scr_map_layer_defs().key
function scr_map_build_from_arrays(_data, _w, _h) {
    var _defs = scr_map_layer_defs();
    for (var _i = 0; _i < array_length(_defs); _i++) {
        var _def = _defs[_i];
        var _tm = scr_map_get_tilemap(_def.name, _def.depth, _w, _h);
        tilemap_clear(_tm, 0);
        var _a = _data[$ _def.key];
        for (var _n = 0; _n < _w * _h; _n++) {
            if (_a[_n] != 0) tilemap_set(_tm, _a[_n], _n mod _w, _n div _w);
        }
        layer_set_visible(layer_get_id(_def.name), _def.visible);
    }
    scr_map_hook_player_collision();
}

/// obj_player caches collision targets in Create; make sure the Collision tilemap is in that list.
function scr_map_hook_player_collision() {
    var _lay = layer_get_id("Collision");
    if (_lay == -1) return;
    var _tm = layer_tilemap_get_id(_lay);
    if (_tm == -1) return;
    with (obj_player) {
        if (variable_instance_exists(id, "collision_targets") && !array_contains(collision_targets, _tm)) {
            array_push(collision_targets, _tm);
        }
    }
}

function scr_map_find_marker(_markers, _name) {
    for (var _i = 0; _i < array_length(_markers); _i++) if (_markers[_i].name == _name) return _markers[_i];
    return undefined;
}

/// Place an instance so the sprite's bottom-centre sits on the marker's feet point (x, y).
/// Works for 16×16 (or 32×32) top-left placeholders and for a 16×24 / 32×48 bottom-centre origin.
/// Thin wrappers over the existing flag / inventory helpers so Design's
/// requires_flag / requires_item / sets_flag fields use one system.
function scr_map_flag_get(_flag) {
    return scr_flag_get(_flag);
}
function scr_map_flag_set(_flag) {
    scr_flag_set(_flag, true);
}
function scr_map_has_item(_item_id) {
    return scr_inventory_has(_item_id);
}
function scr_map_requirement_met(_m) {
    if (variable_struct_exists(_m, "requires_flag") && _m.requires_flag != "" && !scr_flag_get(_m.requires_flag)) return false;
    if (variable_struct_exists(_m, "requires_item") && _m.requires_item != "" && !scr_inventory_has(_m.requires_item)) return false;
    // Some markers use `requires` as a flag name (e.g. crownveil_door / blackguard_defeated).
    if (variable_struct_exists(_m, "requires") && is_string(_m.requires) && _m.requires != "" && !scr_flag_get(_m.requires)) return false;
    return true;
}

/// The guaranteed Watchtower Hunter may arrive as type "encounter" in Design's
/// markers; always use obj_story_encounter so the ENC_AH flow is kept, and scale
/// it to one walkable 16×16 tile.
function scr_map_is_guaranteed_hunter(_m) {
    if (variable_struct_exists(_m, "encounter_id") && _m.encounter_id == "enc_ashbound_hunter_wt") return true;
    if (variable_struct_exists(_m, "name") && _m.name == "enc_ashbound_hunter_wt") return true;
    return false;
}

function scr_map_filter_known_enemy_table(_rows) {
    var _out = [];
    if (!is_array(_rows)) return _out;
    for (var _i = 0; _i < array_length(_rows); _i++) {
        var _row = _rows[_i];
        if (is_struct(_row) && variable_struct_exists(_row, "enemy_id") && is_struct(scr_get_enemy_data(_row.enemy_id))) {
            array_push(_out, _row);
        }
    }
    return _out;
}

/// Scale an instance's sprite so it occupies one tile, then pin its feet to (_feet_x, _feet_y).
/// Needed when a 32×32 (or larger) placeholder would otherwise cover neighbouring tiles
/// (e.g. the royal banner covering the Ashbound Hunter trigger).
function scr_map_fit_to_tile(_inst, _feet_x, _feet_y, _tw = 16, _th = 16) {
    var _spr = _inst.sprite_index;
    if (_spr == -1 || !sprite_exists(_spr)) return;
    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    if (_sw <= 0 || _sh <= 0) return;
    _inst.image_xscale = _tw / _sw;
    _inst.image_yscale = _th / _sh;
    var _ox = sprite_get_xoffset(_spr) * _inst.image_xscale;
    var _oy = sprite_get_yoffset(_spr) * _inst.image_yscale;
    _inst.x = _feet_x - (_tw * 0.5 - _ox);
    _inst.y = _feet_y - (_th - _oy);
}

/// If the player is overlapping an obj_solid (or a child such as obj_interactable),
/// nudge them to the nearest free pixel. Called after spawn and on room start so a
/// marker sitting on player_start cannot soft-lock movement.
function scr_player_unstick() {
    if (!instance_exists(obj_player)) return false;
    with (obj_player) {
        if (!place_meeting(x, y, obj_solid)) return false;
        var _ox = x;
        var _oy = y;
        var _max = 48;
        for (var _r = 1; _r <= _max; _r++) {
            for (var _dy = -_r; _dy <= _r; _dy++) {
                for (var _dx = -_r; _dx <= _r; _dx++) {
                    if (_dx != -_r && _dx != _r && _dy != -_r && _dy != _r) continue;
                    var _nx = _ox + _dx;
                    var _ny = _oy + _dy;
                    if (_nx < 0 || _ny < 0 || _nx >= room_width || _ny >= room_height) continue;
                    if (!place_meeting(_nx, _ny, obj_solid)) {
                        x = _nx;
                        y = _ny;
                        return true;
                    }
                }
            }
        }
        return false;
    }
    return false;
}

function scr_map_create_at_feet(_object, _layer, _feet_x, _feet_y) {
    var _spr = object_get_sprite(_object);
    var _ox = 0;
    var _oy = 0;
    var _sw = 16;
    var _sh = 16;
    if (_spr != -1 && sprite_exists(_spr)) {
        _ox = sprite_get_xoffset(_spr);
        _oy = sprite_get_yoffset(_spr);
        _sw = sprite_get_width(_spr);
        _sh = sprite_get_height(_spr);
    }
    var _ix = _feet_x - (_sw * 0.5 - _ox);
    var _iy = _feet_y - (_sh - _oy);
    return instance_create_layer(_ix, _iy, _layer, _object);
}

/// Spawns gameplay objects for the markers. Objects that do not exist in the project are skipped.
/// Set global.map_spawn_name before room_goto() to arrive at a named marker (entrance / zone_exit / player_spawn).
function scr_map_spawn_markers(_markers) {
    var _lay = layer_exists("Instances") ? "Instances" : layer_get_name(layer_create(0, "Instances"));
    var _o_trig = asset_get_index("obj_encounter_trigger");
    var _o_zone = asset_get_index("obj_encounter_zone");
    var _o_int  = asset_get_index("obj_interactable");
    var _o_door = asset_get_index("obj_zone_entrance");
    var _o_resp = asset_get_index("obj_respawn_point");
    var _o_story = asset_get_index("obj_story_encounter");
    var _o_snpc = asset_get_index("obj_story_npc");
    var _o_trap = asset_get_index("obj_trap_plate");
    var _o_sttrig = asset_get_index("obj_story_trigger");
    var _o_solid = asset_get_index("obj_solid");
    var _o_save = asset_get_index("obj_save_point");
    var _spawn = undefined;
    var _town_square = undefined;
    if (variable_global_exists("map_spawn_name") && is_string(global.map_spawn_name) && global.map_spawn_name != "") {
        _spawn = scr_map_find_marker(_markers, global.map_spawn_name);
        global.map_spawn_name = "";
    }
    for (var _i = 0; _i < array_length(_markers); _i++) {
        var _m = _markers[_i];
        if (variable_struct_exists(_m, "name") && _m.name == "town_square") _town_square = _m;
        switch (_m.type) {
            case "player_spawn":
                if (_spawn == undefined) _spawn = _m;
                break;
            case "story_encounter":
            case "bandit_spawn":
            case "encounter":
            case "enemy_spawn":
            case "boss_spawn":
                if (scr_map_is_guaranteed_hunter(_m) && _o_story != -1) {
                    var _st = instance_create_layer(_m.tile_x * 16, _m.tile_y * 16, _lay, _o_story);
                    if (variable_struct_exists(_m, "encounter_id")) _st.encounter_id = _m.encounter_id;
                    if (variable_struct_exists(_m, "enemy_id")) _st.enemy_id = _m.enemy_id;
                    if (variable_struct_exists(_m, "script_id")) _st.script_id = _m.script_id;
                    var _hid = variable_struct_exists(_m, "enemy_id") ? _m.enemy_id : "ashbound_hunter";
                    scr_ch1_bind_enemy_ow(_st, _hid, _m);
                    var _sspr = _st.sprite_index;
                    if (_sspr != -1 && sprite_exists(_sspr) && sprite_get_width(_sspr) > 24) {
                        _st.image_xscale = 16 / sprite_get_width(_sspr);
                        _st.image_yscale = 16 / sprite_get_height(_sspr);
                    }
                    break;
                }
                if (_m.type == "story_encounter") break;
                if (_o_trig != -1) {
                    var _eid = _m.enemy_id;
                    if (!is_struct(scr_get_enemy_data(_eid)) && variable_struct_exists(_m, "fallback_enemy_id")) {
                        _eid = _m.fallback_enemy_id;
                    }
                    var _t = scr_map_create_at_feet(_o_trig, _lay, _m.x, _m.y);
                    _t.enemy_id = _eid;
                    _t.encounter_id = _m.encounter_id;
                    scr_ch1_bind_enemy_ow(_t, _eid, _m);
                }
                break;
            case "encounter_zone":
                if (_o_zone != -1) {
                    var _r = _m.rect_px;
                    var _z = instance_create_layer(_r[0], _r[1], _lay, _o_zone);
                    if (_z.sprite_index != -1 && sprite_get_width(_z.sprite_index) > 0 && sprite_get_height(_z.sprite_index) > 0) {
                        _z.image_xscale = (_r[2] - _r[0]) / sprite_get_width(_z.sprite_index);
                        _z.image_yscale = (_r[3] - _r[1]) / sprite_get_height(_z.sprite_index);
                    }
                    var _tid = _m.table_id;
                    var _tbl = scr_get_encounter_table(_tid);
                    if (is_undefined(_tbl) && variable_struct_exists(_m, "enemy_table")) {
                        _tbl = scr_map_filter_known_enemy_table(_m.enemy_table);
                        if (array_length(_tbl) == 0) _tbl = undefined;
                    }
                    if (is_undefined(_tbl) && variable_struct_exists(_m, "fallback_table_id")) {
                        _tid = _m.fallback_table_id;
                        _tbl = scr_get_encounter_table(_tid);
                    }
                    if (!is_undefined(_tbl)) {
                        _z.table_id = _tid;
                        _z.enemy_table = _tbl;
                    }
                }
                break;
            case "sign": case "lore": case "npc": case "treasure": case "item": case "location":
                // Location labels (town_square, north_gate, …) are not solids unless they
                // have inspect text or a script (e.g. the closed tavern hatch).
                if (_m.type == "location") {
                    var _has_text = (variable_struct_exists(_m, "lines") && is_array(_m.lines) && array_length(_m.lines) > 0)
                        || (variable_struct_exists(_m, "text") && is_string(_m.text) && _m.text != "")
                        || (variable_struct_exists(_m, "script_id") && _m.script_id != "");
                    if (!_has_text) {
                        if (variable_struct_exists(_m, "name") && _m.name == "tavern_cellar_hatch") {
                            // Fall through and spawn a closed-hatch inspectable.
                        } else {
                            break;
                        }
                    }
                }
                if (_o_int != -1) {
                    if ((_m.type == "item" || _m.type == "treasure") && variable_struct_exists(_m, "story_flag") && _m.story_flag != "" && scr_flag_get(_m.story_flag)) {
                        break;
                    }
                    if ((_m.type == "item" || _m.type == "treasure") && variable_struct_exists(_m, "item_id") && _m.item_id != "" && scr_inventory_has(_m.item_id)) {
                        break;
                    }
                    if ((_m.type == "item" || _m.type == "treasure") && scr_flag_get("looted_" + _m.name)) {
                        break;
                    }
                    var _s = scr_map_create_at_feet(_o_int, _lay, _m.x, _m.y);
                    scr_map_fit_to_tile(_s, _m.x, _m.y);
                    var _lines;
                    if (variable_struct_exists(_m, "lines") && is_array(_m.lines) && array_length(_m.lines) > 0) {
                        _lines = _m.lines;
                    } else if (variable_struct_exists(_m, "text") && is_string(_m.text) && _m.text != "") {
                        _lines = [_m.text];
                    } else if (variable_struct_exists(_m, "loot")) {
                        _lines = ["[Placeholder chest: " + _m.name + ".]"];
                    } else if (variable_struct_exists(_m, "name") && _m.name == "tavern_cellar_hatch") {
                        _lines = ["[The cellar hatch is closed.]"];
                    } else if (variable_struct_exists(_m, "note") && is_string(_m.note) && _m.note != "") {
                        _lines = ["[Placeholder: " + _m.note + "]"];
                    } else {
                        _lines = ["[Placeholder: " + _m.name + "]"];
                    }
                    _s.dialogue_lines = _lines;
                    if (variable_struct_exists(_m, "struck_lines") && is_array(_m.struck_lines)) {
                        _s.struck_lines = _m.struck_lines;
                    }
                    if (variable_struct_exists(_m, "speaker") && _m.speaker != "") {
                        _s.speaker_name = _m.speaker;
                    } else {
                        _s.speaker_name = (_m.type == "npc") ? _m.name : "";
                    }
                    if (variable_struct_exists(_m, "script_id")) _s.script_id = _m.script_id;
                    if (variable_struct_exists(_m, "script_chain")) _s.script_chain = _m.script_chain;
                    if (variable_struct_exists(_m, "repeat_script_id")) _s.repeat_script_id = _m.repeat_script_id;
                    if (variable_struct_exists(_m, "story_flag")) _s.story_flag = _m.story_flag;
                    if (variable_struct_exists(_m, "item_id")) _s.item_id = _m.item_id;
                    if (variable_struct_exists(_m, "loot")) _s.loot = _m.loot;
                    if (variable_struct_exists(_m, "npc_id")) _s.npc_id = _m.npc_id;
                    if (variable_struct_exists(_m, "shop_id")) _s.shop_id = _m.shop_id;
                    if (_m.type == "item" && variable_struct_exists(_m, "item_id")) {
                        var _ispr = scr_ch1_item_sprite(_m.item_id);
                        if (!scr_sprite_is_valid(_ispr)) _ispr = asset_get_index("spr_" + _m.item_id);
                        if (_ispr != -1 && sprite_exists(_ispr)) {
                            _s.sprite_index = _ispr;
                            _s.image_xscale = 1;
                            _s.image_yscale = 1;
                            scr_map_fit_to_tile(_s, _m.x, _m.y);
                        }
                    }
                    if (_m.type == "treasure") {
                        scr_ch1_bind_chest(_s, _m, false);
                    }
                    if (_m.type == "npc") {
                        var _nid = variable_struct_exists(_m, "npc_id") ? _m.npc_id : "";
                        var _nm = variable_struct_exists(_m, "name") ? _m.name : "";
                        scr_ch1_bind_npc_ow(_s, _nid, _nm, _m);
                    }
                    _s.map_marker = _m;
                }
                break;
            case "story_npc":
                if (_o_snpc != -1) {
                    if (variable_struct_exists(_m, "story_flag") && _m.story_flag != "" && scr_flag_get(_m.story_flag)) {
                        break;
                    }
                    var _sn = scr_map_create_at_feet(_o_snpc, _lay, _m.x, _m.y);
                    if (variable_struct_exists(_m, "script_id")) _sn.script_id = _m.script_id;
                    if (variable_struct_exists(_m, "story_flag")) _sn.story_flag = _m.story_flag;
                    if (variable_struct_exists(_m, "npc_id")) _sn.npc_id = _m.npc_id;
                    _sn.map_marker = _m;
                    var _sid = variable_struct_exists(_m, "npc_id") ? _m.npc_id : "fallen_knight_story";
                    var _snm = variable_struct_exists(_m, "name") ? _m.name : "";
                    scr_ch1_bind_npc_ow(_sn, _sid, _snm, _m);
                    if (_sn.image_xscale != 1 || !scr_sprite_is_valid(_sn.sprite_index)) {
                        scr_map_fit_to_tile(_sn, _m.x, _m.y);
                    }
                    if (scr_flag_get(_sn.story_flag)) instance_destroy(_sn);
                }
                break;
            case "save_point":
                if (_o_save != -1) {
                    // 16x24, origin (8,23): instance x/y is the tile's feet, same as the player.
                    var _sv = instance_create_layer(_m.x, _m.y, _lay, _o_save);
                    _sv.x = _m.x;
                    _sv.y = _m.y;
                    _sv.depth = -_m.y;
                    _sv.map_marker = _m;
                    var _sspr = scr_menu_sprite_save_point_idle();
                    if (scr_sprite_is_valid(_sspr)) {
                        _sv.sprite_index = _sspr;
                        _sv.image_xscale = 1;
                        _sv.image_yscale = 1;
                        _sv.x = _m.x;
                        _sv.y = _m.y;
                    } else {
                        scr_map_fit_to_tile(_sv, _m.x, _m.y);
                    }
                }
                break;
            case "barrier":
                if (!scr_map_requirement_met(_m) && _o_solid != -1) {
                    var _bw = variable_struct_exists(_m, "w") ? _m.w : 1;
                    var _bh = variable_struct_exists(_m, "h") ? _m.h : 1;
                    var _sol = instance_create_layer(_m.tile_x * 16, _m.tile_y * 16, _lay, _o_solid);
                    var _ss = _sol.sprite_index;
                    if (_ss != -1 && sprite_exists(_ss) && sprite_get_width(_ss) > 0 && sprite_get_height(_ss) > 0) {
                        _sol.image_xscale = (_bw * 16) / sprite_get_width(_ss);
                        _sol.image_yscale = (_bh * 16) / sprite_get_height(_ss);
                    }
                    _sol.map_marker = _m;
                    if (_o_int != -1 && variable_struct_exists(_m, "lines") && is_array(_m.lines) && array_length(_m.lines) > 0) {
                        var _li = scr_map_create_at_feet(_o_int, _lay, _m.x, _m.y);
                        scr_map_fit_to_tile(_li, _m.x, _m.y);
                        _li.dialogue_lines = _m.lines;
                        _li.struck_lines = [];
                        _li.speaker_name = "";
                        if (variable_struct_exists(_m, "script_id")) _li.script_id = _m.script_id;
                        _li.map_marker = _m;
                    }
                }
                break;
            case "trap":
                if (_o_trap != -1) {
                    var _one = instance_create_layer(_m.tile_x * 16, _m.tile_y * 16, _lay, _o_trap);
                    var _ospr = _one.sprite_index;
                    if (_ospr != -1 && sprite_exists(_ospr) && sprite_get_width(_ospr) > 0) {
                        _one.image_xscale = 16 / sprite_get_width(_ospr);
                        _one.image_yscale = 16 / sprite_get_height(_ospr);
                    }
                    _one.map_marker = _m;
                    if (variable_struct_exists(_m, "script_id")) _one.script_id = _m.script_id;
                    if (variable_struct_exists(_m, "lines")) _one.dialogue_lines = _m.lines;
                    if (variable_struct_exists(_m, "damage_pct")) _one.damage_pct = _m.damage_pct;
                }
                break;
            case "trap_field":
                if (_o_trap != -1 && variable_struct_exists(_m, "plate_tiles")) {
                    for (var _k = 0; _k < array_length(_m.plate_tiles); _k++) {
                        var _px = _m.plate_tiles[_k][0];
                        var _py = _m.plate_tiles[_k][1];
                        var _pt = instance_create_layer(_px * 16, _py * 16, _lay, _o_trap);
                        var _pspr = _pt.sprite_index;
                        if (_pspr != -1 && sprite_exists(_pspr) && sprite_get_width(_pspr) > 0) {
                            _pt.image_xscale = 16 / sprite_get_width(_pspr);
                            _pt.image_yscale = 16 / sprite_get_height(_pspr);
                        }
                        _pt.map_marker = _m;
                        if (variable_struct_exists(_m, "script_id")) _pt.script_id = _m.script_id;
                        if (variable_struct_exists(_m, "lines")) _pt.dialogue_lines = _m.lines;
                        if (variable_struct_exists(_m, "damage_pct")) _pt.damage_pct = _m.damage_pct;
                    }
                }
                break;
            case "story":
                // Walk-on triggers (BG_INTRO) use obj_story_trigger. Interact-only
                // doors (CV_END) are obj_interactable so they can honour `requires`.
                if (variable_struct_exists(_m, "trigger") && _m.trigger == "on_enter_once" && _o_sttrig != -1) {
                    var _sx = _m.tile_x * 16;
                    var _sy = _m.tile_y * 16;
                    var _sw = 16;
                    var _sh = 16;
                    if (variable_struct_exists(_m, "rect_px")) {
                        var _rp = _m.rect_px;
                        _sx = _rp[0];
                        _sy = _rp[1];
                        _sw = _rp[2] - _rp[0];
                        _sh = _rp[3] - _rp[1];
                    }
                    var _trig = instance_create_layer(_sx, _sy, _lay, _o_sttrig);
                    var _tspr = _trig.sprite_index;
                    if (_tspr != -1 && sprite_exists(_tspr) && sprite_get_width(_tspr) > 0 && sprite_get_height(_tspr) > 0) {
                        _trig.image_xscale = _sw / sprite_get_width(_tspr);
                        _trig.image_yscale = _sh / sprite_get_height(_tspr);
                    }
                    if (variable_struct_exists(_m, "script_id")) _trig.script_id = _m.script_id;
                    if (variable_struct_exists(_m, "script_chain")) _trig.script_chain = _m.script_chain;
                    if (variable_struct_exists(_m, "story_flag")) _trig.story_flag = _m.story_flag;
                    _trig.map_marker = _m;
                    if (_trig.story_flag != "" && scr_flag_get(_trig.story_flag)) instance_destroy(_trig);
                } else if (_o_int != -1) {
                    var _door = scr_map_create_at_feet(_o_int, _lay, _m.x, _m.y);
                    scr_map_fit_to_tile(_door, _m.x, _m.y);
                    if (variable_struct_exists(_m, "script_id")) _door.script_id = _m.script_id;
                    if (variable_struct_exists(_m, "script_chain")) _door.script_chain = _m.script_chain;
                    if (variable_struct_exists(_m, "story_flag")) _door.story_flag = _m.story_flag;
                    _door.dialogue_lines = ["[The door is sealed.]"];
                    _door.map_marker = _m;
                }
                break;
            case "entrance": case "zone_exit":
                if (_o_door != -1) {
                    var _w = variable_struct_exists(_m, "w") ? _m.w : 1;
                    var _h = variable_struct_exists(_m, "h") ? _m.h : 1;
                    var _d = instance_create_layer(_m.tile_x * 16, _m.tile_y * 16, _lay, _o_door);
                    var _dspr = _d.sprite_index;
                    if (_dspr != -1 && sprite_exists(_dspr) && sprite_get_width(_dspr) > 0 && sprite_get_height(_dspr) > 0) {
                        _d.image_xscale = (_w * 16) / sprite_get_width(_dspr);
                        _d.image_yscale = (_h * 16) / sprite_get_height(_dspr);
                    } else {
                        _d.image_xscale = _w;
                    }
                    _d.target_room = asset_get_index(_m.target_room);
                    _d.target_room_name = _m.target_room;
                    _d.target_spawn = variable_struct_exists(_m, "target_spawn") ? _m.target_spawn : "";
                    _d.sets_flag = variable_struct_exists(_m, "sets_flag") ? _m.sets_flag : "";
                    _d.map_marker = _m;
                }
                break;
        }
    }
    // Defeat wake-up: prefer town_square (inside Greyhaven) over player_start, which
    // now sits on the south road outside the palisade.
    var _respawn_at = (_town_square != undefined) ? _town_square : ((_spawn != undefined && _spawn.name == "player_start") ? _spawn : undefined);
    if (_o_resp != -1 && _respawn_at != undefined) {
        var _rp = instance_create_layer(_respawn_at.x, _respawn_at.y, _lay, _o_resp);
        _rp.facing_x = 0;
        _rp.facing_y = 1;
        if (variable_struct_exists(_respawn_at, "facing")) {
            if (_respawn_at.facing == "up") { _rp.facing_x = 0; _rp.facing_y = -1; }
            else if (_respawn_at.facing == "left") { _rp.facing_x = -1; _rp.facing_y = 0; }
            else if (_respawn_at.facing == "right") { _rp.facing_x = 1; _rp.facing_y = 0; }
        }
    }
    if (_spawn != undefined && instance_exists(obj_player)) {
        with (obj_player) {
            x = _spawn.x;
            y = _spawn.y;
            if (variable_struct_exists(_spawn, "facing")) {
                if (_spawn.facing == "up") { facing_x = 0; facing_y = -1; }
                else if (_spawn.facing == "left") { facing_x = -1; facing_y = 0; }
                else if (_spawn.facing == "right") { facing_x = 1; facing_y = 0; }
                else { facing_x = 0; facing_y = 1; }
            }
        }
        scr_player_unstick();
        // Opening beat: GH_ARRIVAL on player_start. Skipped when the flag is set
        // (including returns from battle).
        if (variable_struct_exists(_spawn, "script_id") && _spawn.script_id != "") {
            var _sf = variable_struct_exists(_spawn, "story_flag") ? _spawn.story_flag : "";
            if (_sf == "" || !scr_flag_get(_sf)) {
                scr_dialogue_play_script(_spawn.script_id, noone);
            }
        }
    }
}

/// Enable Viewport 0 if the room has no camera yet. Preferred size is 320×180
/// (display at 2× to 640×360) so a 6400×4800 overworld is playable.
function scr_map_enable_camera(_view_w, _view_h) {
    view_enabled = true;
    view_visible[0] = true;
    var _cam = view_camera[0];
    if (_cam == -1) {
        _cam = camera_create_view(0, 0, _view_w, _view_h);
        view_camera[0] = _cam;
    } else if (camera_get_view_width(_cam) <= 0 || camera_get_view_height(_cam) <= 0) {
        camera_set_view_size(_cam, _view_w, _view_h);
    }
}

/// Follow the player with viewport 0 if a camera is enabled; otherwise do nothing.
/// Clamps to the room so the camera never shows past the edge. Skips the battle room.
/// Shared with the sprites branch: keep this as the only definition. End Step on
/// obj_game_controller calls it. Overhead layer depth (-10000) stays above depth = -y.
function scr_camera_follow_player() {
    if (!CAMERA_FOLLOW_PLAYER) return;
    if (room == BATTLE_ROOM) return;
    if (!view_enabled) return;
    if (!view_visible[0]) return;
    if (!instance_exists(obj_player)) return;
    var _cam = view_camera[0];
    if (_cam == -1) return;
    var _vw = camera_get_view_width(_cam);
    var _vh = camera_get_view_height(_cam);
    if (_vw <= 0 || _vh <= 0) return;
    var _cx = obj_player.x - _vw * 0.5;
    var _cy = obj_player.y - _vh * 0.5;
    var _max_x = max(0, room_width - _vw);
    var _max_y = max(0, room_height - _vh);
    if (_cx < 0) _cx = 0;
    if (_cy < 0) _cy = 0;
    if (_cx > _max_x) _cx = _max_x;
    if (_cy > _max_y) _cy = _max_y;
    camera_set_view_pos(_cam, _cx, _cy);
}

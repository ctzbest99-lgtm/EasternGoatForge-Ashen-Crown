/// scr_build_overworld(): fills rm_overworld (400x300 tiles = 6400x4800 px) from Included Files.
/// Data lives in datafiles/overworld/ (copy the provided datafiles folder into the project's Included Files):
///   overworld/ow_<layer>.bin              400*300 little-endian u16 tile indices, row-major (fast path)
///   overworld/chunks/ow_<layer>_<cx>_<cy>.csv   16 chunks of 100x75 per layer (fallback / easy to diff)
/// <layer> = ground, decor, overhead, collision, markers. Call from rm_overworld's Creation Code.
#macro OW_W 400
#macro OW_H 300
#macro OW_CHUNK_W 100
#macro OW_CHUNK_H 75

function scr_build_overworld() {
    var _t0 = get_timer();
    var _defs = scr_map_layer_defs();
    for (var _i = 0; _i < array_length(_defs); _i++) {
        var _def = _defs[_i];
        var _tm = scr_map_get_tilemap(_def.name, _def.depth, OW_W, OW_H);
        tilemap_clear(_tm, 0);
        var _ok = scr_map_load_bin(_tm, "overworld/ow_" + _def.key + ".bin", OW_W, OW_H);
        if (!_ok) {
            for (var _cy = 0; _cy < OW_H div OW_CHUNK_H; _cy++) {
                for (var _cx = 0; _cx < OW_W div OW_CHUNK_W; _cx++) {
                    var _f = "overworld/chunks/ow_" + _def.key + "_" + string(_cx) + "_" + string(_cy) + ".csv";
                    if (!scr_map_load_csv(_tm, _f, _cx * OW_CHUNK_W, _cy * OW_CHUNK_H)) {
                        show_debug_message("scr_build_overworld: missing " + _f);
                    }
                }
            }
        }
        layer_set_visible(layer_get_id(_def.name), _def.visible);
    }
    scr_map_hook_player_collision();
    scr_map_spawn_markers(scr_overworld_markers());
    scr_map_enable_camera(320, 180);
    scr_camera_follow_player();
    show_debug_message("scr_build_overworld: " + string((get_timer() - _t0) / 1000) + " ms");
}

/// Optional: load only one 100x75 chunk (e.g. to stream the map around the camera).
function scr_overworld_load_chunk(_cx, _cy) {
    var _defs = scr_map_layer_defs();
    for (var _i = 0; _i < array_length(_defs); _i++) {
        var _def = _defs[_i];
        var _tm = scr_map_get_tilemap(_def.name, _def.depth, OW_W, OW_H);
        scr_map_load_csv(_tm, "overworld/chunks/ow_" + _def.key + "_" + string(_cx) + "_" + string(_cy) + ".csv", _cx * OW_CHUNK_W, _cy * OW_CHUNK_H);
    }
}

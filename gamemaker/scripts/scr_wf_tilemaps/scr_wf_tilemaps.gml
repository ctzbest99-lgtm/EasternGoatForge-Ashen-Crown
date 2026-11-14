/// scr_wf_tilemaps: helpers for the Chapter 2 rooms. Needs Zone 1's scr_map_tilemaps.gml.
/// Tileset asset: ts_wrenfield (from ts_wrenfield.png, 16x16, no offset/spacing). Its rows 0-49 are ts_zone1, unchanged,
/// so every Zone 1 tile index means the same tile in both sets.

/// Create the five map layers (or reuse the Room Editor ones) and point them at ts_wrenfield before any tile is set.
function scr_wf_prepare_layers(_w, _h) {
    var _defs = scr_map_layer_defs();
    for (var _i = 0; _i < array_length(_defs); _i++) {
        var _tm = scr_map_get_tilemap(_defs[_i].name, _defs[_i].depth, _w, _h);
        tilemap_tileset(_tm, ts_wrenfield);
    }
}

/// _patch = array of [layer key, x, y, tile] (layer key as in scr_map_layer_defs: ground/decor/overhead/collision/markers).
function scr_wf_apply_patch(_patch) {
    var _defs = scr_map_layer_defs();
    for (var _i = 0; _i < array_length(_patch); _i++) {
        var _p = _patch[_i];
        for (var _k = 0; _k < array_length(_defs); _k++) {
            if (_defs[_k].key == _p[0]) {
                var _tm = layer_tilemap_get_id(layer_get_id(_defs[_k].name));
                if (_tm != -1) tilemap_set(_tm, _p[3], _p[1], _p[2]);
                break;
            }
        }
    }
}

/// Drops markers that belong to the other state: show_if_flag = only once the flag is set, hide_if_flag = only while it is unset.
function scr_wf_filter_markers(_markers) {
    var _out = [];
    for (var _i = 0; _i < array_length(_markers); _i++) {
        var _m = _markers[_i];
        if (variable_struct_exists(_m, "show_if_flag") && !scr_map_flag_get(_m.show_if_flag)) continue;
        if (variable_struct_exists(_m, "hide_if_flag") && scr_map_flag_get(_m.hide_if_flag)) continue;
        array_push(_out, _m);
    }
    return scr_ch2_marker_fixups(_out); // repo addition: Chapter 2 placement / rule fix-ups (scr_ch2_story)
}

/// When flag_execution_stopped is set while the player is still in rm_wrenfield (after WF_CALDER_DEFEAT),
/// call room_restart() (or scr_build_wrenfield() after destroying the marker instances) so the square switches state.
/// During WF_GALLOWS_07 you can swap just the right-hand gallows without a rebuild:
function scr_wf_cut_rope() {
    // Repo change: only the right-hand gallows (columns 20-39). The inn (x 3-7) and store (x 45-48)
    // stay shut until flag_execution_stopped rebuilds the room in the after state.
    var _all = scr_wrenfield_after_patch();
    var _rope = [];
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i][1] >= 20 && _all[_i][1] < 40) array_push(_rope, _all[_i]);
    }
    scr_wf_apply_patch(_rope);
}

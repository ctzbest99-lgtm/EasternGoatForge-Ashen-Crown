/// scr_sprites — look up imported sprites safely and drive overworld / battle animation.
/// All lookups go through asset_get_index so the project compiles before the PNGs are imported.
/// If a sprite is missing, callers fall back to the object's IDE sprite (overworld) or a
/// placeholder rectangle (battle). Asset names must match game/sprites/IMPORT.md.

/// First existing sprite among the given names, or -1 if none are in the project.
function scr_sprite_index() {
    var _i;
    for (_i = 0; _i < argument_count; _i++) {
        var _name = argument[_i];
        if (!is_string(_name) || _name == "") continue;
        var _id = asset_get_index(_name);
        if (_id != -1 && sprite_exists(_id)) return _id;
    }
    return -1;
}

function scr_sprite_is_valid(_spr) {
    return is_real(_spr) && _spr != -1 && sprite_exists(_spr);
}

/// Cardinal facing for 4-direction sheets. Diagonals prefer the vertical axis.
function scr_facing_dir_name(_fx, _fy) {
    if (abs(_fx) > abs(_fy)) return (_fx < 0) ? "left" : "right";
    if (_fy < 0) return "up";
    return "down";
}

function scr_player_sprites_init() {
    var _idle = scr_sprite_index("spr_kael_ow16_idle_down", "spr_kael_ow_idle_down");
    if (scr_sprite_is_valid(_idle)) {
        sprite_index = _idle;
        mask_index = _idle; // fixed feet box; do not let walk frames change the hitbox
    }
    image_xscale = 1;
    image_yscale = 1;
    image_speed = 0;
    image_index = 0;
}

/// Swap idle/walk by facing and whether the player actually moved this frame.
/// Left is a pre-mirrored sheet, so image_xscale stays 1.
function scr_player_update_sprite(_moving) {
    var _dir = scr_facing_dir_name(facing_x, facing_y);
    var _spr;
    if (_moving) {
        _spr = scr_sprite_index(
            "spr_kael_ow16_walk_" + _dir + "_strip4",
            "spr_kael_ow_walk_" + _dir + "_strip4"
        );
    } else {
        _spr = scr_sprite_index(
            "spr_kael_ow16_idle_" + _dir,
            "spr_kael_ow_idle_" + _dir
        );
    }
    if (!scr_sprite_is_valid(_spr)) return;

    var _was_walk = (image_speed > 0);
    if (sprite_index != _spr) {
        sprite_index = _spr;
        if (!_moving || !_was_walk) image_index = 0;
    }
    image_xscale = 1;
    image_yscale = 1;
    if (_moving) {
        var _fps = game_get_speed(gamespeed_fps);
        image_speed = (_fps > 0) ? (PLAYER_WALK_FPS / _fps) : 0;
    } else {
        image_speed = 0;
        image_index = 0;
    }
}

// ---------------------------------------------------------------------------
// Battle visuals
// ---------------------------------------------------------------------------

/// Map a party / enemy actor_id onto a battle sprite stem, or "" if unknown.
function scr_battle_kind_from_id(_actor_id) {
    switch (_actor_id) {
        case "kael":
        case "hero":
            return "hero";
        case "bandit":
            return "bandit";
        case "fallen_knight":
            return "fallen_knight";
        case "ash_wolf":
            return "ash_wolf";
        case "ashen_wretch":
            return "ashen_wretch";
        case "ashbound_hunter":
            return "ashbound_hunter";
        case "grave_spider":
            return "grave_spider";
        case "hollow_soldier":
            return "hollow_soldier";
        case "blackguard":
            return "blackguard";
        // Act II (Design batch 6)
        case "crown_patrolman":
        case "crown_crossbowman":
        case "occupation_soldier":
        case "bandit_veteran":
        case "grey_ash_wolf":
        case "reeve_calder":
            return _actor_id;
        default:
            // Batches 7–8 and later: strips are found by name (scr_battle_auto_strip).
            if (scr_battle_kind_is_generic(_actor_id)) return _actor_id;
            return "";
    }
}

/// Battle kinds whose strips are resolved generically by name (Design batches 7 and 8, and Taren).
function scr_battle_kind_is_generic(_kind) {
    switch (_kind) {
        case "crown_sergeant": case "dock_thug": case "cutpurse": case "debt_collector": case "debtman":
        case "ward_sentinel": case "glyph_wisp": case "aethari_automaton": case "sanctuary_warden":
        case "garrison_pikeman": case "garrison_field_surgeon": case "garrison_knight": case "commander_hailen":
        case "shade_stalker": case "briar_hulk": case "lost_one": case "night_moth_swarm": case "door_warden":
        case "blackwood_matriarch":
        // Party: Taren Holt (idle4 walk8 attack6 hurt3 defend3 death6, skill_rally6, skill_cleave6).
        case "taren":
            return true;
    }
    return false;
}

/// Find `spr_<kind>_<anim>_strip<N>` for any N (or no suffix), trying `<anim>_p2` first in
/// phase 2+. Cached. Returns { spr, n } with spr -1 when nothing is imported (rectangle fallback).
function scr_battle_auto_strip(_kind, _anim, _phase = 1) {
    if (!variable_global_exists("battle_strip_cache") || !is_struct(global.battle_strip_cache)) global.battle_strip_cache = {};
    var _key = _kind + "|" + _anim + "|" + string(min(_phase, 2));
    if (variable_struct_exists(global.battle_strip_cache, _key)) return global.battle_strip_cache[$ _key];
    var _names = (_phase >= 2) ? [_anim + "_p2", _anim] : [_anim];
    var _counts = [8, 6, 4, 3, 7, 5, 2, 9, 10, 12, 1];
    var _out = { spr: -1, n: 1 };
    for (var _a = 0; _a < array_length(_names) && _out.spr == -1; _a++) {
        for (var _c = 0; _c < array_length(_counts); _c++) {
            var _s = scr_sprite_index("spr_" + _kind + "_" + _names[_a] + "_strip" + string(_counts[_c]));
            if (_s != -1) {
                _out = { spr: _s, n: sprite_get_number(_s) };
                break;
            }
        }
        if (_out.spr == -1) {
            var _s1 = scr_sprite_index("spr_" + _kind + "_" + _names[_a]);
            if (_s1 != -1) _out = { spr: _s1, n: sprite_get_number(_s1) };
        }
    }
    global.battle_strip_cache[$ _key] = _out;
    return _out;
}

function scr_battle_frame_count(_kind, _anim, _phase = 1) {
    if (scr_battle_kind_is_generic(_kind)) return max(1, scr_battle_auto_strip(_kind, _anim, _phase).n);
    // Blackguard: phase 1 death is debug-only; a lethal hit always uses the p3 death8 strip.
    if (_kind == "blackguard") {
        if (_anim == "transition_p1to2" || _anim == "transition_p2to3") return 8;
        if (_anim == "death") return 8;
        if (_phase <= 1) {
            if (_anim == "idle" || _anim == "walk") return 8;
            if (_anim == "attack") return 6;
            if (_anim == "shieldbash") return 8;
            if (_anim == "hurt") return 6;
        } else if (_phase == 2) {
            if (_anim == "idle" || _anim == "walk") return 8;
            if (_anim == "attack" || _anim == "lunge" || _anim == "oath") return 6;
            if (_anim == "hurt") return 4;
        } else {
            if (_anim == "idle" || _anim == "walk") return 8;
            if (_anim == "attack") return 5;
            if (_anim == "execution") return 8;
            if (_anim == "hurt") return 4;
        }
        return 1;
    }
    if (_kind == "hero") {
        if (_anim == "idle") return 4;
        if (_anim == "walk") return 8;
        if (_anim == "attack") return 6;
        if (_anim == "hurt") return 3;
        if (_anim == "death") return 6;
    } else if (_kind == "bandit") {
        if (_anim == "idle") return 4;
        if (_anim == "walk") return 4;
        if (_anim == "attack") return 6;
        if (_anim == "hurt") return 4;
        if (_anim == "death") return 6;
    } else if (_kind == "fallen_knight") {
        if (_anim == "idle") return 8;
        if (_anim == "walk") return 8;
        if (_anim == "attack") return 6;
        if (_anim == "hurt") return 6;
        if (_anim == "death") return 8;
    } else if (_kind == "ash_wolf") {
        if (_anim == "idle" || _anim == "walk" || _anim == "howl") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt") return 3;
    } else if (_kind == "ashen_wretch") {
        if (_anim == "idle" || _anim == "scream") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt") return 3;
    } else if (_kind == "ashbound_hunter") {
        if (_anim == "idle") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt") return 3;
        if (_anim == "arrow") return 3;
    } else if (_kind == "grave_spider") {
        if (_anim == "idle" || _anim == "walk" || _anim == "cast") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt") return 3;
    } else if (_kind == "hollow_soldier") {
        if (_anim == "idle" || _anim == "walk") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "guard" || _anim == "hurt") return 3;
    } else if (_kind == "crown_patrolman") {
        if (_anim == "idle" || _anim == "walk") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "brace" || _anim == "hurt") return 3;
    } else if (_kind == "crown_crossbowman") {
        if (_anim == "idle" || _anim == "walk") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt" || _anim == "bolt") return 3;
    } else if (_kind == "occupation_soldier") {
        if (_anim == "idle" || _anim == "walk") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "guard" || _anim == "hurt") return 3;
    } else if (_kind == "bandit_veteran") {
        if (_anim == "idle" || _anim == "walk" || _anim == "hurt") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
    } else if (_kind == "grey_ash_wolf") {
        if (_anim == "idle" || _anim == "walk" || _anim == "howl") return 4;
        if (_anim == "attack" || _anim == "death") return 6;
        if (_anim == "hurt") return 3;
    } else if (_kind == "reeve_calder") {
        // idle8 walk8 attack6 guard4 shout6 stance6 hurt4 yield8. No death strip: he yields.
        if (_anim == "idle" || _anim == "walk" || _anim == "yield") return 8;
        if (_anim == "attack" || _anim == "shout" || _anim == "stance") return 6;
        if (_anim == "guard" || _anim == "hurt") return 4;
    }
    return 1;
}

function scr_battle_sprite(_kind, _anim, _phase = 1) {
    if (_kind == "") return -1;
    if (_kind == "blackguard") {
        if (_anim == "transition_p1to2") return scr_sprite_index("spr_blackguard_transition_p1to2_strip8");
        if (_anim == "transition_p2to3") return scr_sprite_index("spr_blackguard_transition_p2to3_strip8");
        // Final death is always the Phase 3 strip. The Phase 1 death strip is debug only.
        if (_anim == "death") return scr_sprite_index("spr_blackguard_p3_death_strip8", "spr_blackguard_death_strip8");
        var _prefix = "spr_blackguard_";
        if (_phase == 2) _prefix = "spr_blackguard_p2_";
        if (_phase >= 3) _prefix = "spr_blackguard_p3_";
        var _n = scr_battle_frame_count(_kind, _anim, _phase);
        return scr_sprite_index(_prefix + _anim + "_strip" + string(_n));
    }
    if (scr_battle_kind_is_generic(_kind)) return scr_battle_auto_strip(_kind, _anim, _phase).spr;
    if (_kind == "reeve_calder" && _anim == "idle" && _phase >= 2) {
        // After his stance: Design's idle_p2 if imported, otherwise the normal idle.
        return scr_sprite_index("spr_reeve_calder_idle_p2_strip8", "spr_reeve_calder_idle_strip8");
    }
    var _n2 = scr_battle_frame_count(_kind, _anim, _phase);
    return scr_sprite_index("spr_" + _kind + "_" + _anim + "_strip" + string(_n2));
}

function scr_battle_vis_create(_actor_id, _xscale, _phase = 1) {
    var _kind = scr_battle_kind_from_id(_actor_id);
    var _vis = {
        actor_id: _actor_id,
        kind: _kind,
        phase: _phase,
        anim: "idle",
        sprite: -1,
        frame: 0,
        frame_count: 1,
        frame_timer: 0,
        fps: BATTLE_IDLE_FPS,
        loop: true,
        finished: true,
        xscale: _xscale
    };
    scr_battle_vis_play(_vis, "idle");
    return _vis;
}

function scr_battle_vis_play(_vis, _anim) {
    if (!is_struct(_vis)) return;
    var _phase = variable_struct_exists(_vis, "phase") ? _vis.phase : 1;
    _vis.anim = _anim;
    _vis.sprite = scr_battle_sprite(_vis.kind, _anim, _phase);
    _vis.frame_count = max(1, scr_battle_frame_count(_vis.kind, _anim, _phase));
    _vis.frame = 0;
    _vis.frame_timer = 0;
    _vis.loop = (_anim == "idle" || _anim == "walk");
    _vis.fps = _vis.loop ? BATTLE_IDLE_FPS : BATTLE_ANIM_FPS;
    // Missing sprite: treat the clip as already finished so the state machine is not blocked.
    _vis.finished = !scr_sprite_is_valid(_vis.sprite);
}

function scr_battle_vis_update(_vis) {
    if (!is_struct(_vis)) return;
    if (!scr_sprite_is_valid(_vis.sprite)) {
        _vis.finished = true;
        return;
    }
    if (_vis.finished && !_vis.loop) return;
    var _game_fps = game_get_speed(gamespeed_fps);
    if (_game_fps <= 0 || _vis.fps <= 0) return;
    _vis.frame_timer += _vis.fps / _game_fps;
    while (_vis.frame_timer >= 1) {
        _vis.frame_timer -= 1;
        if (_vis.frame + 1 >= _vis.frame_count) {
            if (_vis.loop) {
                _vis.frame = 0;
            } else {
                _vis.frame = _vis.frame_count - 1;
                _vis.finished = true;
            }
        } else {
            _vis.frame += 1;
        }
    }
}

function scr_battle_vis_snap_end(_vis) {
    if (!is_struct(_vis)) return;
    if (scr_sprite_is_valid(_vis.sprite) && _vis.frame_count > 0) {
        _vis.frame = _vis.loop ? _vis.frame : (_vis.frame_count - 1);
    }
    _vis.frame_timer = 0;
    _vis.finished = true;
}

/// Hit connects partway through the attack clip (about 60% in, at least frame 1).
function scr_battle_vis_hit_ready(_vis) {
    if (!is_struct(_vis)) return true;
    if (!scr_sprite_is_valid(_vis.sprite)) return true;
    if (_vis.finished) return true;
    var _hit_at = max(1, floor(_vis.frame_count * 0.6));
    return _vis.frame >= _hit_at;
}

/// Draw a battle sprite with its own origin at the feet. Returns true if a sprite was drawn.
/// Fallen Knight attack is 64×48 with origin (32, 47); draw_sprite_ext honours that, so the
/// feet stay planted while the 32 px of reach extends forward.
function scr_battle_draw_vis(_vis, _feet_x, _feet_y, _alpha = 1) {
    if (!is_struct(_vis) || !scr_sprite_is_valid(_vis.sprite)) return false;
    if (_alpha <= 0) return true; // faded out (defeated regular): nothing to draw, but the sprite exists
    // GUI is locked to 320×180 (see scr_ui_init). If a project still uses a larger GUI,
    // scale up from the 320 design. BATTLE_SPRITE_SCALE (legacy 2× at 640) is not multiplied on top.
    var _s = scr_ui_scale();
    var _xs = _s * _vis.xscale;
    var _ys = _s;
    draw_sprite_ext(_vis.sprite, _vis.frame, _feet_x, _feet_y, _xs, _ys, 0, c_white, clamp(_alpha, 0, 1));
    return true;
}

// Camera follow lives in scr_map_tilemaps.gml (scr_camera_follow_player),
// called from obj_game_controller End Step. Do not add a second definition here.

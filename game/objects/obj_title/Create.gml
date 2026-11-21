/// obj_title : Create
/// Title screen + main menu. 320 assets if the GUI is under 480 px wide, otherwise 640
/// (layout numbers doubled). Parallax is drawn in code so it does not depend on room layers.
scr_game_state_init();
scr_ui_init();

hires = (display_get_gui_width() >= 480);
res = hires ? "640" : "320";
layout_scale = hires ? 2 : 1;

// Prefer native 640 assets when the GUI is large; fall back to 320 scaled 2× if a 640 sprite is missing.
t_bg0 = scr_sprite_index("spr_menu_bg0_sky_" + res, "spr_menu_bg0_sky_320");
t_bg1 = scr_sprite_index("spr_menu_bg1_hills_" + res, "spr_menu_bg1_hills_320");
t_bg2 = scr_sprite_index("spr_menu_bg2_ruins_" + res, "spr_menu_bg2_ruins_320");
t_bg3 = scr_sprite_index("spr_menu_bg3_foreground_" + res, "spr_menu_bg3_foreground_320");
t_embers = scr_sprite_index("spr_menu_embers_" + res + "_strip24", "spr_menu_embers_320_strip24");
t_logo = scr_sprite_index("spr_logo_ashen_crown_" + res, "spr_logo_ashen_crown_320");
t_cursor = scr_sprite_index("spr_menu_cursor_" + res + "_strip4", "spr_menu_cursor_320_strip4");

// Parallax scroll (pixels per frame at 60 fps): sky 0, hills -0.05, ruins -0.1, foreground -0.2.
scroll0 = 0;
scroll1 = 0;
scroll2 = 0;
scroll3 = 0;
ember_f = 0;
logo_alpha = 0;
logo_y = 22 * layout_scale;
logo_y_target = 6 * layout_scale;
options_alpha = 0;

// The menu is the first thing the player sees; there is no "press any key" gate.
mode = "menu";          // "menu" | "settings" | "saves" | "confirm_new"
options = ["new_game", "continue", "load", "settings", "quit"];
menu_labels = ["New Game", "Continue", "Load Game", "Settings", "Exit Game"];
index = 0;
cursor_y = 76 * layout_scale;
menu_message = "";
has_save = false;       // true only when at least one slot is valid, not merely a file
latest_slot = 0;        // 1..SAVE_SLOT_COUNT, 0 when none is valid
slots = [];
save_index = 0;
save_message = "";
confirm_index = 0;      // 0 = No, 1 = Yes; default is the safe choice
new_game_starting = false;
mouse_last_x = -1;
mouse_last_y = -1;
blink = 0;

// Settings panel geometry, in 320x180 GUI units (multiplied by layout_scale when drawn).
settings_x = 52;
settings_y = 20;
settings_w = 216;
settings_h = 152;
settings_row0 = 52;
settings_row_dy = 18;

// Options screen: music / ambience / sfx gains, mute, back. Gains live in
// global.audio_ctx (scr_audio_set_gain) and persist to AUDIO_SETTINGS_FILE.
scr_audio_init();
scr_audio_settings_load();
opt_rows = scr_options_rows();
opt_index = 0;

/// Re-read the three slots. A corrupt file does not count as "Continue available".
refresh_saves = function() {
    has_save = scr_save_any_valid();
    latest_slot = scr_save_latest_slot();
};

/// Build the Load Game panel. Empty slots are kept in the list so the player can see
/// them and can select one to get a clear "empty" message instead of a silent no-op.
open_saves = function() {
    slots = [];
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) array_push(slots, scr_save_slot_info(_i));
    save_index = 0;
    for (var _j = 0; _j < array_length(slots); _j++) {
        if (slots[_j].ok) { save_index = _j; break; }
    }
    save_message = has_save ? "" : "No save files yet.";
    mode = "saves";
};

/// Start one fresh run. The guard makes a double click / double confirm harmless, and
/// scr_new_game_start() owns the reset so no second initialization path can creep in.
start_new_game = function() {
    if (new_game_starting) return;
    new_game_starting = true;
    scr_new_game_start();
    var _rm = asset_get_index("rm_overworld");
    if (_rm == -1) {
        new_game_starting = false;
        mode = "menu";
        menu_message = "rm_overworld is not in the project.";
        return;
    }
    global.map_spawn_name = "";
    room_goto(_rm);
};

/// Load a slot chosen from the Load Game panel. Every failure leaves the menu usable.
load_save_slot = function(_i) {
    if (_i < 0 || _i >= array_length(slots)) return;
    var _info = slots[_i];
    if (!_info.exists) {
        save_message = "No save in this slot.";
        return;
    }
    if (!_info.ok) {
        save_message = "This save is damaged and can't be loaded.";
        return;
    }
    if (!scr_save_load(_info.slot)) {
        save_message = "Couldn't load this save.";
    }
};

/// One action path for keyboard and mouse, so the two cannot drift apart.
do_menu_action = function(_pick) {
    menu_message = "";
    if (_pick == "new_game") {
        refresh_saves(); // the confirmation wording depends on whether any save exists
        mode = "confirm_new";
        confirm_index = 0;
    } else if (_pick == "continue") {
        refresh_saves();
        if (!has_save || latest_slot < 1) {
            menu_message = "No valid save file yet.";
            return;
        }
        if (!scr_save_load(latest_slot)) {
            refresh_saves();
            menu_message = "Couldn't load the latest save.";
        }
    } else if (_pick == "load") {
        refresh_saves();
        open_saves();
    } else if (_pick == "settings") {
        mode = "settings";
        opt_index = 0;
    } else if (_pick == "quit") {
        game_end();
    }
};

// --- Hit testing (all coordinates are GUI pixels) ---------------------------------
menu_row_at = function(_mx, _my) {
    var _s = layout_scale;
    for (var _i = 0; _i < array_length(options); _i++) {
        var _y = (76 + _i * 20) * _s;
        if (point_in_rectangle(_mx, _my, 48 * _s, _y - 8 * _s, 272 * _s, _y + 14 * _s)) return _i;
    }
    return -1;
};

settings_row_at = function(_mx, _my) {
    var _s = layout_scale;
    for (var _r = 0; _r < array_length(opt_rows); _r++) {
        var _y = (settings_row0 + _r * settings_row_dy) * _s;
        if (point_in_rectangle(_mx, _my, (settings_x + 6) * _s, _y - 4 * _s,
                (settings_x + settings_w - 6) * _s, _y + 12 * _s)) return _r;
    }
    return -1;
};

save_slot_at = function(_mx, _my) {
    for (var _i = 0; _i < MENU_SAVE_SLOT_COUNT; _i++) {
        var _y = MENU_SAVE_SLOT_Y0 + _i * MENU_SAVE_SLOT_DY;
        if (point_in_rectangle(_mx, _my, MENU_SAVE_SLOT_X, _y,
                MENU_SAVE_SLOT_X + MENU_SAVE_SLOT_W, _y + MENU_SAVE_SLOT_H)) return _i;
    }
    return -1;
};

confirm_button_at = function(_mx, _my) {
    if (point_in_rectangle(_mx, _my, 112, 108, 152, 124)) return 0; // No
    if (point_in_rectangle(_mx, _my, 168, 108, 208, 124)) return 1; // Yes
    return -1;
};

refresh_saves();

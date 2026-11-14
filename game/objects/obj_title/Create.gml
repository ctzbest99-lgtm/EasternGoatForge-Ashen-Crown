/// obj_title : Create
/// Title screen + main menu. 320 assets if the GUI is under 480 px wide, otherwise 640
/// (layout numbers doubled). Parallax is drawn in code so it does not depend on room layers.
scr_game_state_init();
scr_ui_init();

hires = (display_get_gui_width() >= 480);
res = hires ? "640" : "320";
layout_scale = hires ? 2 : 1;

// Prefer native 640 assets when the GUI is large; fall back to 320 scaled 2× if a 640 sprite is missing.
spr_bg0 = scr_sprite_index("spr_menu_bg0_sky_" + res, "spr_menu_bg0_sky_320");
spr_bg1 = scr_sprite_index("spr_menu_bg1_hills_" + res, "spr_menu_bg1_hills_320");
spr_bg2 = scr_sprite_index("spr_menu_bg2_ruins_" + res, "spr_menu_bg2_ruins_320");
spr_bg3 = scr_sprite_index("spr_menu_bg3_foreground_" + res, "spr_menu_bg3_foreground_320");
spr_embers = scr_sprite_index("spr_menu_embers_" + res + "_strip24", "spr_menu_embers_320_strip24");
spr_logo = scr_sprite_index("spr_logo_ashen_crown_" + res, "spr_logo_ashen_crown_320");
spr_cursor = scr_sprite_index("spr_menu_cursor_" + res + "_strip4", "spr_menu_cursor_320_strip4");
spr_panel_options = scr_sprite_index("spr_menu_panel_options_" + res, "spr_menu_panel_options_320");
spr_panel_saves = scr_sprite_index("spr_menu_panel_saves_" + res, "spr_menu_panel_saves_320");
spr_title_flat = scr_sprite_index("spr_title_screen_" + res, "spr_title_screen_320");

// Parallax scroll (pixels per frame at 60 fps): sky 0, hills -0.05, ruins -0.1, foreground -0.2.
scroll0 = 0;
scroll1 = 0;
scroll2 = 0;
scroll3 = 0;
ember_f = 0;
logo_alpha = 0;
logo_y = 22 * layout_scale;
logo_y_target = 22 * layout_scale;
options_alpha = 0;

// "press" = wait for a key; "menu" = option list; "options" / "saves" = placeholder panels.
mode = "press";
options = ["new_game", "continue", "options", "quit"];
index = 0;
cursor_y = 95 * layout_scale;
has_save = file_exists("save1.sav");
blink = 0;

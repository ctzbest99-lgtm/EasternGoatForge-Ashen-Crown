/// obj_save_toast : Draw GUI
var _y = MENU_TOAST_Y;
var _a = 1;
if (t < MENU_TOAST_SLIDE) {
    var _u = t / max(1, MENU_TOAST_SLIDE);
    _y = lerp(MENU_TOAST_FROM_Y, MENU_TOAST_Y, _u);
} else if (t > MENU_TOAST_SLIDE + MENU_TOAST_HOLD) {
    var _ft = t - (MENU_TOAST_SLIDE + MENU_TOAST_HOLD);
    _a = 1 - clamp(_ft / max(1, MENU_TOAST_FADE), 0, 1);
}
var _spr = scr_sprite_index("spr_ui_toast_saved");
draw_set_alpha(_a);
if (scr_sprite_is_valid(_spr)) {
    // Origin is (32, 0); draw at (160, y).
    draw_sprite(_spr, 0, MENU_TOAST_X, _y);
} else {
    scr_menu_draw_window(MENU_TOAST_X - 32, _y, 64, 20, "gold");
    scr_menu_text_center(MENU_TOAST_X, _y + 6, "Saved!", MENU_COL_Y);
}
draw_set_alpha(1);

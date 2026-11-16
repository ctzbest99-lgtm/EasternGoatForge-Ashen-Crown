/// obj_room_transition : Draw GUI
/// Full-window fade above the HUD, dialogue and battle panels.
draw_set_alpha(fade_alpha);
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_colour(c_white);

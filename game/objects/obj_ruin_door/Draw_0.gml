/// obj_ruin_door : Draw
/// Placeholder door drawn in code: black frame, dark panel, iron seam, and a ring where a handle would be.
/// No image exists for it yet; docs/ASSET_INVENTORY.md lists the ruin set as planned.
draw_set_colour(c_black);
draw_rectangle(x - 18, y - 40, x + 18, y + 1, false);
draw_set_colour(c_dkgray);
draw_rectangle(x - 15, y - 37, x + 15, y, false);
draw_set_colour(c_gray);
draw_rectangle(x - 12, y - 33, x + 12, y - 5, true);
draw_set_colour(c_black);
draw_rectangle(x - 1, y - 37, x + 1, y, false);
draw_circle(x + 9, y - 18, 2, false);
draw_set_colour(c_white);

/// obj_merchant : Draw
/// Placeholder stall drawn in code: a counter, a hooded figure behind it, and a lantern. No image exists for
/// it yet; docs/ASSET_INVENTORY.md lists NPC art as planned.
draw_set_colour(c_black);
draw_rectangle(x - 16, y - 30, x + 16, y + 1, false);
draw_set_colour(c_dkgray);
draw_rectangle(x - 13, y - 12, x + 13, y - 1, false);
draw_set_colour(c_maroon);
draw_rectangle(x - 7, y - 26, x + 7, y - 13, false);
draw_set_colour(c_white);
draw_rectangle(x - 4, y - 25, x + 4, y - 20, false);
draw_set_colour(c_yellow);
draw_circle(x + 13, y - 22, 2, false);
draw_set_colour(c_white);

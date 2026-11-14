/// obj_night_overlay : Create
/// Heist-night lighting (Chapter 3, the seized warehouse). One instance is created
/// by scr_build_warehouse(). Placeholder until Design lands a lighting pass:
/// a dark overlay over the whole view with lantern pools punched out around the
/// player and fixed lantern points, drawn on a GUI-space surface.
dark_alpha = 0.72;
dark_color = make_color_rgb(8, 10, 24);
light_radius = 104;      // player's lantern pool, world pixels
surface_id = -1;

/// obj_night_overlay : Draw GUI
/// Heist-night lighting: a dark overlay over the whole view with lantern pools
/// punched out around the player and fixed lantern points. Placeholder until
/// Design lands a lighting pass (CHAPTER3_SCRIPT.md 5: heist night).
if (!instance_exists(obj_player)) exit;
var _cam = view_camera[0];
if (!camera_exists(_cam)) exit;
var _cx = camera_get_view_x(_cam);
var _cy = camera_get_view_y(_cam);
var _vw = max(1, camera_get_view_width(_cam));
var _vh = max(1, camera_get_view_height(_cam));
var _gw = max(1, display_get_gui_width());
var _gh = max(1, display_get_gui_height());
var _sx = _gw / _vw;
var _sy = _gh / _vh;

if (!surface_exists(surface_id)) {
    surface_id = surface_create(_gw, _gh);
}
surface_set_target(surface_id);
draw_clear_alpha(c_black, 0);
// the night itself
draw_set_color(dark_color);
draw_set_alpha(dark_alpha);
draw_rectangle(0, 0, _gw, _gh, false);
// punch out the lantern pools (two subtract steps per light: rim, then core)
gpu_set_blendmode(bm_subtract);
draw_set_color(c_white);
var _px = (obj_player.x - _cx) * _sx;
var _py = (obj_player.y - _cy) * _sy;
var _r = light_radius * _sx;
draw_set_alpha(dark_alpha * 0.55);
draw_circle(_px, _py - 10 * _sy, _r, false);
draw_set_alpha(1);
draw_circle(_px, _py - 10 * _sy, _r * 0.72, false);
// fixed lanterns in the warehouse (world coords -> GUI)
var _lanterns = [[10, 4], [8, 6], [18, 6], [12, 14]];
for (var _i = 0; _i < array_length(_lanterns); _i++) {
    var _lx = (_lanterns[_i][0] * 16 + 8 - _cx) * _sx;
    var _ly = (_lanterns[_i][1] * 16 + 8 - _cy) * _sy;
    if (_lx < -80 * _sx || _lx > _gw + 80 * _sx || _ly < -80 * _sy || _ly > _gh + 80 * _sy) continue;
    draw_set_alpha(dark_alpha * 0.45);
    draw_circle(_lx, _ly, 72 * _sx, false);
    draw_set_alpha(0.9);
    draw_circle(_lx, _ly, 44 * _sx, false);
}
gpu_set_blendmode_reset();
surface_reset_target();
draw_set_alpha(1);
draw_surface(surface_id, 0, 0);

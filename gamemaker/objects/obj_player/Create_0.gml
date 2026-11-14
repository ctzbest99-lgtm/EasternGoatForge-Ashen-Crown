/// obj_player : Create
move_speed = PLAYER_MOVE_SPEED;
facing_x = 0;
facing_y = 1;
input_enabled = true;

// Interaction: how far (in pixels) past the edge of the collision mask the player can reach.
interact_reach = PLAYER_INTERACT_REACH;

// Collision targets: every obj_solid (and its children), plus an optional tile layer named
// "Collision" in the current room. Arrays of objects/tilemaps in place_meeting need GameMaker 2023.1+.
collision_targets = [obj_solid];
var _collision_layer = layer_get_id("Collision");
if (_collision_layer != -1) {
    var _collision_tilemap = layer_tilemap_get_id(_collision_layer);
    if (_collision_tilemap != -1) array_push(collision_targets, _collision_tilemap);
}

// Prefer the imported 16×24 Kael sheet; if it is missing the IDE sprite (placeholder) is kept.
scr_player_sprites_init();
depth = -y;

// Safety: if this instance was created overlapping an obj_solid (or a child
// such as obj_interactable), nudge to the nearest free position. The map
// builder also calls this after moving the player to player_start.
scr_player_unstick();

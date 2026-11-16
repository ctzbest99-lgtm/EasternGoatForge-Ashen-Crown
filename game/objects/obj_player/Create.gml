/// obj_player : Create
move_speed = 2;
facing_x = 0;
facing_y = 1;
input_enabled = true;

/// Animation sheets. Import them from assets/characters/; asset_get_index keeps this file valid
/// before they exist, and -1 makes the matching action refuse to start rather than lock movement.
walk_sprite = asset_get_index("spr_kael_walk");
attack_sprite = asset_get_index("spr_kael_attack");
hurt_sprite = asset_get_index("spr_kael_hurt");
walk_fps = 16;
attack_fps = 12;
hurt_hold_us = 300000;   /// hurt is a single frame held for 0.3 s
sprite_index = walk_sprite;
image_speed = 0;   /// playback is driven by scr_player_animation, not by the sprite's own speed

walk_clock = 0;
walk_row = 0;
walk_frame = 0;

action_state = PLAYER_ACTION.FREE;
action_clock = 0;

/// obj_dialogue_box : Destroy
/// Every exit path — last line, ESC, or manual removal — clears the flag and restores what it locked.
global.dialogue_open = false;
/// The closing press is the same key the NPC listens for, so record when it happened and let the
/// cooldown stop an instant reopen.
global.dialogue_closed_ms = current_time;

for (var _i = 0; _i < array_length(locked_players); _i++) {
    if (instance_exists(locked_players[_i])) locked_players[_i].input_enabled = true;
}

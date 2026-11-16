/// obj_battle_controller : Step
/// Every transition is on keyboard_check_pressed, never keyboard_check, so holding a key cannot
/// resolve the same command twice.
/// Victory pays out immediately, once: the panel shows the level-ups before the player leaves.
if (battle.state == BATTLE_PHASE.VICTORY && !battle.rewarded) {
    if (scr_battle_grant_rewards(battle)) {
        level_ups = scr_party_apply_rewards(scr_party_ensure_global(), battle.rewards);
        /// The game controller writes the save once this battle has closed, so rewards are on disk.
        scr_game_request_autosave("victory");
    }
}

if (battle.finished) {
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) exit_battle = true;
} else {
    var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    if (battle.state == BATTLE_PHASE.ITEM) {
        /// ESC backs out of the item list without spending the turn.
        if (keyboard_check_pressed(vk_escape)) scr_battle_close_items(battle);
        else {
            if (_up) scr_battle_move_item_cursor(battle, -1);
            if (_down) scr_battle_move_item_cursor(battle, 1);
        }
    } else {
        if (_up) scr_battle_move_cursor(battle, -1);
        if (_down) scr_battle_move_cursor(battle, 1);
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) scr_battle_advance(battle);
}
if (exit_battle) {
    /// Destroy restores exploration input and clears the encounter lock.
    instance_destroy();
}

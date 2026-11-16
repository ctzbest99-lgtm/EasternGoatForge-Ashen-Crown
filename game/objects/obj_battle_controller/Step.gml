/// obj_battle_controller : Step
/// Every transition is on keyboard_check_pressed, never keyboard_check, so holding a key cannot
/// resolve the same command twice.
if (battle.finished) {
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) exit_battle = true;
} else {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) scr_battle_move_cursor(battle, -1);
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) scr_battle_move_cursor(battle, 1);
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) scr_battle_advance(battle);
}
if (exit_battle) {
    /// Rewards are collected before the controller disappears; falling through to Destroy restores input.
    if (battle.state == BATTLE_PHASE.VICTORY) scr_battle_grant_rewards(battle);
    instance_destroy();
}

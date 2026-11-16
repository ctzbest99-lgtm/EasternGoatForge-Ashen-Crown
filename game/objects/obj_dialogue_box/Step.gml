/// obj_dialogue_box : Step
/// The typewriter runs on delta_time; every press is a discrete keyboard_check_pressed, so holding a key
/// can neither skim a scene nor skip two lines.
if (scr_dialogue_revealing(dialogue)) scr_dialogue_tick(dialogue, delta_time);

if (keyboard_check_pressed(vk_escape)) {
    scr_dialogue_close(dialogue);
} else if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    /// First press completes the line, second moves on: fast readers never wait for the text.
    /// Flags are passed here so a scene that reaches its end can complete a quest; ESC above cannot.
    var _result = scr_dialogue_confirm(dialogue, scr_flags_ensure_global());
    /// A scene that reached its end may have completed a quest: pay it out here. The paid flag makes a
    /// second call harmless, so a closed reward page cannot grant the item twice.
    if (_result == "closed") {
        var _granted = scr_quest_pay_out(scr_flags_ensure_global(), scr_party_ensure_global());
        /// Show what was received as its own page; the player reads it and presses once more to close.
        if (array_length(_granted) > 0) scr_dialogue_show_reward(dialogue, scr_quest_reward_text(_granted));
    }
}

if (!dialogue.open) instance_destroy();

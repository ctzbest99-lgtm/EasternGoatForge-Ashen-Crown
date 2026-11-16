/// obj_shop : Destroy
/// Every exit path restores exploration input and clears the flag, so the panel can never leave the player
/// unable to move or block a second shop from opening.
for (var _i = 0; _i < array_length(locked_players); _i++) {
    if (instance_exists(locked_players[_i])) locked_players[_i].input_enabled = true;
}
global.shop_open = false;

/// scr_battle_start — create the overlay battle controller once. Returns the instance, or noone.
/// A second battle is refused: two controllers would fight over the same keys and draw two panels.
/// obj_enemy does not exist yet, so a trigger calls this; later the overworld enemy passes itself as
/// _source_instance and the controller removes it on victory.
function scr_battle_start(_enemy_id, _source_instance = noone) {
    var _obj = asset_get_index("obj_battle_controller");
    if (_obj < 0) {
        show_debug_message("scr_battle_start: obj_battle_controller is not in this project");
        return noone;
    }
    if (instance_number(_obj) > 0) return noone;
    if (is_undefined(scr_get_enemy_data(_enemy_id))) {
        show_debug_message("scr_battle_start: unknown enemy id " + string(_enemy_id));
        return noone;
    }
    /// The struct is applied before Create runs, so the controller is created already knowing its enemy.
    return instance_create_depth(0, 0, 0, _obj, { enemy_id: _enemy_id, source_instance: _source_instance });
}

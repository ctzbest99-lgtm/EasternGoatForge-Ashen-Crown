/// obj_save_menu : Draw GUI
scr_ui_set_font();
scr_menu_draw_dither();
var _hint = (mode == "load") ? "Load which file?" : "Choose a slot";
scr_menu_draw_save_slots(slots, index, mode, _hint, message);
if (confirming_overwrite) {
    var _info = (array_length(slots) > index) ? slots[index] : { location_name: "", lead_level: 1 };
    var _loc = variable_struct_exists(_info, "location_name") ? _info.location_name : "";
    var _lv = variable_struct_exists(_info, "lead_level") ? _info.lead_level : 1;
    scr_menu_draw_overwrite(index + 1, _loc, _lv, prompt_index != 0);
}

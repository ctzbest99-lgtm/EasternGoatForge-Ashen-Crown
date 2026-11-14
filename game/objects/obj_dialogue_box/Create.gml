/// obj_dialogue_box : Create
/// Created only through scr_dialogue_open(), which sets `lines` and `speaker_name` right after this runs.
lines = [];
speaker_name = "";
line_index = 0;
opened_frame = global.game.frame; // ignore the confirm press that opened the box

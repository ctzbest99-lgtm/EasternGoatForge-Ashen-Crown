/// obj_dialogue_box : Create
/// Created only through scr_dialogue_open(), which sets `lines`, `speaker_name`,
/// and `struck_lines` right after this runs.
lines = [];
speaker_name = "";
struck_lines = [];
line_index = 0;
opened_frame = global.game.frame; // ignore the confirm press that opened the box

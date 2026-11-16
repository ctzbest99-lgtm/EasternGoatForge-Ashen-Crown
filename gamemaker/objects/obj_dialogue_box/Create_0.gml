/// obj_dialogue_box : Create
/// Created only through scr_dialogue_open(), which sets `lines`, `speaker_name`,
/// and `struck_lines` right after this runs.
lines = [];
speaker_name = "";
struck_lines = [];
line_index = 0;
opened_frame = global.game.frame; // ignore the confirm press that opened the box
choices = [];       // optional choice on the last line (scr_dialogue_choice)
choice_index = 0;
on_choice = undefined;
portrait_expr = "neutral"; // set per node (Chapter 2 `expr`); falls back to neutral / the speaker default
scr_audio_sfx("text", 0, 0.7); // quiet page-open blip

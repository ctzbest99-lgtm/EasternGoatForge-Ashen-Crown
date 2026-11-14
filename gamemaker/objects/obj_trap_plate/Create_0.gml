/// obj_trap_plate : Create
/// Pressure plate. Not solid. The trap hall's safe path is the sigil stones
/// (safe_tiles are never spawned). Stepping on a plate plays WT_TRAP_01 (or the
/// marker's lines), deals damage_pct of each living active member's max HP
/// (minimum 1, never reduces HP below 1 — plates cannot KO), and knocks the
/// player 8 pixels back along the step they just took. Each plate fires once
/// per session (sprung stays true). Parent: none. Sprite: 16×16, Top Left,
/// e.g. spr_encounter_trigger_placeholder (semi-transparent). Visible follows
/// DEBUG_SHOW_TRIGGERS unless you assign a visible spike tile later.
map_marker = undefined;
script_id = "WT_TRAP_01";
dialogue_lines = ["A pressure plate clicks underfoot—"];
damage_pct = 10;
sprung = false;
armed = false;
visible = DEBUG_SHOW_TRIGGERS;

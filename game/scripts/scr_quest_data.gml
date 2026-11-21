/// Quest journal data (field-menu Quests page).
/// Titles and the main-quest stage text come from ACT2_OUTLINE.md §4 and the chapter scripts;
/// side-quest objective wording is PLACEHOLDER journal text, because the scripts never printed it.
/// Stage state lives in the flags as quest_<QUEST_ID> = "<STAGE_ID>" or "complete", written by
/// scr_quest_advance from the chapter callbacks/ticks. Flags are saved (scr_save.gml), so the
/// journal survives a load without new save fields.

/// All known quests, in journal order. Each stage is { id, text }.
function scr_quest_definitions() {
    return [
        {
            id: "Q_MAIN_FIND_MIRA",
            title: "Find Mira",
            kind: "Main quest",
            // CHAPTER1_SCRIPT.md §0. The stage text is the approved script text.
            stages: [
                { id: "Q_FM_S1", text: "Find Father among the survivors." },
                { id: "Q_FM_S2", text: "Search the ruins of Varyn House." },
                { id: "Q_FM_S3", text: "Leave Greyhaven by the North Gate." },
                { id: "Q_FM_S4", text: "Cross the Farmlands toward the Old Road." },
                { id: "Q_FM_S5", text: "Follow the Old Road north." },
                { id: "Q_FM_S6", text: "Search the Abandoned Bandit Camp." },
                { id: "Q_FM_S7", text: "Explore the Old Watchtower." },
                { id: "Q_FM_S8", text: "Find what lies beneath the Watchtower." },
                { id: "Q_FM_S9", text: "Defeat the Blackguard." }
            ]
        },
        {
            id: "Q_MAIN_BEYOND_VEIL",
            title: "Beyond the Veil",
            kind: "Main quest",
            stages: [
                { id: "Q_BV_S1", text: "Find a way beyond the Veil." },
                { id: "Q_BV_S2", text: "Seek help near Millhaven." },
                { id: "Q_BV_S3", text: "Travel to Valemere for answers." },
                { id: "Q_BV_S4", text: "Search the Lower City for a lead." },
                { id: "Q_BV_S5", text: "Find the Hollow Sanctuary named in the notes." },
                { id: "Q_BV_S6", text: "Investigate the Blackwood Road Garrison." },
                { id: "Q_BV_S7", text: "Follow the trail into the Blackwood." }
            ]
        },
        {
            id: "Q_MAIN_BLACKWOOD",
            title: "What the Forest Keeps",
            kind: "Main quest",
            stages: [
                { id: "Q_MBW_S1", text: "Follow the Crown's order into the Blackwood." },
                { id: "Q_MBW_S2", text: "Find out what Cinderhollow pays, and to whom." },
                { id: "Q_MBW_S3", text: "Reach the shrine under the roots." },
                { id: "Q_MBW_S4", text: "Face what holds the glade." },
                { id: "Q_MBW_S5", text: "Find the stone doors." },
                { id: "Q_MBW_S6", text: "Learn what the doors want." }
            ]
        },
        {
            id: "Q_SIDE_TITHE",
            title: "The Next Name",
            kind: "Side quest",
            stages: [
                { id: "Q_ST_S1", text: "Berrin's household is on this autumn's list." },
                { id: "Q_ST_S2", text: "Decide what to tell Berrin." }
            ]
        },
        {
            id: "Q_SIDE_RENN",
            title: "Thinning the Pack",
            kind: "Side quest",
            // CHAPTER1_SCRIPT.md §2.2 only prints the stages as [STAGE] notes, so this
            // journal wording is [PROPOSED] (same convention as Q_SIDE_TITHE above).
            stages: [
                { id: "Q_SR_S1", text: "Kill five Ash Wolves around the Hunter's Camp." },
                { id: "Q_SR_S2", text: "Return to Old Hunter Renn." }
            ]
        },
        {
            id: "Q_MAIN_CROWN",
            title: "The King Who Was Forgotten",
            kind: "Main quest",
            stages: [
                { id: "Q_MC_S1", text: "Find the Crown's record of what it built." },
                { id: "Q_MC_S2", text: "Take the torn page to the barrow field." },
                { id: "Q_MC_S3", text: "Get past the barrow's warden." },
                { id: "Q_MC_S4", text: "Open the tomb of the forgotten king." },
                { id: "Q_MC_S5", text: "Learn what the charter names." },
                { id: "Q_MC_S6", text: "Decide who carries the seal." }
            ]
        },
        {
            id: "Q_SIDE_LEDGER",
            title: "The Page Nobody Asked For",
            kind: "Side quest",
            stages: [
                { id: "Q_SL_S1", text: "Vell's clerk wants the page copied before it leaves." },
                { id: "Q_SL_S2", text: "Decide whether the clerk gets her copy." }
            ]
        },
        {
            id: "Q_SIDE_ODA",
            title: "The One on the List",
            kind: "Side quest",
            stages: [
                { id: "Q_SO_S1", text: "Find Oda's brother among the accused at Wrenfield." },
                { id: "Q_SO_S2", text: "Tell Oda her brother is alive." }
            ]
        },
        {
            id: "Q_SIDE_PARCEL",
            title: "A Parcel Unsealed",
            kind: "Side quest",
            stages: [
                { id: "Q_SP_S1", text: "Deliver Nim's parcel to the stall in the Merchant District." },
                { id: "Q_SP_S2", text: "Collect your payment from Nim at the Salt Lamp." }
            ]
        }
    ];
}

/// The stored stage id for a quest ("" when the quest has never been started).
function scr_quest_stage(_quest_id) {
    var _v = scr_flag_get("quest_" + string(_quest_id));
    return is_string(_v) ? _v : "";
}

/// Write a quest stage without ordering rules. Prefer scr_quest_advance() for
/// progression; use this for a deliberate reset or the initial stage.
function scr_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + string(_quest_id), string(_stage_id));
}

/// Index of a stage in its quest definition, or -1 when the id is unknown.
function scr_quest_stage_index(_quest_id, _stage_id) {
    var _q = scr_quest_definition(_quest_id);
    if (!is_struct(_q)) return -1;
    for (var _i = 0; _i < array_length(_q.stages); _i++) {
        if (_q.stages[_i].id == _stage_id) return _i;
    }
    return -1;
}

/// Advance a quest only forward. Backtracking, replayed scenes and duplicate
/// triggers cannot move the journal backwards. Returns true when the stage changed.
function scr_quest_advance(_quest_id, _stage_id) {
    var _cur = scr_quest_stage(_quest_id);
    if (_cur == "complete") return false;
    if (_stage_id == "complete") {
        scr_quest_set(_quest_id, "complete");
        return true;
    }
    var _new_idx = scr_quest_stage_index(_quest_id, _stage_id);
    if (_new_idx < 0) return false;
    if (_cur == "") {
        scr_quest_set(_quest_id, _stage_id);
        return true;
    }
    var _old_idx = scr_quest_stage_index(_quest_id, _cur);
    if (_old_idx < 0 || _new_idx > _old_idx) {
        scr_quest_set(_quest_id, _stage_id);
        return true;
    }
    return false;
}

function scr_quest_is_started(_quest_id) {
    return (scr_quest_stage(_quest_id) != "");
}

function scr_quest_is_complete(_quest_id) {
    return (scr_quest_stage(_quest_id) == "complete");
}

/// One definition struct, or undefined.
function scr_quest_definition(_quest_id) {
    var _all = scr_quest_definitions();
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].id == _quest_id) return _all[_i];
    }
    return undefined;
}

/// Journal entry for the started quests, in definition order.
/// Each entry: { id, title, kind, stage_id, text, stage, total, complete }.
function scr_quest_started_list() {
    var _all = scr_quest_definitions();
    var _out = [];
    for (var _i = 0; _i < array_length(_all); _i++) {
        var _q = _all[_i];
        var _stage_id = scr_quest_stage(_q.id);
        if (_stage_id == "") continue;
        var _complete = (_stage_id == "complete");
        var _defs = _q.stages;
        var _total = array_length(_defs);
        var _stage = _complete ? _total : 0;
        var _text = _complete ? "Complete." : "";
        for (var _s = 0; _s < _total; _s++) {
            var _st = _defs[_s];
            if (_st.id == _stage_id) {
                _stage = _s + 1;
                _text = _st.text;
                break;
            }
        }
        // An unknown stage id still shows the quest rather than hiding it.
        if (_text == "" && !_complete) _text = "In progress.";
        array_push(_out, {
            id: _q.id,
            title: _q.title,
            kind: _q.kind,
            stage_id: _stage_id,
            text: _text,
            stage: _stage,
            total: array_length(_q.stages),
            complete: _complete
        });
    }
    return _out;
}

/// How many quests are open (started and not complete).
function scr_quest_open_count() {
    var _list = scr_quest_started_list();
    var _n = 0;
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (!_list[_i].complete) _n += 1;
    }
    return _n;
}

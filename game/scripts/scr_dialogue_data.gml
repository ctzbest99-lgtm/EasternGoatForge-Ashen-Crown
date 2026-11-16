/// scr_dialogue_data — Chapter 1 dialogue nodes keyed by stable IDs from
/// docs/story/CHAPTER1_SCRIPT.md (ZONE_PLACE_NN). Text is verbatim from the script.
/// Speaker "" is NARRATION (no name in the box). Chapters 2–3 are approved and live in
/// scr_dialogue_data_ch2 / scr_dialogue_data_ch3 (chained at the bottom of scr_dialogue_node).

function scr_dialogue_node(_id) {
    switch (_id) {
        // ENC_ASHBOUND_HUNTER (CHAPTER1_SCRIPT.md §4.1)
        case "ENC_AH_01":
            return { id: "ENC_AH_01", speaker: "", lines: ["An arrow slams into the dirt beside Kael's boot."] };
        case "ENC_AH_02":
            return { id: "ENC_AH_02", speaker: "Kael", lines: ["That was a warning. Or a bad shot. Let's find out which."] };
        case "ENC_AH_03":
            return { id: "ENC_AH_03", speaker: "", lines: ["A folded parchment is tucked inside the hunter's coat."] };
        case "ENC_AH_04":
            return { id: "ENC_AH_04", speaker: "Parchment", lines: ["“Find the girl. The Varyn girl is still alive.”"] };
        case "ENC_AH_05":
            return { id: "ENC_AH_05", speaker: "Kael", lines: ["Alive.", "...Then who else is looking for her?"] };

        // FL_TUTORIAL (CHAPTER1_SCRIPT.md §2.1) — first guaranteed Bandit fight.
        // 01–03 play before the battle, 04–05 after it; the SYS lines play in the
        // battle itself (obj_battle_controller, tutorial encounter).
        case "FL_TUTORIAL_01":
            return { id: "FL_TUTORIAL_01", speaker: "Bandit", lines: ["Well, well. A soldier boy, picking through the ashes like the rest of us."] };
        case "FL_TUTORIAL_02":
            return { id: "FL_TUTORIAL_02", speaker: "Kael", lines: ["Move."] };
        case "FL_TUTORIAL_03":
            return { id: "FL_TUTORIAL_03", speaker: "Bandit", lines: ["Big talk. Let's see that sword, then."] };
        case "FL_TUTORIAL_04":
            return { id: "FL_TUTORIAL_04", speaker: "Bandit", lines: ["Should've... stayed in the army..."] };
        case "FL_TUTORIAL_05":
            return { id: "FL_TUTORIAL_05", speaker: "Kael", lines: ["Should've stayed out of my way."] };
        case "FL_TUTORIAL_SYS_01":
            return { id: "FL_TUTORIAL_SYS_01", speaker: "SYSTEM", lines: ["Choose a command for Kael: Attack, Skills, Defend, or Items.", "Turn order depends on Speed."] };
        case "FL_TUTORIAL_SYS_02":
            return { id: "FL_TUTORIAL_SYS_02", speaker: "SYSTEM", lines: ["Attack deals physical damage. Defend reduces damage taken until your next turn."] };
        case "FL_TUTORIAL_SYS_03":
            return { id: "FL_TUTORIAL_SYS_03", speaker: "SYSTEM", lines: ["Careful: some foes hit harder against a defending target. Bandits fight dirty."] };
        case "FL_TUTORIAL_SYS_04":
            return { id: "FL_TUTORIAL_SYS_04", speaker: "SYSTEM", lines: ["Items such as a Minor Potion restore HP. Using one takes Kael's turn."] };
        case "FL_TUTORIAL_SYS_05":
            return { id: "FL_TUTORIAL_SYS_05", speaker: "SYSTEM", lines: ["Last Stand: below 25% HP, Kael's Attack rises 15% and Defense 10%."] };

        // GH_ARRIVAL (§1.1)
        case "GH_ARRIVAL_01":
            return { id: "GH_ARRIVAL_01", speaker: "", lines: ["Four years in the Royal Army. Kael Varyn came home to Greyhaven.", "What was left of it."] };
        case "GH_ARRIVAL_02":
            return { id: "GH_ARRIVAL_02", speaker: "Kael", lines: ["...No."] };
        case "GH_ARRIVAL_03":
            return { id: "GH_ARRIVAL_03", speaker: "Kael", lines: ["Father. Mira."] };

        // GH_TOMAS (§1.2)
        case "GH_TOMAS_01":
            return { id: "GH_TOMAS_01", speaker: "Pell", lines: ["Kael? Gods. He kept saying you'd come. Over here. Careful."] };
        case "GH_TOMAS_02":
            return { id: "GH_TOMAS_02", speaker: "Kael", lines: ["Father."] };
        case "GH_TOMAS_03":
            return { id: "GH_TOMAS_03", speaker: "Tomas", lines: ["Kael... you came home."] };
        case "GH_TOMAS_04":
            return { id: "GH_TOMAS_04", speaker: "Kael", lines: ["Don't talk. Where's Mira?"] };
        case "GH_TOMAS_05":
            return { id: "GH_TOMAS_05", speaker: "Tomas", lines: ["“Your sister… she went into the woods.”"] };
        case "GH_TOMAS_06":
            return { id: "GH_TOMAS_06", speaker: "Kael", lines: ["The woods? Why would she—"] };
        case "GH_TOMAS_07":
            return { id: "GH_TOMAS_07", speaker: "Pell", lines: ["He's been like that since. In and out. I'll stay with him. Go."] };
        case "GH_TOMAS_08":
            return { id: "GH_TOMAS_08", speaker: "Kael", lines: ["Keep him breathing. I'll be back."] };
        case "GH_TOMAS_R1":
            return { id: "GH_TOMAS_R1", speaker: "", lines: ["He's breathing. Barely."] };
        case "GH_TOMAS_R2":
            return { id: "GH_TOMAS_R2", speaker: "Pell", lines: ["I've got him. Find her, Kael."] };
        case "GH_SMITH_01_B":
            return { id: "GH_SMITH_01_B", speaker: "Pell", lines: ["His tools are mostly fine. Iron's tougher than people.", "Take what you need for the road."] };

        // GH_HOUSE (§1.3)
        case "GH_HOUSE_01":
            return { id: "GH_HOUSE_01", speaker: "", lines: ["Mother's table. Split down the middle."] };
        case "GH_HOUSE_02":
            return { id: "GH_HOUSE_02", speaker: "", lines: ["The roof came down here. Nothing underneath. Thank the gods."] };
        case "GH_HOUSE_03":
            return { id: "GH_HOUSE_03", speaker: "", lines: ["Under the ash and splinters: a small wooden pendant on a cord.", "Mira's."] };
        case "GH_HOUSE_04":
            return { id: "GH_HOUSE_04", speaker: "SYSTEM", lines: ["Obtained: Mira's Wooden Pendant (Story Item)."] };
        case "GH_HOUSE_05":
            return { id: "GH_HOUSE_05", speaker: "Kael", lines: ["No body. That means something.", "...It has to."] };

        // Survivors (§1.4)
        case "GH_TAVERN_01":
            return { id: "GH_TAVERN_01", speaker: "Hob", lines: ["Kael Varyn. Wish you'd picked a better week to come home.", "Bar's still standing. That's about all."] };
        case "GH_TAVERN_02":
            return { id: "GH_TAVERN_02", speaker: "Hob", lines: ["Don't ask me what happened. I was in the cellar. I heard it. That's enough."] };
        case "GH_TAVERN_03":
            return { id: "GH_TAVERN_03", speaker: "Kael", lines: ["I didn't ask."] };
        case "GH_TAVERN_04":
            return { id: "GH_TAVERN_04", speaker: "Hob", lines: ["You were going to. Your old man's at the forge, if he's still with us."] };
        case "GH_CHAPEL_01":
            return { id: "GH_CHAPEL_01", speaker: "Sister Ilse", lines: ["We've counted the dead twice. Your sister wasn't among them.", "I don't know if that's a mercy."] };
        case "GH_CHAPEL_02":
            return { id: "GH_CHAPEL_02", speaker: "Sister Ilse", lines: ["Mira came here last month with a black stone. Asked me what the mark on it meant."] };
        case "GH_CHAPEL_03":
            return { id: "GH_CHAPEL_03", speaker: "Sister Ilse", lines: ["I told her to throw it away. She smiled at me the way children do", "when they've already decided not to."] };
        case "GH_STORE_01":
            return { id: "GH_STORE_01", speaker: "Marda", lines: ["Shelves are half ash, but potions don't burn easy.", "Coin's still coin, Kael. Even now."] };
        case "GH_STORE_02":
            return { id: "GH_STORE_02", speaker: "Kael", lines: ["Your prices go up?"] };
        case "GH_STORE_03":
            return { id: "GH_STORE_03", speaker: "Marda", lines: ["Everything went up. Including the roof. Buying or not?"] };
        case "GH_SQUARE_01":
            return { id: "GH_SQUARE_01", speaker: "Old Wenna", lines: ["The well still runs. Strange, what's left standing."] };
        case "GH_SQUARE_02":
            return { id: "GH_SQUARE_02", speaker: "Dov", lines: ["Mira said she found a door in the ground. Under the town.", "Nobody believed her. I didn't either."] };
        case "GH_SQUARE_03":
            return { id: "GH_SQUARE_03", speaker: "Kael", lines: ["Where under the town?"] };
        case "GH_SQUARE_04":
            return { id: "GH_SQUARE_04", speaker: "Dov", lines: ["She wouldn't tell. Said it was hers."] };
        case "GH_GATE_01_A":
            return { id: "GH_GATE_01_A", speaker: "Corwin", lines: ["Gate stays shut till you've seen your father. He asked for you. Every hour."] };
        case "GH_GATE_01_B":
            return { id: "GH_GATE_01_B", speaker: "Corwin", lines: ["Woods, is it? Then take the Old Road. Farmlands first.", "Bandits came sniffing after the fires. Keep your blade out."] };
        case "GH_GATE_02_B":
            return { id: "GH_GATE_02_B", speaker: "Corwin", lines: ["Someone saw small tracks heading north past the fields. Could be anyone's."] };
        case "GH_GATE_03_B":
            return { id: "GH_GATE_03_B", speaker: "Kael", lines: ["Could be hers."] };

        // FK (§5.1 / §6.3)
        case "FK_01_01":
            return { id: "FK_01_01", speaker: "Fallen Knight", lines: ["...Varyn."] };
        case "FK_01_02":
            return { id: "FK_01_02", speaker: "Kael", lines: ["You know me?"] };
        case "FK_01_03":
            return { id: "FK_01_03", speaker: "Fallen Knight", lines: ["“Your father knew what was coming.”"] };
        case "FK_01_04":
            return { id: "FK_01_04", speaker: "Kael", lines: ["What's that supposed to mean? Hey—!"] };
        case "FK_02_01":
            return { id: "FK_02_01", speaker: "Kael", lines: ["You. Talk. Where is my sister?"] };
        case "FK_02_02":
            return { id: "FK_02_02", speaker: "Fallen Knight", lines: ["“She opened the door.”"] };
        case "FK_02_03":
            return { id: "FK_02_03", speaker: "Kael", lines: ["What door? —"] };

        // Watchtower inspect (§6.1–6.2)
        case "WT_BANNER_01":
            return { id: "WT_BANNER_01", speaker: "", lines: ["An old royal banner hangs in tatters. The symbol stitched at its center..."] };
        case "WT_BANNER_02":
            return { id: "WT_BANNER_02", speaker: "", lines: ["...is the same mark carved on Mira's pendant."] };
        case "WT_BANNER_03":
            return { id: "WT_BANNER_03", speaker: "Kael", lines: ["A royal banner. Mira's pendant. Same mark.", "Why would the crown share anything with a girl from Greyhaven?"] };
        case "WT_DOOR_LOCKED":
            return { id: "WT_DOOR_LOCKED", speaker: "", lines: ["Locked. The keyhole is crusted with rust."] };
        case "WT_KEY_01":
            return { id: "WT_KEY_01", speaker: "SYSTEM", lines: ["Obtained: Watchtower Key."] };
        case "WT_SYMBOL_01":
            return { id: "WT_SYMBOL_01", speaker: "", lines: ["Carvings older than the tower itself. The stone around them is too smooth."] };
        case "WT_NOTE_01":
            return { id: "WT_NOTE_01", speaker: "Faded Note", lines: ["Third week without relief. They say the post's being closed. Nobody says why."] };
        case "WT_NOTE_02":
            return { id: "WT_NOTE_02", speaker: "Faded Note", lines: ["Scratching under the floor again last night. Rats, says the sergeant. Big rats."] };
        case "WT_TRAP_01":
            return { id: "WT_TRAP_01", speaker: "", lines: ["A pressure plate clicks underfoot—"] };

        // WB_CARVING (§7.1)
        case "WB_CARVING_01":
            return { id: "WB_CARVING_01", speaker: "", lines: ["A great crown, carved around a black sun."] };
        case "WB_CARVING_02":
            return { id: "WB_CARVING_02", speaker: "", lines: ["Beneath it, a woman stands before a stone door."] };
        case "WB_CARVING_03":
            return { id: "WB_CARVING_03", speaker: "", lines: ["The stone is worn smooth by thousands of years. The face is not."] };
        case "WB_CARVING_04":
            return { id: "WB_CARVING_04", speaker: "Kael", lines: ["...Mira?", "No. That's not possible."] };
        case "WB_CARVING_05":
            return { id: "WB_CARVING_05", speaker: "Kael", lines: ["This was old before Greyhaven had a name. So why does it have her face?"] };

        // BG_INTRO / BG_DEFEAT (§8) — Chapter 1 canon, not Chapter 2 [PROPOSED]
        case "BG_INTRO_01":
            return { id: "BG_INTRO_01", speaker: "Blackguard", lines: ["“You shouldn’t have come here.”"] };
        case "BG_INTRO_02":
            return { id: "BG_INTRO_02", speaker: "Kael", lines: ["“Where is my sister?”"] };
        case "BG_INTRO_03":
            return { id: "BG_INTRO_03", speaker: "Blackguard", lines: ["“You still don’t know.”"] };
        case "BG_INTRO_04":
            return { id: "BG_INTRO_04", speaker: "Kael", lines: ["“Know what?”"] };
        case "BG_INTRO_05":
            return { id: "BG_INTRO_05", speaker: "Blackguard", lines: ["“What she opened.”"] };
        case "BG_DEFEAT_01":
            return { id: "BG_DEFEAT_01", speaker: "Blackguard", lines: ["“The girl didn’t disappear, Kael.”"] };
        case "BG_DEFEAT_02":
            return { id: "BG_DEFEAT_02", speaker: "Kael", lines: ["“What did you say?”"] };
        case "BG_DEFEAT_03":
            return { id: "BG_DEFEAT_03", speaker: "Blackguard", lines: ["“She crossed the Crownveil.”"] };
        case "BG_REWARD_01":
            return { id: "BG_REWARD_01", speaker: "SYSTEM", lines: ["Obtained: Blackguard's Longsword. Obtained: Crownveil Fragment."] };

        // CV_END (§9)
        case "CV_END_01":
            return { id: "CV_END_01", speaker: "Kael", lines: ["The Crownveil. The thing that's supposed to keep us safe.", "...Mira. What did you do?"] };
        case "CV_END_02":
            return { id: "CV_END_02", speaker: "", lines: ["The pendant at Kael's chest grows warm. It is reacting to the door."] };
        case "CV_END_03":
            return { id: "CV_END_03", speaker: "", lines: ["Something touches the other side."] };
        case "CV_END_04":
            return { id: "CV_END_04", speaker: "", lines: ["Then everything stops."] };
        case "CV_END_05":
            return { id: "CV_END_05", speaker: "SYSTEM", lines: ["Quest updated: Find Mira → Beyond the Veil."] };
        case "CV_END_06":
            return { id: "CV_END_06", speaker: "SYSTEM", lines: ["Chapter 1 — The Night of Ash — Complete."] };
    }
    var _ch2 = scr_ch2_dialogue_node(_id); // Chapter 2 (scr_dialogue_data_ch2, generated)
    if (is_struct(_ch2)) return _ch2;
    var _ch3 = scr_ch3_dialogue_node(_id); // Chapter 3 (scr_dialogue_data_ch3, generated)
    if (is_struct(_ch3)) return _ch3;
    var _ch4 = scr_ch4_dialogue_node(_id); // Chapter 4 (scr_dialogue_data_ch4, generated)
    if (is_struct(_ch4)) return _ch4;
    var _ch5 = scr_ch5_dialogue_node(_id); // Chapter 5 (scr_dialogue_data_ch5, generated)
    if (is_struct(_ch5)) return _ch5;
    return scr_ch6_dialogue_node(_id); // Chapter 6 (scr_dialogue_data_ch6, generated)
}

function scr_dialogue_play_script(_script_id, _source = noone) {
    scr_game_state_init();
    // Chapter 2 first: its own ids, plus Act II versions of Chapter 1 scenes (Greyhaven return, CV door).
    if (scr_ch2_play_script(_script_id, _source)) return true;
    // Chapter 3 (Crowns and Alleys). Runs after Chapter 2 so its Wrenfield exits still resolve.
    if (scr_ch3_play_script(_script_id, _source)) return true;
    // Chapter 4 (The Old Name): the hollow approach, the sanctuary, Caelan, the Warden.
    if (scr_ch4_play_script(_script_id, _source)) return true;
    // Chapter 5 (The Deserted Oath): the garrison road, Hailen, and Sera.
    if (scr_ch5_play_script(_script_id, _source)) return true;
    // Chapter 6 (The Green Silence): the Blackwood road, Cinderhollow, the camp and the burn line.
    if (scr_ch6_play_script(_script_id, _source)) return true;
    switch (_script_id) {
        case "GH_ARRIVAL":
            if (scr_flag_get("flag_arrived_greyhaven")) return true;
            scr_dialogue_play(["GH_ARRIVAL_01", "GH_ARRIVAL_02", "GH_ARRIVAL_03"], function() {
                scr_flag_set("flag_arrived_greyhaven");
            });
            return true;
        case "GH_TOMAS":
            if (scr_flag_get("flag_met_tomas")) {
                var _npc = "";
                if (_source != noone && instance_exists(_source) && variable_instance_exists(_source, "npc_id")) {
                    _npc = _source.npc_id;
                }
                if (_npc == "pell") {
                    if (scr_flag_get("flag_pendant_found")) {
                        scr_dialogue_play(["GH_SMITH_01_B"], function() {
                            scr_shop_open("shop_greyhaven_forge");
                        });
                    } else scr_dialogue_play(["GH_TOMAS_R2"]);
                } else {
                    scr_dialogue_play(["GH_TOMAS_R1"]);
                }
            } else {
                scr_dialogue_play(
                    ["GH_TOMAS_01", "GH_TOMAS_02", "GH_TOMAS_03", "GH_TOMAS_04", "GH_TOMAS_05", "GH_TOMAS_06", "GH_TOMAS_07", "GH_TOMAS_08"],
                    function() { scr_flag_set("flag_met_tomas"); }
                );
            }
            return true;
        case "GH_HOUSE_01":
            scr_dialogue_play(["GH_HOUSE_01"]);
            return true;
        case "GH_HOUSE_02":
            scr_dialogue_play(["GH_HOUSE_02"]);
            return true;
        case "GH_HOUSE_03":
            if (scr_flag_get("flag_pendant_found") || scr_inventory_has("item_mira_pendant")) return true;
            var _item_src = _source;
            scr_dialogue_play(["GH_HOUSE_03", "GH_HOUSE_04", "GH_HOUSE_05"], method({ src: _item_src }, function() {
                scr_inventory_add("item_mira_pendant", "Mira's Wooden Pendant", 1, true);
                scr_flag_set("flag_pendant_found");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "GH_TAVERN":
        case "GH_TAVERN_01":
            scr_dialogue_play(["GH_TAVERN_01", "GH_TAVERN_02", "GH_TAVERN_03", "GH_TAVERN_04"]);
            return true;
        case "GH_CHAPEL":
        case "GH_CHAPEL_01":
            scr_dialogue_play(["GH_CHAPEL_01", "GH_CHAPEL_02", "GH_CHAPEL_03"]);
            return true;
        case "GH_STORE":
        case "GH_STORE_01":
            scr_dialogue_play(["GH_STORE_01", "GH_STORE_02", "GH_STORE_03"], function() {
                scr_shop_open("shop_greyhaven_store");
            });
            return true;
        case "GH_SQUARE_01":
            scr_dialogue_play(["GH_SQUARE_01"]);
            return true;
        case "GH_SQUARE_02":
            scr_dialogue_play(["GH_SQUARE_02", "GH_SQUARE_03", "GH_SQUARE_04"]);
            return true;
        case "GH_GATE_01_A":
        case "GH_GATE":
            if (scr_flag_get("flag_pendant_found")) {
                scr_dialogue_play(["GH_GATE_01_B", "GH_GATE_02_B", "GH_GATE_03_B"]);
            } else {
                scr_dialogue_play(["GH_GATE_01_A"]);
            }
            return true;
        case "FK_01":
            if (scr_flag_get("flag_fk_seen_1")) return true;
            var _fk1 = _source;
            scr_dialogue_play(["FK_01_01", "FK_01_02", "FK_01_03", "FK_01_04"], method({ src: _fk1 }, function() {
                scr_flag_set("flag_fk_seen_1");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "FK_02":
            if (scr_flag_get("flag_fk_seen_2")) return true;
            var _fk2 = _source;
            scr_dialogue_play(["FK_02_01", "FK_02_02", "FK_02_03"], method({ src: _fk2 }, function() {
                scr_flag_set("flag_fk_seen_2");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "WT_BANNER":
            scr_dialogue_play(["WT_BANNER_01", "WT_BANNER_02", "WT_BANNER_03"], function() {
                scr_flag_set("flag_banner_clue");
            });
            return true;
        case "WT_DOOR_LOCKED":
            scr_dialogue_play(["WT_DOOR_LOCKED"]);
            return true;
        case "WT_KEY_01":
            if (scr_inventory_has("item_watchtower_key")) return true;
            var _key_src = _source;
            scr_dialogue_play(["WT_KEY_01"], method({ src: _key_src }, function() {
                scr_inventory_add("item_watchtower_key", "Watchtower Key", 1, true);
                if (src != noone && instance_exists(src)) {
                    if (variable_instance_exists(src, "map_marker") && is_struct(src.map_marker)) {
                        scr_flag_set("looted_" + src.map_marker.name);
                    }
                    instance_destroy(src);
                }
            }));
            return true;
        case "WT_SYMBOL_01":
            scr_dialogue_play(["WT_SYMBOL_01"]);
            return true;
        case "WT_NOTE_01":
            scr_dialogue_play(["WT_NOTE_01"]);
            return true;
        case "WT_NOTE_02":
            scr_dialogue_play(["WT_NOTE_02"]);
            return true;
        case "WT_TRAP_01":
            scr_dialogue_play(["WT_TRAP_01"]);
            return true;
        case "WB_CARVING":
            if (scr_flag_get("flag_carvings_seen")) {
                scr_dialogue_play(["WB_CARVING_01", "WB_CARVING_02", "WB_CARVING_03"]);
                return true;
            }
            scr_dialogue_play(["WB_CARVING_01", "WB_CARVING_02", "WB_CARVING_03", "WB_CARVING_04", "WB_CARVING_05"], function() {
                scr_flag_set("flag_carvings_seen");
            });
            return true;
        case "BG_INTRO":
            if (scr_flag_get("flag_bg_intro_seen")) return true;
            var _bg = _source;
            scr_dialogue_play(["BG_INTRO_01", "BG_INTRO_02", "BG_INTRO_03", "BG_INTRO_04", "BG_INTRO_05"], method({ src: _bg }, function() {
                scr_flag_set("flag_bg_intro_seen");
                if (src != noone && instance_exists(src)) instance_destroy(src);
                // The script goes from the intro straight into the boss fight.
                if (!variable_struct_exists(global.game.cleared_encounters, "zone01_boss_blackguard")) {
                    scr_encounter_start("blackguard", "zone01_boss_blackguard");
                }
            }));
            return true;
        case "CV_END":
            if (is_struct((_source != noone && instance_exists(_source) && variable_instance_exists(_source, "map_marker")) ? _source.map_marker : undefined)
                && !scr_map_requirement_met(_source.map_marker)) {
                scr_dialogue_open(["[The door is sealed.]"], "");
                return true;
            }
            if (!scr_flag_get("blackguard_defeated")) {
                scr_dialogue_open(["[The door is sealed.]"], "");
                return true;
            }
            if (scr_flag_get("flag_chapter1_complete")) {
                scr_dialogue_open(["[The door is silent now.]"], "");
                return true;
            }
            scr_dialogue_play(["CV_END_01", "CV_END_02", "CV_END_03", "CV_END_04", "CV_END_05", "CV_END_06"], function() {
                scr_flag_set("flag_chapter1_complete");
                // Quiet: saving only exists inside a town's church or tavern (owner decision
                // 2026-11-15). The Crownveil door is not one, so there is no save prompt here.
                scr_save_menu_open("save", false, true);
            });
            return true;
    }
    // Fallback: a known node id, or the source's script_chain.
    if (is_struct(scr_dialogue_node(_script_id))) {
        scr_dialogue_play([_script_id]);
        return true;
    }
    if (_source != noone && instance_exists(_source) && variable_instance_exists(_source, "script_chain") && is_array(_source.script_chain)) {
        scr_dialogue_play(_source.script_chain);
        return true;
    }
    return false;
}

function scr_dialogue_play(_node_ids, _on_finish = undefined) {
    scr_game_state_init();
    var _g = global.game;
    if (!is_array(_node_ids)) _node_ids = [_node_ids];
    for (var _i = 0; _i < array_length(_node_ids); _i++) {
        array_push(_g.dialogue_queue, _node_ids[_i]);
    }
    if (!is_undefined(_on_finish)) _g.dialogue_on_finish = _on_finish;
    scr_dialogue_try_advance_queue();
}

function scr_dialogue_try_advance_queue() {
    scr_game_state_init();
    var _g = global.game;
    if (_g.dialogue_open || instance_exists(obj_dialogue_box)) return;
    if (_g.battle_active || _g.transition_active) return;

    while (array_length(_g.dialogue_queue) > 0) {
        var _id = _g.dialogue_queue[0];
        array_delete(_g.dialogue_queue, 0, 1);
        var _node = scr_dialogue_node(_id);
        if (!is_struct(_node)) continue;
        var _box = scr_dialogue_open(_node.lines, _node.speaker);
        if (_box != noone) {
            if (variable_struct_exists(_node, "expr")) _box.portrait_expr = _node.expr;
            return;
        }
    }

    if (!is_undefined(_g.dialogue_on_finish)) {
        var _cb = _g.dialogue_on_finish;
        _g.dialogue_on_finish = undefined;
        _cb();
    }
}

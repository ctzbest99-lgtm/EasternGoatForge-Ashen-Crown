/// obj_adventure_menu : Create
/// Field-menu shell (I / Tab): Items, Equip, Party Order, Status, Bestiary, Close.
/// Pure UI over existing data (scr_party, scr_bestiary, scr_item_data). Items / Equip
/// hand off to obj_inventory_menu; saving still happens at save points (no save-anywhere).
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
scr_audio_sfx("menu_open", 0, 0.8); // the field menu opening

mode = "list";        // "list" | "status" | "party" | "bestiary" | "quests"
index = 0;            // highlighted menu row
member_index = 0;     // Status: member (active first, then reserve)
party_index = 0;      // Party Order: 0..active-1 are front-line slots, then the reserve row
bestiary_index = 0;   // Bestiary: enemy row
bestiary_scroll = 0;
quest_index = 0;      // Quests: journal row
quest_scroll = 0;
quests = scr_quest_started_list();
message = "";

entries = ["Items", "Equip", "Party Order", "Quests", "Status", "Bestiary", "Close"];

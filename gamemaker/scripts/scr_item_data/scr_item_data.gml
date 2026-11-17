/// scr_item_data — Chapter 1 item table (names, prices, slots, bonuses, use effects).
/// Prices, heal amounts, and stat bonuses are PLACEHOLDER: no item DB prices exist in
/// CHAPTER1_SCRIPT.md or STORY_BIBLE.md yet. See docs/DECISIONS_AND_OPEN_QUESTIONS.md.

function scr_item_id_norm(_item_id) {
    var _s = string(_item_id);
    if (_s == "") return "";
    if (string_copy(_s, 1, 5) == "item_") return _s;
    return "item_" + _s;
}

function scr_item_make(_item_id, _name, _kind, _price, _extra = undefined) {
    var _it = {
        item_id: scr_item_id_norm(_item_id),
        name: _name,
        kind: _kind,          // "consumable" | "weapon" | "armor" | "helm" | "accessory" | "key" | "misc"
        slot: "",             // "weapon" | "armor" | "helm" | "accessory" or ""
        price: max(0, _price),
        sellable: true,
        key_item: false,
        heal: 0,
        cures_poison: false,
        mp_restore: 0,
        atk_bonus: 0,
        def_bonus: 0,
        mdef_bonus: 0,
        spd_bonus: 0,
        weapon_categories: [],
        // Equipment progression metadata (docs/EQUIPMENT_PROGRESSION.md).
        rarity: "common",     // "common" | "uncommon" | "rare" | "legendary"
        act: 0,               // story act (1-8) this tier belongs to; 0 = starting / special
        classes: [],          // roster class_names that may equip it; empty = anyone
        unique: false,        // only one copy may exist; cannot be sold
        acquisition: "",      // short human-readable source, for docs and the report
        desc: ""
    };
    if (_kind == "key") {
        _it.key_item = true;
        _it.sellable = false;
    }
    if (_kind == "weapon") _it.slot = "weapon";
    if (_kind == "armor") _it.slot = "armor";
    if (_kind == "helm") _it.slot = "helm";
    if (_kind == "accessory") _it.slot = "accessory";
    if (is_struct(_extra)) {
        var _names = variable_struct_get_names(_extra);
        for (var _i = 0; _i < array_length(_names); _i++) {
            _it[$ _names[_i]] = _extra[$ _names[_i]];
        }
    }
    if (_it.key_item) _it.sellable = false;
    if (_it.price <= 0) _it.sellable = false;
    return _it;
}

function scr_item_database() {
    if (variable_global_exists("item_db") && is_struct(global.item_db)) return global.item_db;
    var _db = {};
    var _add = function(_db_ref, _it) { _db_ref[$ _it.item_id] = _it; };

    // Consumables (Marda). Heal / prices PLACEHOLDER.
    _add(_db, scr_item_make("item_minor_potion", "Minor Potion", "consumable", 15, {
        heal: ITEM_MINOR_POTION_HEAL,
        desc: "Restores " + string(ITEM_MINOR_POTION_HEAL) + " HP. (PLACEHOLDER amount.)"
    }));
    _add(_db, scr_item_make("item_antidote", "Antidote", "consumable", 20, {
        cures_poison: true,
        desc: "Cures poison, in battle and out. (Price PLACEHOLDER.)"
    }));

    // Chapter 2 (balance pass). Ether: MP recovery, sold by Len in Wrenfield and found in a
    // Millhaven Road chest. Chain Mail: Len's mid-tier item. All numbers / prices PLACEHOLDER.
    // No icons yet (menus fall back to the generic row).
    _add(_db, scr_item_make("item_ether", "Ether", "consumable", 60, {
        mp_restore: ITEM_ETHER_MP,
        desc: "Restores " + string(ITEM_ETHER_MP) + " MP. (PLACEHOLDER amount.)"
    }));
    _add(_db, scr_item_make("item_chain_mail", "Chain Mail", "armor", 220, {
        def_bonus: 4,
        desc: "Riveted rings over padding. DEF +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_travel_brigandine", "Travel Brigandine", "armor", 0, {
        def_bonus: 2,
        sellable: false,
        desc: "Taren's olive brigandine. DEF +2. (PLACEHOLDER.)"
    }));

    // Basic equipment (Pell's forge). Bonuses and prices PLACEHOLDER.
    _add(_db, scr_item_make("item_iron_sword", "Iron Sword", "weapon", 80, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        desc: "A plain iron blade. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_leather_armor", "Leather Armor", "armor", 60, {
        def_bonus: 2,
        desc: "Scuffed travelling leathers. DEF +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_iron_helm", "Iron Helm", "helm", 40, {
        def_bonus: 1,
        desc: "A simple iron cap. DEF +1. (PLACEHOLDER.)"
    }));

    // Starting / unique equipment (not sold). Bonuses PLACEHOLDER.
    _add(_db, scr_item_make("item_kaels_longsword", "Kael's Longsword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Kael's own blade. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_bastard_sword", "Bastard Sword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["heavy_sword"],
        sellable: false,
        desc: "Taren's starting weapon. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_twin_daggers", "Twin Daggers", "weapon", 0, {
        atk_bonus: 2,
        weapon_categories: ["dagger"],
        sellable: false,
        desc: "Lyra's starting weapon. ATK +2. (PLACEHOLDER.)"
    }));
    // Caelan's spellbook: CHAPTER4_SCRIPT.md §6 says it is a starting weapon with no stats yet.
    _add(_db, scr_item_make("item_spellbook", "Spellbook", "weapon", 0, {
        atk_bonus: 0,
        weapon_categories: ["spellbook"],
        sellable: false,
        desc: "Caelan's spellbook. No combat stats yet. (PLACEHOLDER.)"
    }));
    // Sera's holy sword: canon weapon (STORY_BIBLE.md §5.4) with no stats yet (approved 2026-11-16).
    _add(_db, scr_item_make("item_holy_sword", "Holy Sword", "weapon", 0, {
        atk_bonus: 0,
        weapon_categories: ["holy_sword"],
        sellable: false,
        desc: "Sera's Silver Guard blade. No combat stats yet. (PLACEHOLDER.)"
    }));
    // Chapter 3 key items (CHAPTER3_SCRIPT.md §4.1, §5).
    _add(_db, scr_item_make("item_nim_parcel", "Nim's Parcel", "key", 0, {
        sellable: false,
        desc: "A plain parcel, no Crown seal. The stall under the blue awning is expecting it."
    }));
    _add(_db, scr_item_make("item_scholar_notes", "Scholar's Notes", "key", 0, {
        sellable: false,
        desc: "A scholar's hand, hurried. A hollow in the hills a day's walk from the capital. Architect doors. Still standing."
    }));
    _add(_db, scr_item_make("item_hunters_knife", "Hunter's Knife", "weapon", 0, {
        atk_bonus: 2,
        weapon_categories: ["dagger"],
        desc: "A short hunting blade. ATK +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_hunters_charm", "Hunter's Charm", "accessory", 0, {
        def_bonus: 1,
        sellable: false,
        desc: "A worn hunter's charm. DEF +1. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ashen_longbow", "Ashen Longbow", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["bow"],
        desc: "No one in the Chapter 1 roster can equip a bow yet. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ashen_arrow", "Ashen Arrow", "misc", 0, {
        desc: "Ammunition. No use action yet. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_blackguards_longsword", "Blackguard's Longsword", "weapon", 0, {
        atk_bonus: 5,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Taken from the Blackguard. ATK +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_blackguard_longsword", "Blackguard's Longsword", "weapon", 0, {
        atk_bonus: 5,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Taken from the Blackguard. ATK +5. (PLACEHOLDER.)"
    }));

    // Key / story items — cannot be sold or used from the bag (except inspect).
    _add(_db, scr_item_make("item_mira_pendant", "Mira's Wooden Pendant", "key", 0, {
        desc: "Mira's pendant. A story item."
    }));
    _add(_db, scr_item_make("item_watchtower_key", "Watchtower Key", "key", 0, {
        desc: "Opens the rusted arena gate in the Old Watchtower."
    }));
    _add(_db, scr_item_make("item_ashbound_parchment", "Ashbound Parchment", "key", 0, {
        desc: "“Find the girl. The Varyn girl is still alive.”"
    }));
    _add(_db, scr_item_make("item_crownveil_fragment", "Crownveil Fragment", "key", 0, {
        desc: "A fragment of the Crownveil."
    }));
    _add(_db, scr_item_make("item_blackened_feather", "Blackened Feather", "misc", 0, {
        desc: "A charred feather. No use yet. (PLACEHOLDER.)"
    }));
    // Emberwake's feather: the early boss drops it at 35%, the later ordinary Emberwakes at 10%
    // (scr_battle_roll_drops). No use action yet; the price is PLACEHOLDER.
    _add(_db, scr_item_make("item_emberwake_feather", "Emberwake Feather", "misc", 30, {
        desc: "Still warm. A firebird's feather. (No use yet. Price PLACEHOLDER.)"
    }));

    // ---- Eight-act equipment progression --------------------------------------------------
    // Tiers I-VIII. Acts I-II are wired to real content (shops, chests, enemy drops, bosses);
    // Acts III-VIII are data only until those acts' rooms, enemies and merchants exist, which is
    // stated per item in `acquisition` and in docs/EQUIPMENT_PROGRESSION.md. Every number is
    // PLACEHOLDER. Design rules: one weapon tier per act (rotating class), one class-neutral
    // armour/helm/accessory per act, one crafted piece per act, one boss legendary per act.

    // Act I (levels 1-7).
    _add(_db, scr_item_make("item_ash_shard", "Ash Shard", "misc", 12, {
        rarity: "common", act: 1, acquisition: "Dropped by Zone 1 bandits, wolves and wretches; sold by Marda.",
        desc: "A shard of the Ashen Road's glassy crust. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ash_pendant", "Ash Pendant", "accessory", 0, {
        def_bonus: 1, mdef_bonus: 2, rarity: "uncommon", act: 1, sellable: false,
        acquisition: "Hidden grove chest, north-west of the bandit camp (Act I).",
        desc: "A dull pendant on a leather cord. DEF +1, MDEF +2. (PLACEHOLDER.)"
    }));

    // Act II (levels 8-10): Len's stock, Calder's blade, forge crafting.
    _add(_db, scr_item_make("item_millhaven_sabre", "Millhaven Sabre", "weapon", 180, {
        atk_bonus: 5, weapon_categories: ["longsword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II); also crafted at the forge.",
        desc: "A thin Millhaven blade, quick in the hand. ATK +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_wrenfield_coat", "Wrenfield Coat", "armor", 160, {
        def_bonus: 4, spd_bonus: 1, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "Waxed canvas over quilted padding. DEF +4, SPD +1. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_patrol_helm", "Patrol Helm", "helm", 140, {
        def_bonus: 3, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II); Watchtower chests.",
        desc: "A Crown patrol helm, dented and re-strapped. DEF +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_warden_sigil", "Warden's Sigil", "accessory", 200, {
        def_bonus: 1, mdef_bonus: 3, rarity: "rare", act: 2,
        acquisition: "Crafted at the forge from Iron Scales (Act II).",
        desc: "A warden's mark, worn smooth. DEF +1, MDEF +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_iron_scale", "Iron Scale", "misc", 18, {
        rarity: "common", act: 2, acquisition: "Dropped by Crown patrols and occupation soldiers (Act II).",
        desc: "A scale prised from Crown-issue mail. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_calders_greatsword", "Calder's Greatsword", "weapon", 0, {
        atk_bonus: 8, weapon_categories: ["heavy_sword"], rarity: "legendary", act: 2, unique: true, sellable: false,
        acquisition: "Reeve Calder, Wrenfield (guaranteed, once).",
        desc: "The Reeve's heavy blade. ATK +8. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act III (levels 11-14): Valemere.
    _add(_db, scr_item_make("item_ledger_dirk", "Ledger Dirk", "weapon", 520, {
        atk_bonus: 8, spd_bonus: 2, weapon_categories: ["dagger"], rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III); also crafted at the forge.",
        desc: "A narrow capital dirk with a ledger-stamped guard. ATK +8, SPD +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_salt_lampskin", "Salt-Lampskin Coat", "armor", 480, {
        def_bonus: 6, mdef_bonus: 3, classes: ["Arcanist", "Warden"], rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III).",
        desc: "Oilskin lined with salt-lamp wick. Arcanist / Warden only. DEF +6, MDEF +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_valemere_helm", "Valemere Helm", "helm", 440, {
        def_bonus: 5, rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III); crafted at the forge.",
        desc: "A city-watch helm with a brass brow. DEF +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_valemere_steel", "Valemere Steel", "misc", 40, {
        rarity: "common", act: 3, acquisition: "Sold in Valemere; dropped by capital guards (Act III).",
        desc: "A folded bar of capital steel. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_debtmans_chain", "Debtman's Chain", "accessory", 0, {
        def_bonus: 3, mdef_bonus: 3, rarity: "legendary", act: 3, unique: true, sellable: false,
        acquisition: "The Debtman, Valemere (guaranteed, once).",
        desc: "A collector's chain, still cold. DEF +3, MDEF +3. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act IV (levels 15-17): the barrows.
    _add(_db, scr_item_make("item_oath_breaker", "Oathbreaker", "weapon", 900, {
        atk_bonus: 11, weapon_categories: ["heavy_sword"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV); crafted at the forge.",
        desc: "A barrow-iron greatsword, notched on oath-stones. ATK +11. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_barrow_plate", "Barrow Plate", "armor", 880, {
        def_bonus: 9, classes: ["Vanguard", "Rebel Captain"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "Heavy plates from a tomb's guard. Vanguard / Rebel Captain only. DEF +9. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_barrow_helm", "Barrow Helm", "helm", 760, {
        def_bonus: 7, rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV); crafted at the forge.",
        desc: "A dead king's guard helm, visor jammed shut. DEF +7. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_barrow_iron", "Barrow Iron", "misc", 60, {
        rarity: "common", act: 4, acquisition: "Dropped by barrow guardians and wights (Act IV).",
        desc: "Iron from a sealed tomb, still cold. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_sanctuary_oathblade", "Sanctuary Oathblade", "weapon", 0, {
        atk_bonus: 10, weapon_categories: ["holy_sword"], rarity: "legendary", act: 4, unique: true, sellable: false,
        acquisition: "The Sanctuary Warden (guaranteed, once; Chapter 4).",
        desc: "A warden's oath, still keeping its edge. ATK +10. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act V (levels 17-19): Saltreach and the drowned coast.
    _add(_db, scr_item_make("item_tidesteel_blade", "Tidesteel Blade", "weapon", 1400, {
        atk_bonus: 12, weapon_categories: ["longsword"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V); crafted at the forge.",
        desc: "A blade of tidesteel, never quite dry. ATK +12. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_drowned_coat", "Drowned Coat", "armor", 1300, {
        def_bonus: 11, mdef_bonus: 4, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A wreck-diver's coat, tarred and salt-stiff. DEF +11, MDEF +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_saltreach_charm", "Saltreach Charm", "accessory", 1200, {
        def_bonus: 2, mdef_bonus: 5, spd_bonus: 1, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V); crafted at the forge.",
        desc: "A charm of knotted net and glass. DEF +2, MDEF +5, SPD +1. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_tideglass", "Tideglass", "misc", 90, {
        rarity: "common", act: 5, acquisition: "Sold from Mott's cart, Blackwood road (Act V); no drowned things drop it yet.",
        desc: "Sea-glass worn round by the tide. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_drowned_crown", "The Drowned Crown", "helm", 0, {
        def_bonus: 8, mdef_bonus: 6, rarity: "legendary", act: 5, unique: true, sellable: false,
        acquisition: "The Drowned Crown boss, Saltreach deep (guaranteed, once).",
        desc: "A coral-crusted crown, worn as a helm. DEF +8, MDEF +6. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act VI (levels 19-21): the Ironspine and the Architects.
    _add(_db, scr_item_make("item_ironspine_maul", "Ironspine Maul", "weapon", 2000, {
        atk_bonus: 15, weapon_categories: ["heavy_sword"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI); crafted at the forge.",
        desc: "A mine-maul reforged into a sword-length hammer. ATK +15. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_mine_plate", "Mine Plate", "armor", 1900, {
        def_bonus: 13, rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "Boiler plate from a shut-down mine lift. DEF +13. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_architect_ring", "Architect Ring", "accessory", 1700, {
        def_bonus: 2, mdef_bonus: 6, rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI); crafted at the forge.",
        desc: "A ring of machined stone, warm to the touch. DEF +2, MDEF +6. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_architect_alloy", "Architect Alloy", "misc", 120, {
        rarity: "common", act: 6, acquisition: "Dropped by Architect constructs (Act VI).",
        desc: "An alloy no living smith can name. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_first_forge_hammer", "The First Forge", "weapon", 0, {
        atk_bonus: 17, weapon_categories: ["heavy_sword"], rarity: "legendary", act: 6, unique: true, sellable: false,
        acquisition: "The Architect, Ironspine ruins (guaranteed, once).",
        desc: "The hammer that taught the Architects to make. ATK +17. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act VII (levels 21-23): the Ashlands.
    _add(_db, scr_item_make("item_ashlands_edge", "Ashlands Edge", "weapon", 2600, {
        atk_bonus: 16, weapon_categories: ["longsword"], rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII); crafted at the forge.",
        desc: "A sword quenched in ash, edge still warm. ATK +16. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_emberweave_robe", "Emberweave Robe", "armor", 2400, {
        def_bonus: 10, mdef_bonus: 10, classes: ["Arcanist", "Warden"], rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII).",
        desc: "A robe woven from ember-silk. Arcanist / Warden only. DEF +10, MDEF +10. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ash_crown", "Ash Crown", "helm", 2200, {
        def_bonus: 8, mdef_bonus: 5, rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII); crafted at the forge.",
        desc: "A circlet of fused ash and iron. DEF +8, MDEF +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ember_core", "Ember Core", "misc", 160, {
        rarity: "common", act: 7, acquisition: "Dropped by Ashlands fire-things (Act VII).",
        desc: "A coal that will not go out. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_matriarch_heartwood", "Matriarch's Heartwood", "accessory", 0, {
        def_bonus: 5, mdef_bonus: 8, rarity: "legendary", act: 6, unique: true, sellable: false,
        acquisition: "The Blackwood Matriarch (guaranteed, once; Chapter 7).",
        desc: "A knot of living heartwood, still beating. DEF +5, MDEF +8. Cannot be sold. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_barrow_kings_blade", "Barrow King's Blade", "weapon", 0, {
        atk_bonus: 16, weapon_categories: ["holy_sword"], rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The Barrow Warden (guaranteed, once; Chapter 10).",
        desc: "A king's sword, blessed and buried. ATK +16. Cannot be sold. (PLACEHOLDER.)"
    }));

    // Act VIII (levels 23-24).
    _add(_db, scr_item_make("item_true_name_blade", "True-Name Blade", "weapon", 3200, {
        atk_bonus: 19, weapon_categories: ["longsword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII); crafted at the forge.",
        desc: "A blade inscribed with a name that is not yours. ATK +19. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_rime_sword", "Rime Sword", "weapon", 3000, {
        atk_bonus: 16, weapon_categories: ["holy_sword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A Silver Guard blade, rimed and blessed. ATK +16. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_veil_plate", "Veil Plate", "armor", 3100, {
        def_bonus: 16, rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "Plate worked with veil-iron. DEF +16. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_veil_ring", "Veil Ring", "accessory", 2900, {
        def_bonus: 5, mdef_bonus: 9, spd_bonus: 2, rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII); crafted at the forge.",
        desc: "A ring that keeps the cold off the hand. DEF +5, MDEF +9, SPD +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_veil_shard", "Veil Shard", "misc", 220, {
        rarity: "common", act: 8, acquisition: "Dropped by veil-touched enemies (Act VIII).",
        desc: "A sliver of the veil, cold enough to burn. Forge material. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_forgotten_kings_crown", "The Forgotten King's Crown", "helm", 0, {
        def_bonus: 10, mdef_bonus: 9, rarity: "legendary", act: 8, unique: true, sellable: false,
        acquisition: "The Forgotten King, the barrow halls (guaranteed, once; Chapter 11).",
        desc: "The crown the histories forgot. DEF +10, MDEF +9. Cannot be sold. (PLACEHOLDER.)"
    }));

    // ---- Weapon coverage: one weapon per class per act --------------------------------------
    // A weapon tier for all five classes in every act (Acts III-VIII are still data-only).
    // Longsword = baseline ATK; heavy sword +1 ATK; holy sword +MDEF; dagger -ATK +SPD;
    // spellbook -ATK +MDEF. This keeps the party's damage-per-round close to one weapon's worth
    // per member instead of stacking the highest tier onto only one or two characters.

    // Act I (Kael's Iron Sword and Lyra's Hunter's Knife already existed).
    _add(_db, scr_item_make("item_apprentices_codex", "Apprentice's Codex", "weapon", 90, {
        atk_bonus: 2, mdef_bonus: 2, weapon_categories: ["spellbook"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A copybook of half-learned forms. ATK +2, MDEF +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_chapel_blade", "Chapel Blade", "weapon", 95, {
        atk_bonus: 3, mdef_bonus: 1, weapon_categories: ["holy_sword"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A chapel-issue sword, blessed once and rarely since. ATK +3, MDEF +1. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_yoke_cleaver", "Yoke Cleaver", "weapon", 100, {
        atk_bonus: 4, weapon_categories: ["heavy_sword"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A Rebel smith's cleaver ground down into a sword. ATK +4. (PLACEHOLDER.)"
    }));

    // Act II (Kael's Millhaven Sabre already existed).
    _add(_db, scr_item_make("item_millhaven_stiletto", "Millhaven Stiletto", "weapon", 170, {
        atk_bonus: 4, spd_bonus: 2, weapon_categories: ["dagger"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A narrow boot knife from the mill district. ATK +4, SPD +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_millhaven_primer", "Millhaven Primer", "weapon", 175, {
        atk_bonus: 4, mdef_bonus: 3, weapon_categories: ["spellbook"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A primer of wards copied by a Crown scribe. ATK +4, MDEF +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_penitent_blade", "Penitent Blade", "weapon", 180, {
        atk_bonus: 5, mdef_bonus: 2, weapon_categories: ["holy_sword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Silver Guard blade, surrendered and bought back. ATK +5, MDEF +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_patrol_greatsword", "Patrol Greatsword", "weapon", 190, {
        atk_bonus: 6, weapon_categories: ["heavy_sword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Crown patrolman's two-hander, still tagged. ATK +6. (PLACEHOLDER.)"
    }));

    // Act III (Lyra's Ledger Dirk already existed).
    _add(_db, scr_item_make("item_valemere_longsword", "Valemere Longsword", "weapon", 500, {
        atk_bonus: 7, weapon_categories: ["longsword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A city-watch blade with a brass fuller. ATK +7. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ledger_codex", "Ledger Codex", "weapon", 500, {
        atk_bonus: 6, mdef_bonus: 4, weapon_categories: ["spellbook"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A magistrate's codex, margins full of debts. ATK +6, MDEF +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_saltlight_blade", "Saltlight Blade", "weapon", 510, {
        atk_bonus: 7, mdef_bonus: 3, weapon_categories: ["holy_sword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A sword that holds salt-lamp light in the fuller. ATK +7, MDEF +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_watchmans_greatsword", "Watchman's Greatsword", "weapon", 540, {
        atk_bonus: 9, weapon_categories: ["heavy_sword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "The watch's gate sword, chained to the post it was taken from. ATK +9. (PLACEHOLDER.)"
    }));

    // Act IV (Sera's Sanctuary Oathblade and Taren's Oathbreaker already existed).
    _add(_db, scr_item_make("item_barrow_longsword", "Barrow Longsword", "weapon", 900, {
        atk_bonus: 10, weapon_categories: ["longsword"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "Tomb-iron, straight and cold in the hand. ATK +10. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_tomb_shard_dirk", "Tomb Shard Dirk", "weapon", 880, {
        atk_bonus: 8, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A dirk ground from a broken grave-marker. ATK +8, SPD +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_barrow_codex", "Barrow Codex", "weapon", 900, {
        atk_bonus: 8, mdef_bonus: 5, weapon_categories: ["spellbook"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A burial codex, still sealed against the dark. ATK +8, MDEF +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_vigil_blade", "Vigil Blade", "weapon", 920, {
        atk_bonus: 9, mdef_bonus: 4, weapon_categories: ["holy_sword"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A blade kept lit at a tomb that had no visitors. ATK +9, MDEF +4. (PLACEHOLDER.)"
    }));

    // Act V (Kael's Tidesteel Blade already existed).
    _add(_db, scr_item_make("item_tideglass_dirk", "Tideglass Dirk", "weapon", 1350, {
        atk_bonus: 11, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A dirk with a tideglass edge, always wet. ATK +11, SPD +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_tidebound_codex", "Tidebound Codex", "weapon", 1380, {
        atk_bonus: 11, mdef_bonus: 6, weapon_categories: ["spellbook"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "Pages of oilskin, bound in net. ATK +11, MDEF +6. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_drowned_bell_blade", "Drowned Bell Blade", "weapon", 1400, {
        atk_bonus: 12, mdef_bonus: 5, weapon_categories: ["holy_sword"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A sword forged from a drowned bell's tongue. ATK +12, MDEF +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_saltreach_maul", "Saltreach Maul", "weapon", 1450, {
        atk_bonus: 13, weapon_categories: ["heavy_sword"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A wrecking maul with a sword's grip. ATK +13. (PLACEHOLDER.)"
    }));

    // Act VI (Taren's Ironspine Maul already existed).
    _add(_db, scr_item_make("item_ironspine_longsword", "Ironspine Longsword", "weapon", 1950, {
        atk_bonus: 14, weapon_categories: ["longsword"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A mine overseer's blade, eaten by rust at the ricasso. ATK +14. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_mine_shard_dirk", "Mine Shard Dirk", "weapon", 1900, {
        atk_bonus: 12, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A dirk cut from a machine's cutting tooth. ATK +12, SPD +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_architect_codex", "Architect Codex", "weapon", 1950, {
        atk_bonus: 12, mdef_bonus: 7, weapon_categories: ["spellbook"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A codex of machined plates, half of it still legible. ATK +12, MDEF +7. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_constructs_bane", "Construct's Bane", "weapon", 1980, {
        atk_bonus: 13, mdef_bonus: 5, weapon_categories: ["holy_sword"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A blade etched against made things. ATK +13, MDEF +5. (PLACEHOLDER.)"
    }));

    // Act VII (Kael's Ashlands Edge and Sera's Barrow King's Blade already existed).
    _add(_db, scr_item_make("item_ashglass_dirk", "Ashglass Dirk", "weapon", 2550, {
        atk_bonus: 14, spd_bonus: 4, weapon_categories: ["dagger"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A dirk of fused ash, light and mean. ATK +14, SPD +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ember_codex", "Ember Codex", "weapon", 2550, {
        atk_bonus: 14, mdef_bonus: 8, weapon_categories: ["spellbook"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A codex whose pages will not burn. ATK +14, MDEF +8. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_cinder_vigil", "Cinder Vigil", "weapon", 2580, {
        atk_bonus: 15, mdef_bonus: 6, weapon_categories: ["holy_sword"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A vigil blade kept burning through the ashfall. ATK +15, MDEF +6. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ashfall_greatsword", "Ashfall Greatsword", "weapon", 2620, {
        atk_bonus: 17, weapon_categories: ["heavy_sword"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A greatsword crusted with cooled ash. ATK +17. (PLACEHOLDER.)"
    }));

    // Act VIII (Kael's True-Name Blade and Sera's Rime Sword already existed).
    _add(_db, scr_item_make("item_veilstep_dirk", "Veilstep Dirk", "weapon", 3150, {
        atk_bonus: 16, spd_bonus: 4, weapon_categories: ["dagger"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A dirk that leaves no print in the frost. ATK +16, SPD +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_rime_codex", "Rime Codex", "weapon", 3180, {
        atk_bonus: 16, mdef_bonus: 9, weapon_categories: ["spellbook"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A codex rimed shut, opening only for its reader. ATK +16, MDEF +9. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_winterforge_greatsword", "Winterforge Greatsword", "weapon", 3250, {
        atk_bonus: 20, weapon_categories: ["heavy_sword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A greatsword quenched in a Frostwilds spring. ATK +20. (PLACEHOLDER.)"
    }));

    // Existing gear gets the same metadata so every item is queryable by act/rarity/source.
    var _meta = {
        item_minor_potion:          { rarity: "common",   act: 1, acquisition: "Marda, Greyhaven store; most chests." },
        item_antidote:              { rarity: "common",   act: 1, acquisition: "Marda, Greyhaven store; most chests." },
        item_ether:                 { rarity: "uncommon", act: 2, acquisition: "Len, Wrenfield; Marda from Act II." },
        item_iron_sword:            { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I)." },
        item_leather_armor:         { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I)." },
        item_iron_helm:             { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I); Watchtower chests." },
        item_chain_mail:            { rarity: "uncommon", act: 2, acquisition: "Len's shop, Wrenfield (Act II)." },
        item_hunters_knife:         { rarity: "common",   act: 1, acquisition: "Watchtower chest (Act I)." },
        item_hunters_charm:         { rarity: "common",   act: 1, acquisition: "Hunter's cache (Act I)." },
        item_ashen_longbow:         { rarity: "uncommon", act: 1, acquisition: "Bandit camp cache (Act I). No class can use a bow yet." },
        item_blackguards_longsword: { rarity: "legendary", act: 1, unique: true, sellable: false, acquisition: "The Blackguard, Old Watchtower (guaranteed, once)." },
        item_blackguard_longsword:  { rarity: "legendary", act: 1, unique: true, sellable: false, acquisition: "Legacy id for the Blackguard's Longsword; kept for old saves." },
        item_travel_brigandine:     { rarity: "common",   act: 0, acquisition: "Taren's starting armour (Chapter 2)." },
        item_kaels_longsword:       { rarity: "common",   act: 0, acquisition: "Kael's starting weapon." },
        item_bastard_sword:         { rarity: "common",   act: 0, acquisition: "Taren's starting weapon." },
        item_twin_daggers:          { rarity: "common",   act: 0, acquisition: "Lyra's starting weapon." },
        item_spellbook:             { rarity: "common",   act: 0, acquisition: "Caelan's starting weapon." },
        item_holy_sword:            { rarity: "common",   act: 0, acquisition: "Sera's starting weapon." }
    };
    var _mnames = variable_struct_get_names(_meta);
    for (var _mi = 0; _mi < array_length(_mnames); _mi++) {
        var _mid = _mnames[_mi];
        if (!variable_struct_exists(_db, _mid)) continue;
        var _row = _meta[$ _mid];
        var _entry = _db[$ _mid];
        var _keys = variable_struct_get_names(_row);
        for (var _ki = 0; _ki < array_length(_keys); _ki++) _entry[$ _keys[_ki]] = _row[$ _keys[_ki]];
    }

    global.item_db = _db;
    return global.item_db;
}

function scr_item_get(_item_id) {
    var _id = scr_item_id_norm(_item_id);
    var _db = scr_item_database();
    if (_id != "" && variable_struct_exists(_db, _id)) return _db[$ _id];
    // Unknown id: a safe placeholder so menus never crash.
    return scr_item_make(_id == "" ? "item_unknown" : _id, scr_item_display_name(_item_id), "misc", 0, {
        desc: "Unknown item.",
        sellable: false
    });
}

function scr_item_is_key(_item_id) {
    var _it = scr_item_get(_item_id);
    return _it.key_item;
}

function scr_item_is_equipment(_item_id) {
    var _it = scr_item_get(_item_id);
    return _it.slot == "weapon" || _it.slot == "armor" || _it.slot == "helm" || _it.slot == "accessory";
}

function scr_item_is_consumable(_item_id) {
    return scr_item_get(_item_id).kind == "consumable";
}

function scr_item_buy_price(_item_id) {
    return scr_item_get(_item_id).price;
}

function scr_item_sell_price(_item_id) {
    var _it = scr_item_get(_item_id);
    if (!_it.sellable || _it.key_item || _it.price <= 0) return 0;
    return max(1, floor(_it.price * SHOP_SELL_RATE));
}

/// True when `_actor` can wear this item (joined or not — caller filters the list).
/// Class restrictions (`classes`) gate every slot; weapons also need a matching category.
function scr_item_can_equip(_actor, _item_id) {
    if (!is_struct(_actor)) return false;
    var _it = scr_item_get(_item_id);
    if (_it.slot == "") return false;
    var _classes = _it.classes;
    if (is_array(_classes) && array_length(_classes) > 0) {
        var _cn = variable_struct_exists(_actor, "class_name") ? string(_actor.class_name) : "";
        var _class_ok = false;
        for (var _ci = 0; _ci < array_length(_classes); _ci++) {
            if (string_lower(string(_classes[_ci])) == string_lower(_cn)) { _class_ok = true; break; }
        }
        if (!_class_ok) return false;
    }
    if (_it.slot != "weapon") return true;
    var _need = _it.weapon_categories;
    var _have = variable_struct_exists(_actor, "weapon_categories") ? _actor.weapon_categories : [];
    if (!is_array(_need) || array_length(_need) == 0) return true;
    if (!is_array(_have)) return false;
    for (var _i = 0; _i < array_length(_need); _i++) {
        for (var _j = 0; _j < array_length(_have); _j++) {
            if (_have[_j] == _need[_i]) return true;
        }
    }
    return false;
}

function scr_actor_ensure_bases(_actor) {
    if (!is_struct(_actor)) return;
    if (!variable_struct_exists(_actor, "base_attack")) _actor.base_attack = _actor.attack;
    if (!variable_struct_exists(_actor, "base_defense")) _actor.base_defense = _actor.defense;
    if (!variable_struct_exists(_actor, "base_spd")) _actor.base_spd = variable_struct_exists(_actor, "spd") ? _actor.spd : 8;
    if (!variable_struct_exists(_actor, "base_mdef")) _actor.base_mdef = variable_struct_exists(_actor, "mdef") ? _actor.mdef : 0;
    if (!variable_struct_exists(_actor, "poisoned")) _actor.poisoned = false;
    if (!variable_struct_exists(_actor, "equipment") || !is_struct(_actor.equipment)) {
        _actor.equipment = { weapon: "", armor: "", helm: "", accessory: "" };
    }
    if (!variable_struct_exists(_actor.equipment, "helm")) _actor.equipment.helm = "";
    // Iron Helm used to live in the accessory slot; move it if needed.
    var _acc = is_string(_actor.equipment.accessory) ? _actor.equipment.accessory : "";
    if (scr_item_id_norm(_acc) == "item_iron_helm" && _actor.equipment.helm == "") {
        _actor.equipment.helm = _acc;
        _actor.equipment.accessory = "";
    }
}

function scr_item_equip_bonuses(_item_id) {
    if (_item_id == "" || _item_id == undefined) return { atk: 0, def: 0, mdef: 0, spd: 0 };
    var _it = scr_item_get(_item_id);
    return { atk: _it.atk_bonus, def: _it.def_bonus, mdef: _it.mdef_bonus, spd: _it.spd_bonus };
}

/// Recompute attack / defense / MDEF / SPD from base stats plus equipped bonuses.
/// Bases are the un-equipped values, so a second call never stacks the same bonus twice.
function scr_actor_refresh_equipment(_actor) {
    if (!is_struct(_actor)) return;
    scr_actor_ensure_bases(_actor);
    var _atk = 0;
    var _def = 0;
    var _mdef = 0;
    var _spd = 0;
    var _slots = ["weapon", "armor", "helm", "accessory"];
    for (var _i = 0; _i < 4; _i++) {
        var _id = _actor.equipment[$ _slots[_i]];
        if (is_string(_id) && _id != "") {
            var _b = scr_item_equip_bonuses(_id);
            _atk += _b.atk;
            _def += _b.def;
            _mdef += _b.mdef;
            _spd += _b.spd;
        }
    }
    _actor.attack = _actor.base_attack + _atk;
    _actor.defense = _actor.base_defense + _def;
    _actor.mdef = _actor.base_mdef + _mdef;
    _actor.spd = _actor.base_spd + _spd;
}

function scr_party_refresh_equipment() {
    scr_game_state_init();
    var _list = global.game.roster;
    if (!is_array(_list)) return;
    for (var _i = 0; _i < array_length(_list); _i++) {
        scr_actor_refresh_equipment(_list[_i]);
    }
}

function scr_actor_equipped_in_slot(_actor, _slot) {
    if (!is_struct(_actor) || !is_struct(_actor.equipment)) return "";
    var _id = _actor.equipment[$ _slot];
    return is_string(_id) ? _id : "";
}

/// Equip from inventory onto a joined member. Returns a short status string.
function scr_item_equip_to(_actor, _item_id) {
    if (!is_struct(_actor) || !scr_item_can_equip(_actor, _item_id)) return "Can't equip.";
    var _it = scr_item_get(_item_id);
    var _slot = _it.slot;
    if (_slot == "") return "Can't equip.";
    if (!scr_inventory_has(_item_id)) return "You don't have that.";
    var _prev = scr_actor_equipped_in_slot(_actor, _slot);
    if (!scr_inventory_remove(_item_id, 1, true)) return "You don't have that.";
    _actor.equipment[$ _slot] = _it.item_id;
    if (_prev != "") {
        var _prev_it = scr_item_get(_prev);
        scr_inventory_add(_prev_it.item_id, _prev_it.name, 1, _prev_it.key_item);
    }
    scr_actor_refresh_equipment(_actor);
    return "Equipped " + _it.name + " on " + _actor.name + ".";
}

function scr_item_preview_line(_actor, _item_id) {
    if (!is_struct(_actor)) return "";
    var _it = scr_item_get(_item_id);
    if (_it.slot == "") return _actor.name;
    if (!scr_item_can_equip(_actor, _item_id)) return _actor.name + "  can't equip";
    var _b = scr_item_equip_bonuses(_item_id);
    var _atk0 = variable_struct_exists(_actor, "base_attack") ? _actor.base_attack : _actor.attack;
    var _def0 = variable_struct_exists(_actor, "base_defense") ? _actor.base_defense : _actor.defense;
    var _mdef0 = variable_struct_exists(_actor, "base_mdef") ? _actor.base_mdef : _actor.mdef;
    var _spd0 = variable_struct_exists(_actor, "base_spd") ? _actor.base_spd : _actor.spd;
    // Other slots stay worn; only this slot is replaced in the preview.
    var _slots = ["weapon", "armor", "helm", "accessory"];
    var _atk_other = 0;
    var _def_other = 0;
    var _mdef_other = 0;
    var _spd_other = 0;
    for (var _i = 0; _i < 4; _i++) {
        if (_slots[_i] == _it.slot) continue;
        var _ob = scr_item_equip_bonuses(scr_actor_equipped_in_slot(_actor, _slots[_i]));
        _atk_other += _ob.atk;
        _def_other += _ob.def;
        _mdef_other += _ob.mdef;
        _spd_other += _ob.spd;
    }
    var _now = { atk: _actor.attack, def: _actor.defense, mdef: _actor.mdef, spd: _actor.spd };
    var _new = {
        atk: _atk0 + _atk_other + _b.atk,
        def: _def0 + _def_other + _b.def,
        mdef: _mdef0 + _mdef_other + _b.mdef,
        spd: _spd0 + _spd_other + _b.spd
    };
    var _line = _actor.name;
    var _labels = [["atk", "ATK"], ["def", "DEF"], ["mdef", "MDEF"], ["spd", "SPD"]];
    var _changed = false;
    for (var _k = 0; _k < 4; _k++) {
        var _key = _labels[_k][0];
        if (_new[$ _key] == _now[$ _key]) continue;
        _line += "  " + _labels[_k][1] + " " + string(_now[$ _key]) + " > " + string(_new[$ _key]);
        _changed = true;
    }
    if (!_changed) _line += "  no change";
    if (_it.rarity != "common") _line += "  [" + string_upper(_it.rarity) + "]";
    return _line;
}

/// Use a consumable on one actor. Returns a status string; does not remove the item on failure.
function scr_item_use_on(_actor, _item_id) {
    if (!is_struct(_actor)) return "No target.";
    var _it = scr_item_get(_item_id);
    if (_it.kind != "consumable") return "Can't use that here.";
    if (_it.heal > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't be revived with this.";
        if (_actor.hp >= _actor.max_hp) return _actor.name + "'s HP is already full.";
        var _gain = min(_it.heal, _actor.max_hp - _actor.hp);
        _actor.hp += _gain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_gain) + " HP.";
    }
    if (_it.mp_restore > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't use this while down.";
        var _mmp = variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0;
        if (_mmp <= 0) return _actor.name + " has no MP.";
        if (_actor.mp >= _mmp) return _actor.name + "'s MP is already full.";
        var _mgain = min(_it.mp_restore, _mmp - _actor.mp);
        _actor.mp += _mgain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_mgain) + " MP.";
    }
    if (_it.cures_poison) {
        // Cures the overworld `poisoned` flag and the battle "poison" status.
        var _poisoned = variable_struct_exists(_actor, "poisoned") && _actor.poisoned;
        var _bpoison = scr_battle_status_has(_actor, "poison");
        if (!_poisoned && !_bpoison) return _actor.name + " is not poisoned.";
        if (_poisoned) _actor.poisoned = false;
        if (_bpoison) scr_battle_remove_status(_actor, "poison");
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " is no longer poisoned.";
    }
    return "No effect.";
}

/// Reverse lookup by display name (chest loot is written as "Iron Sword", not an id).
function scr_item_id_for_name(_name) {
    var _want = string_lower(string_trim(string(_name)));
    if (_want == "") return "";
    var _db = scr_item_database();
    var _ids = variable_struct_get_names(_db);
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (string_lower(_db[$ _ids[_i]].name) == _want) return _ids[_i];
    }
    return "";
}

// ---- Forge crafting ------------------------------------------------------------------------
// Tiered materials -> the act's crafted piece. Legendaries are never craftable: they come from
// bosses only (see `unique` / `acquisition`). Recipes unlock with the story act.
function scr_craft_recipes() {
    return [
        { result: "item_millhaven_sabre", act: 2, gold: 100, materials: [{ item: "item_ash_shard", qty: 2 }, { item: "item_iron_scale", qty: 2 }] },
        { result: "item_warden_sigil", act: 2, gold: 120, materials: [{ item: "item_iron_scale", qty: 3 }] },
        { result: "item_valemere_helm", act: 3, gold: 200, materials: [{ item: "item_valemere_steel", qty: 4 }] },
        { result: "item_ledger_dirk", act: 3, gold: 350, materials: [{ item: "item_valemere_steel", qty: 4 }, { item: "item_iron_scale", qty: 4 }] },
        { result: "item_barrow_helm", act: 4, gold: 300, materials: [{ item: "item_barrow_iron", qty: 5 }] },
        { result: "item_oath_breaker", act: 4, gold: 450, materials: [{ item: "item_barrow_iron", qty: 6 }, { item: "item_valemere_steel", qty: 4 }] },
        { result: "item_saltreach_charm", act: 5, gold: 400, materials: [{ item: "item_tideglass", qty: 6 }] },
        { result: "item_tidesteel_blade", act: 5, gold: 600, materials: [{ item: "item_tideglass", qty: 8 }, { item: "item_barrow_iron", qty: 5 }] },
        { result: "item_architect_ring", act: 6, gold: 500, materials: [{ item: "item_architect_alloy", qty: 7 }] },
        { result: "item_ironspine_maul", act: 6, gold: 700, materials: [{ item: "item_architect_alloy", qty: 9 }, { item: "item_tideglass", qty: 6 }] },
        { result: "item_ash_crown", act: 7, gold: 600, materials: [{ item: "item_ember_core", qty: 8 }] },
        { result: "item_ashlands_edge", act: 7, gold: 800, materials: [{ item: "item_ember_core", qty: 10 }, { item: "item_architect_alloy", qty: 6 }] },
        { result: "item_veil_ring", act: 8, gold: 700, materials: [{ item: "item_veil_shard", qty: 9 }] },
        { result: "item_true_name_blade", act: 8, gold: 900, materials: [{ item: "item_veil_shard", qty: 11 }, { item: "item_ember_core", qty: 6 }] }
    ];
}

function scr_craft_recipe_get(_result_id) {
    var _all = scr_craft_recipes();
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].result == scr_item_id_norm(_result_id)) return _all[_i];
    }
    return undefined;
}

/// Recipes unlocked at the current story act.
function scr_craft_available() {
    var _out = [];
    var _all = scr_craft_recipes();
    var _act = scr_story_act();
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].act <= _act) array_push(_out, _all[_i]);
    }
    return _out;
}

/// Empty string when the recipe can be made now, otherwise a short reason.
function scr_craft_block_reason(_recipe) {
    scr_game_state_init();
    if (!is_struct(_recipe)) return "Unknown recipe.";
    if (_recipe.act > scr_story_act()) return "You don't have the recipe yet.";
    var _mats = _recipe.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        var _have = scr_inventory_count(_mats[_i].item);
        if (_have < _mats[_i].qty) {
            return "Needs " + string(_mats[_i].qty) + " " + scr_item_get(_mats[_i].item).name + " (have " + string(_have) + ").";
        }
    }
    if (global.game.gold < _recipe.gold) return "Needs " + string(_recipe.gold) + " gold.";
    return "";
}

function scr_craft_make(_result_id) {
    scr_game_state_init();
    var _rec = scr_craft_recipe_get(_result_id);
    if (!is_struct(_rec)) return "Unknown recipe.";
    var _block = scr_craft_block_reason(_rec);
    if (_block != "") { scr_audio_sfx("menu_error", 0, 0.8); return _block; }
    var _mats = _rec.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        if (!scr_inventory_remove(_mats[_i].item, _mats[_i].qty, true)) return "Missing materials.";
    }
    global.game.gold -= _rec.gold;
    var _it = scr_item_get(_rec.result);
    scr_inventory_add(_it.item_id, _it.name, 1, _it.key_item);
    scr_audio_sfx("item_get", 0.02);
    return "Forged " + _it.name + ".";
}

/// One-line label for the forge menu, with its requirements.
function scr_craft_label(_recipe) {
    var _it = scr_item_get(_recipe.result);
    var _s = _it.name + "  (" + string(_recipe.gold) + "g";
    var _mats = _recipe.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        _s += ", " + string(_mats[_i].qty) + " " + scr_item_get(_mats[_i].item).name;
    }
    return _s + ")";
}

function scr_party_members_for_item(_item_id) {
    scr_game_state_init();
    var _out = [];
    var _lists = [global.game.party, global.game.reserve];
    var _equip = scr_item_is_equipment(_item_id);
    for (var _l = 0; _l < 2; _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _a = _list[_i];
            if (!is_struct(_a)) continue;
            if (_equip && !scr_item_can_equip(_a, _item_id)) continue;
            array_push(_out, _a);
        }
    }
    return _out;
}

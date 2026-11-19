/// scr_shop_data — data-driven shop tables.
/// Marda sells Minor Potion and Antidote (CHAPTER1_SCRIPT.md §1.4, confirmed).
/// Pell sells basic Chapter 1 weapons and armor from the item art / placeholder item DB
/// (Iron Sword, Leather Armor, Iron Helm). Official stock and prices are still open.

/// The equipment tier the party has reached (1-8), from chapter completion.
/// Story acts are coarser than tiers: Act II spans Chapters 2-5, so `flag_act2_complete`
/// only fires after Chapter 5 and must not gate the Chapter 3 Valemere stock. Each chapter
/// maps to the tier its level band belongs to; Chapter 1 stays at tier 1.
function scr_story_act() {
    if (scr_flag_get("flag_act4_complete") || scr_flag_get("chapter11_complete")) return 8;
    if (scr_flag_get("flag_act3_complete") || scr_flag_get("chapter8_complete")) return 7;
    if (scr_flag_get("flag_chapter5_complete")) return 6;
    if (scr_flag_get("flag_chapter4_complete")) return 5;
    if (scr_flag_get("flag_chapter3_complete")) return 4;
    if (scr_flag_get("flag_chapter2_complete")) return 3;
    if (scr_flag_get("flag_act2_started")) return 2;
    return 1;
}

/// A shop's stock at the current act: its base list plus every `stock_by_act` row that has
/// unlocked, de-duplicated and in order. Merchants therefore sell the act's tier, not endgame gear.
function scr_shop_stock(_shop) {
    var _out = [];
    var _seen = {};
    if (!is_struct(_shop)) return _out;
    if (is_array(_shop.items)) {
        for (var _i = 0; _i < array_length(_shop.items); _i++) {
            var _id = _shop.items[_i];
            if (variable_struct_exists(_seen, _id)) continue;
            _seen[$ _id] = true;
            array_push(_out, _id);
        }
    }
    var _act = scr_story_act();
    if (variable_struct_exists(_shop, "stock_by_act") && is_array(_shop.stock_by_act)) {
        for (var _r = 0; _r < array_length(_shop.stock_by_act); _r++) {
            var _row = _shop.stock_by_act[_r];
            if (!is_struct(_row) || _row.act > _act || !is_array(_row.items)) continue;
            for (var _j = 0; _j < array_length(_row.items); _j++) {
                var _rid = _row.items[_j];
                if (variable_struct_exists(_seen, _rid)) continue;
                _seen[$ _rid] = true;
                array_push(_out, _rid);
            }
        }
    }
    return _out;
}

function scr_shop_get(_shop_id) {
    switch (_shop_id) {
        case "shop_greyhaven_store":
            return {
                shop_id: "shop_greyhaven_store",
                name: "General Store",
                keeper: "Marda",
                wired: true,
                items: ["item_minor_potion", "item_antidote", "item_travel_leggings", "item_commoners_draught", "item_aether_vial", "item_venomroot_extract", "item_boar_hide"],
                // Act I material; Act II's Ether joins the shelves later.
                stock_by_act: [
                    { act: 1, items: ["item_ash_shard"] },
                    { act: 2, items: ["item_ether"] }
                ],
                lines_buy: ["Coin's still coin, Kael.", "Even now."],
                lines_sell: ["Everything went up.", "Including the roof."]
            };
        case "shop_greyhaven_forge":
            return {
                shop_id: "shop_greyhaven_forge",
                name: "Tomas's Forge",
                keeper: "Pell",
                wired: true,
                // PLACEHOLDER stock: Chapter 1 equipment that has art and is not a unique reward.
                items: ["item_iron_sword", "item_leather_armor", "item_iron_helm", "item_beggars_edge", "item_hidebound_vest", "item_soldiers_bulwark", "item_wanderers_cowl", "item_initiates_branch", "item_wanderers_pike", "item_wayfarers_breeches"],
                // The other classes' Act I weapon tier is on the same shelf.
                stock_by_act: [{ act: 1, items: ["item_apprentices_codex", "item_chapel_blade", "item_yoke_cleaver"] }],
                lines_buy: ["His tools are mostly fine.", "Iron's tougher than people."],
                lines_sell: ["His tools are mostly fine.", "Iron's tougher than people."]
            };
        case "shop_wrenfield_store":
            // Len, Wrenfield (CHAPTER2_SCRIPT.md: "Minor Potion, Antidote, and any mid-tier items
            // Design wants for level 8–10"). Ether and Chain Mail are PLACEHOLDER picks / prices.
            // Opened by the Chapter 2 room wiring (only after the rescue; WF_STORE_SHUT before).
            return {
                shop_id: "shop_wrenfield_store",
                name: "Len's Goods",
                keeper: "Len",
                wired: true,
                items: ["item_minor_potion", "item_antidote", "item_ether", "item_chain_mail"],
                // Chapter 2's own tier, unlocked once Act II starts.
                stock_by_act: [
                    { act: 2, items: ["item_millhaven_sabre", "item_millhaven_stiletto", "item_millhaven_primer", "item_penitent_blade", "item_patrol_greatsword", "item_soldiers_oath", "item_yoke_shield", "item_wrenfield_coat", "item_patrol_helm", "item_iron_scale", "item_ironweave", "item_ironwall", "item_ironbound_greaves", "item_hunters_cover", "item_bloodcleaver", "item_ironfall", "item_steel_ingot"] }
                ],
                lines_buy: ["Shelves are the same.", "Prices are the same."],
                lines_sell: ["Shelves are the same.", "Prices are the same."]
            };
        // ---- Act III-VIII merchants -------------------------------------------------------
        // Stocked by tier so the shelf always matches the act. Valemere, the barrow gate, the
        // Blackwood carter, the Ashlands outpost wagon and the Rimehold armoury are wired (see
        // scr_ch3_story / scr_ch6_story / scr_ch10_story / scr_dialogue_data); Saltreach and
        // Ironspine are data until their regions are built, and their stock rides on Mott's cart.
        case "shop_valemere_arms":
            return {
                shop_id: "shop_valemere_arms", name: "Valemere Arms", keeper: "Stallkeeper", act: 3, wired: true,
                items: ["item_minor_potion", "item_antidote", "item_ether", "item_valemere_steel"],
                stock_by_act: [
                    { act: 3, items: ["item_ledger_dirk", "item_valemere_longsword", "item_ledger_codex", "item_saltlight_blade", "item_watchmans_greatsword", "item_wardens_steel", "item_salt_lampskin", "item_valemere_helm", "item_valemere_greaves", "item_wardens_plate", "item_crownwatch_helm", "item_oathbound_aegis", "item_silent_thorn", "item_stonebreaker", "item_wardens_greaves"] },
                    // Act IV relic tier: the capital dealer handles Aethari finds.
                    { act: 4, items: ["item_heart_of_aether", "item_aetherbound_circlet", "item_elderwood_staff", "item_veilstalkers_hood", "item_dawnveil_robes", "item_aethari_vestments", "item_silver_ore", "item_pure_crystal", "item_ancient_cloth", "item_enchanted_wood"] }
                ],
                lines_buy: ["Capital steel, capital prices."], lines_sell: ["I buy what the Ledger doesn't."]
            };
        case "shop_barrow_smith":
            return {
                // Story Act IV (Chapters 9-11) is levels 21-23, so the smith also carries the late
                // tier as base stock; the Act IV row below is legacy shelf space from the first pass.
                shop_id: "shop_barrow_smith", name: "Barrow Gate Smith", keeper: "Orrin", act: 4, wired: true,
                items: ["item_minor_potion", "item_ether", "item_barrow_iron", "item_ashlands_edge", "item_emberweave_robe", "item_ash_crown"],
                stock_by_act: [{ act: 4, items: ["item_oath_breaker", "item_barrow_longsword", "item_tomb_shard_dirk", "item_barrow_codex", "item_vigil_blade", "item_barrow_plate", "item_barrow_helm", "item_barrow_shield"] }],
                lines_buy: ["Tomb iron's cold work."], lines_sell: ["Tomb iron's cold work."]
            };
        case "shop_blackwood_carter":
            return {
                // Mott, the carter stranded on the Blackwood road (Chapter 6). Saltreach and Ironspine
                // have no room of their own yet, so the coast and mine tiers ride on his cart: he is the
                // only wired source for either. Stock still unlocks by act — the mine crates under the
                // tarp open with the Act VI row, after Chapter 5 closes (scr_story_act).
                shop_id: "shop_blackwood_carter", name: "Mott's Cart", keeper: "Mott", act: 6, wired: true,
                items: ["item_minor_potion", "item_antidote", "item_ether"],
                stock_by_act: [
                    { act: 5, items: ["item_tideglass", "item_tidesteel_blade", "item_tideglass_dirk", "item_tidebound_codex", "item_drowned_bell_blade", "item_saltreach_maul", "item_drowned_coat", "item_saltreach_charm", "item_tidesteel_greaves", "item_oathkeeper", "item_crownward_armor", "item_crownward_sabatons", "item_gravekeeper", "item_gravewarden_armor", "item_gold_ore", "item_black_iron", "item_ancient_rune"] },
                    { act: 6, items: ["item_architect_alloy", "item_ironspine_maul", "item_ironspine_longsword", "item_mine_shard_dirk", "item_architect_codex", "item_constructs_bane", "item_mine_plate", "item_architect_ring", "item_ashen_ward", "item_veilward_charm", "item_ashbound_treads", "item_veilforged_plate", "item_ashen_sigil", "item_ash_crystal", "item_shadow_essence"] }
                ],
                lines_buy: ["Coast glass and mine steel. It all came up the road with me."], lines_sell: ["I'll take what the road left you."]
            };
        case "shop_saltreach_armoury":
            return {
                shop_id: "shop_saltreach_armoury", name: "Saltreach Armoury", keeper: "", act: 5, wired: false,
                items: ["item_minor_potion", "item_ether", "item_tideglass"],
                stock_by_act: [{ act: 5, items: ["item_tidesteel_blade", "item_tideglass_dirk", "item_tidebound_codex", "item_drowned_bell_blade", "item_saltreach_maul", "item_drowned_coat", "item_saltreach_charm"] }],
                lines_buy: ["Everything here has been wet."], lines_sell: ["Everything here has been wet."]
            };
        case "shop_ironspine_supply":
            return {
                shop_id: "shop_ironspine_supply", name: "Ironspine Supply", keeper: "", act: 6, wired: false,
                items: ["item_minor_potion", "item_ether", "item_architect_alloy"],
                stock_by_act: [{ act: 6, items: ["item_ironspine_maul", "item_ironspine_longsword", "item_mine_shard_dirk", "item_architect_codex", "item_constructs_bane", "item_mine_plate", "item_architect_ring"] }],
                lines_buy: ["Mind the lift."], lines_sell: ["Mind the lift."]
            };
        case "shop_ashlands_outpost":
            return {
                // Sarn's wagon at the Crownveil breach (rm_ashlands_breach), the one built room of the
                // Ashlands. The weapon crates open at scr_story_act() 7 (after Chapter 8); before that the
                // shelf is potions, Ether and Ember Core. The room's overworld entrance is provisionally
                // gated on flag_act4_complete until Act VII has a story of its own.
                shop_id: "shop_ashlands_outpost", name: "Ashlands Outpost", keeper: "Sarn", act: 7, wired: true,
                items: ["item_minor_potion", "item_ether", "item_ember_core"],
                stock_by_act: [{ act: 7, items: ["item_ashlands_edge", "item_ashglass_dirk", "item_ember_codex", "item_cinder_vigil", "item_ashfall_greatsword", "item_emberweave_robe", "item_ash_crown", "item_crownwall_shield"] }],
                lines_buy: ["Outpost steel. It came a long way to be here."], lines_sell: ["I'll take what the road left you."]
            };
        case "shop_rimehold_armoury":
            return {
                // Built ahead of Act VIII: rm_rimehold's armoury courtyard. The entrance is gated on
                // flag_act4_complete (the same provisional lock as the Ashlands), so the tier-VIII shelf
                // becomes reachable as soon as scr_story_act() reaches 8.
                shop_id: "shop_rimehold_armoury", name: "Rimehold Armoury", keeper: "Armourer", act: 8, wired: true,
                items: ["item_minor_potion", "item_ether", "item_veil_shard", "item_elixir_first_flame"],
                stock_by_act: [{ act: 8, items: ["item_true_name_blade", "item_rime_sword", "item_veilstep_dirk", "item_rime_codex", "item_winterforge_greatsword", "item_veil_plate", "item_veil_ring", "item_veil_greaves"] }],
                lines_buy: ["Rimehold steel. It will outlast the cold.", "Take what the road south will need."],
                lines_sell: ["Rimehold keeps what Rimehold needs."]
            };
    }
    return undefined;
}

function scr_shop_open(_shop_id) {
    var _shop = scr_shop_get(_shop_id);
    if (!is_struct(_shop)) {
        show_debug_message("[shop] unknown shop_id: " + string(_shop_id));
        return noone;
    }
    if (variable_global_exists("game") && is_struct(global.game)) {
        if (global.game.battle_active || global.game.dialogue_open) {
            // Caller should open after dialogue finishes; do not overlap the box.
        }
    }
    var _stock = scr_shop_stock(_shop);
    if (array_length(_stock) > 0) _shop.items = _stock;
    var _inst = scr_menu_open_object("obj_shop_menu");
    if (_inst != noone && instance_exists(_inst)) {
        _inst.shop_id = _shop.shop_id;
        _inst.shop = _shop;
        _inst.mode = "list"; // the shop object has one list/qty flow; "root" had no input branch
        _inst.tab = 0;
        _inst.index = 0;
        _inst.qty = 1;
        _inst.message = "";
    }
    return _inst;
}

/// A merchant NPC's "browse or leave" prompt, for rooms with no bespoke shop dialogue.
function scr_shopkeeper_talk(_shop_id) {
    var _shop = scr_shop_get(_shop_id);
    if (!is_struct(_shop)) return noone;
    var _keeper = _shop.keeper != "" ? _shop.keeper : "Merchant";
    var _lines = is_array(_shop.lines_buy) && array_length(_shop.lines_buy) > 0 ? _shop.lines_buy : ["What do you need?"];
    var _cb = method({ shop_id: _shop_id }, function(_idx) {
        if (_idx == 0) scr_shop_open(shop_id);
    });
    return scr_dialogue_choice(_lines, _keeper, ["Browse wares", "Leave"], _cb);
}

/// Sarn's outpost wagon at the Crownveil breach. First visit plays the greeting and opens the
/// wagon; later visits open it directly, and the repeat line follows scr_story_act() so the
/// sealed weapon crates and the shelf agree (the same shape as Mott's cart).
function scr_ashlands_trader_talk() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    if (!scr_flag_get("ash_trader_met")) {
        scr_dialogue_play(["AO_TRADER_01", "AO_TRADER_02"], function() {
            scr_flag_set("ash_trader_met");
            scr_shop_open("shop_ashlands_outpost");
        });
        return;
    }
    if (scr_story_act() < 7) {
        scr_dialogue_play(["AO_TRADER_R1"], function() { scr_shop_open("shop_ashlands_outpost"); });
        return;
    }
    scr_dialogue_play(["AO_TRADER_R2"], function() { scr_shop_open("shop_ashlands_outpost"); });
}

/// Forge counter: browse the smith's wares, or craft the current act's patterns.
function scr_forge_open(_shop_id) {
    var _shop = scr_shop_get(_shop_id);
    var _keeper = is_struct(_shop) && _shop.keeper != "" ? _shop.keeper : "The smith";
    var _cb = method({ shop_id: _shop_id }, function(_idx) {
        if (_idx == 0) { scr_shop_open(shop_id); return; }
        if (_idx == 1) { scr_forge_offer(shop_id); return; }
    });
    return scr_dialogue_choice(["The forge is hot. What do you need?"], _keeper, ["Browse wares", "Forge", "Leave"], _cb);
}

/// The forge's patterns for the current act only, so the choice list stays short.
function scr_forge_offer(_shop_id) {
    var _act = scr_story_act();
    var _all = scr_craft_recipes();
    var _recs = [];
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].act == _act) array_push(_recs, _all[_i]);
    }
    if (array_length(_recs) == 0) {
        scr_dialogue_open(["I've no patterns for the likes of you yet. Bring me better metal."], "");
        return;
    }
    var _opts = [];
    for (var _r = 0; _r < array_length(_recs); _r++) array_push(_opts, scr_craft_label(_recs[_r]));
    array_push(_opts, "Back");
    var _cb = method({ shop_id: _shop_id, recs: _recs }, function(_idx) {
        if (_idx >= array_length(recs)) { scr_forge_open(shop_id); return; }
        var _msg = scr_craft_make(recs[_idx].result);
        scr_dialogue_play([_msg], function() { scr_forge_offer(shop_id); });
    });
    return scr_dialogue_choice(["What will you make?"], "", _opts, _cb);
}

/// Every bag item, including unsellable / key rows (those are drawn disabled).
function scr_shop_sellable_list() {
    scr_game_state_init();
    var _out = [];
    var _inv = global.game.inventory;
    if (!is_array(_inv)) return _out;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        var _e = _inv[_i];
        if (!is_struct(_e)) continue;
        var _it = scr_item_get(_e.item_id);
        var _key = (variable_struct_exists(_e, "key_item") && _e.key_item) || _it.key_item;
        var _price = scr_item_sell_price(_e.item_id);
        var _can = (!_key && !_it.unique && _it.sellable && _price > 0);
        array_push(_out, { item_id: _e.item_id, name: _it.name, qty: _e.qty, price: _price, unsellable: !_can, key_item: _key });
    }
    return _out;
}

/// Chapter 9's copy branch buys the party a standing discount. [PROPOSED] 10%: the chapter only
/// says "a shop discount", and Coleford has no shop of its own yet, so it applies at every shop.
function scr_shop_discount_active() {
    return scr_flag_get("ch9_shop_discount");
}

/// The price a shop actually charges: base price less the Chapter 9 discount when earned.
function scr_shop_buy_price(_item_id) {
    var _base = scr_item_buy_price(_item_id);
    if (_base <= 0 || !scr_shop_discount_active()) return _base;
    return max(1, floor(_base * 0.9));
}

function scr_shop_buy(_item_id, _qty) {
    scr_game_state_init();
    var _n = max(1, floor(_qty));
    var _it = scr_item_get(_item_id);
    var _price = scr_shop_buy_price(_item_id);
    if (_price <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "That isn't for sale."; }
    var _total = _price * _n;
    if (global.game.gold < _total) { scr_audio_sfx("menu_error", 0, 0.8); return "Not enough gold."; }
    if ((_it.key_item || _it.unique) && scr_inventory_has(_item_id)) { scr_audio_sfx("menu_error", 0, 0.8); return "You already have that."; }
    global.game.gold -= _total;
    scr_inventory_add(_it.item_id, _it.name, _n, _it.key_item);
    return "Bought " + _it.name + " x" + string(_n) + ".";
}

function scr_shop_sell(_item_id, _qty) {
    scr_game_state_init();
    var _it = scr_item_get(_item_id);
    if (_it.key_item || _it.unique || !_it.sellable) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    var _have = scr_inventory_count(_item_id);
    var _n = clamp(floor(_qty), 1, _have);
    if (_n <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "You don't have that."; }
    var _unit = scr_item_sell_price(_item_id);
    if (_unit <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    if (!scr_inventory_remove(_item_id, _n, false)) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    global.game.gold += _unit * _n;
    return "Sold " + _it.name + " x" + string(_n) + ".";
}

/// Inn rest (PLACEHOLDER price). Offers a Yes / No choice; on Yes with enough gold, restores HP
/// and MP for the active party and reserve, clears overworld poison, and takes the gold.
/// `_lines` are the keeper's lines shown before the choice (the last one carries the choice).
function scr_inn_offer(_keeper, _price, _lines = undefined) {
    scr_game_state_init();
    var _ask = "Rest for the night? " + string(_price) + " gold. (You have " + string(global.game.gold) + ".)";
    var _all = is_array(_lines) ? _lines : [];
    var _show = [];
    for (var _i = 0; _i < array_length(_all); _i++) array_push(_show, _all[_i]);
    array_push(_show, _ask);
    var _cb = method({ keeper: _keeper, price: _price }, function(_idx) {
        if (_idx != 0) return;
        if (global.game.gold < price) {
            scr_dialogue_open(["Not enough gold."], keeper);
            return;
        }
        global.game.gold -= price;
        scr_inn_rest_party();
        scr_dialogue_open(["You rest until morning. HP and MP are fully restored."], "");
    });
    return scr_dialogue_choice(_show, _keeper, ["Rest (" + string(_price) + "g)", "Leave"], _cb);
}

function scr_inn_rest_party() {
    var _lists = [global.game.party, global.game.reserve];
    for (var _l = 0; _l < 2; _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _a = _list[_i];
            if (!is_struct(_a)) continue;
            _a.hp = _a.max_hp;
            if (variable_struct_exists(_a, "max_mp")) _a.mp = _a.max_mp;
            _a.poisoned = false;
        }
    }
}

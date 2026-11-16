/// scr_save — versioned save data for the party, gold and player position.
/// Build, validate and apply are pure so they can be tested; only scr_save_game / scr_save_read /
/// scr_save_load touch the filesystem. Requires GameMaker 2.3+.
///
/// Stats are derived from level on load, so a saved copy of attack/defense is ignored: rebalancing
/// applies to existing saves instead of restoring stale numbers. Bump SAVE_VERSION when the schema
/// itself changes — there is no migration path yet, and a mismatched version is refused, not guessed at.

#macro SAVE_VERSION 1
#macro SAVE_FILE "ashen_crown_save.json"
#macro SAVE_TEMP "ashen_crown_save.tmp"

/// @desc The saved shape of one party member. Anything derivable from level is left out on purpose.
function scr_save_actor(_actor) {
    return {
        name: _actor.name,
        level: _actor.level,
        xp: _actor.xp,
        hp: _actor.hp
    };
}

/// @desc Where the player stands, so a load restores the overworld position.
function scr_save_capture_player(_player) {
    if (_player == noone || !instance_exists(_player)) return { x: 0, y: 0, facing_x: 0, facing_y: 1 };
    return { x: _player.x, y: _player.y, facing_x: _player.facing_x, facing_y: _player.facing_y };
}

/// @desc Saved shape of the inventory: id/count pairs only, so unknown fields cannot ride along.
function scr_save_inventory(_inventory) {
    var _rows = [];
    var _count = array_length(_inventory);
    for (var _i = 0; _i < _count; _i++) array_push(_rows, { id: _inventory[_i].id, count: _inventory[_i].count });
    return _rows;
}

/// @desc Build a save document from the live party and player.
function scr_save_build(_party, _player = noone) {
    var _members = [];
    var _count = array_length(_party.members);
    for (var _i = 0; _i < _count; _i++) array_push(_members, scr_save_actor(_party.members[_i]));
    var _items = variable_struct_exists(_party, "items") ? scr_save_inventory(_party.items) : [];
    return {
        version: SAVE_VERSION,
        party: { gold: _party.gold, members: _members, items: _items },
        player: scr_save_capture_player(_player)
    };
}

/// @desc Validate a parsed save document. Returns { ok, reason }; reason is for the player-facing line.
function scr_save_validate(_data) {
    if (is_undefined(_data) || _data == undefined) return { ok: false, reason: "save is empty or unreadable" };
    if (!variable_struct_exists(_data, "version")) return { ok: false, reason: "save has no version" };
    if (_data.version != SAVE_VERSION) return { ok: false, reason: "save version " + string(_data.version) + " is not supported" };
    if (!variable_struct_exists(_data, "party")) return { ok: false, reason: "save has no party" };
    if (!variable_struct_exists(_data.party, "members")) return { ok: false, reason: "save party has no members" };
    var _count = array_length(_data.party.members);
    if (_count <= 0 || _count > 4) return { ok: false, reason: "save party size is out of range" };
    for (var _i = 0; _i < _count; _i++) {
        var _member = _data.party.members[_i];
        if (!variable_struct_exists(_member, "name") || !is_string(_member.name) || _member.name == "") {
            return { ok: false, reason: "save has a member without a name" };
        }
        if (!variable_struct_exists(_member, "level") || _member.level < 1) {
            return { ok: false, reason: "save has a member with an invalid level" };
        }
        if (!variable_struct_exists(_member, "hp")) return { ok: false, reason: "save has a member without HP" };
    }
    /// items is optional: a save written before the inventory existed loads as an empty inventory.
    if (variable_struct_exists(_data.party, "items")) {
        if (!is_array(_data.party.items)) return { ok: false, reason: "save inventory is not a list" };
        var _stacks = array_length(_data.party.items);
        for (var _i = 0; _i < _stacks; _i++) {
            var _stack = _data.party.items[_i];
            if (!variable_struct_exists(_stack, "id") || is_undefined(scr_item_data(_stack.id))) {
                return { ok: false, reason: "save has an unknown item" };
            }
            if (!variable_struct_exists(_stack, "count") || _stack.count < 1) {
                return { ok: false, reason: "save has an item with a bad count" };
            }
        }
    }
    return { ok: true, reason: "" };
}

/// @desc Rebuild one member from saved data: stats from the level, HP and XP clamped into range.
function scr_save_restore_actor(_data) {
    var _actor = scr_party_make_actor(_data.name, max(1, floor(_data.level)));
    if (variable_struct_exists(_data, "xp")) {
        _actor.xp = clamp(floor(_data.xp), 0, max(0, _actor.xp_to_next - 1));
    }
    if (variable_struct_exists(_data, "hp")) {
        _actor.hp = clamp(floor(_data.hp), 0, _actor.max_hp);
    }
    return _actor;
}

/// @desc Restore global.party and the player position. Returns false and changes nothing if the save
/// is invalid, so a corrupt file cannot half-load over a working game.
function scr_save_apply(_data, _player = noone) {
    var _check = scr_save_validate(_data);
    if (!_check.ok) return false;

    var _members = [];
    var _count = array_length(_data.party.members);
    for (var _i = 0; _i < _count; _i++) {
        array_push(_members, scr_save_restore_actor(_data.party.members[_i]));
    }
    var _gold = variable_struct_exists(_data.party, "gold") ? _data.party.gold : 0;
    var _items = scr_inventory_create();
    if (variable_struct_exists(_data.party, "items")) {
        var _saved_items = _data.party.items;
        for (var _i = 0; _i < array_length(_saved_items); _i++) {
            scr_inventory_add(_items, _saved_items[_i].id, _saved_items[_i].count);
        }
    }
    global.party = { members: _members, gold: max(0, floor(_gold)), items: _items };

    if (_player != noone && instance_exists(_player) && variable_struct_exists(_data, "player")) {
        var _p = _data.player;
        if (variable_struct_exists(_p, "x")) _player.x = _p.x;
        if (variable_struct_exists(_p, "y")) _player.y = _p.y;
        if (variable_struct_exists(_p, "facing_x")) _player.facing_x = _p.facing_x;
        if (variable_struct_exists(_p, "facing_y")) _player.facing_y = _p.facing_y;
    }
    return true;
}

/// @desc Save the live party and player position. Returns a status line.
function scr_save_game(_player = noone) {
    var _data = scr_save_build(scr_party_ensure_global(), _player);
    var _text = json_stringify(_data);

    /// Write to a temp file and copy over the real save, so a crash mid-write cannot replace a working
    /// save with half a document.
    var _file = file_text_open_write(SAVE_TEMP);
    if (_file < 0) return "could not open the save file";
    file_text_write_string(_file, _text);
    file_text_close(_file);
    file_copy(SAVE_TEMP, SAVE_FILE);
    file_delete(SAVE_TEMP);
    return "saved";
}

/// @desc Read and parse the save file. Returns the parsed document, or undefined if absent or corrupt.
function scr_save_read() {
    if (!file_exists(SAVE_FILE)) return undefined;
    var _file = file_text_open_read(SAVE_FILE);
    if (_file < 0) return undefined;
    var _text = "";
    while (!file_text_eof(_file)) {
        _text += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);
    if (_text == "") return undefined;
    /// json_parse returns undefined for malformed text, which scr_save_validate reports cleanly.
    return json_parse(_text);
}

/// @desc Load the save into memory, restoring the party and the player. Returns a status line.
function scr_save_load(_player = noone) {
    var _data = scr_save_read();
    var _check = scr_save_validate(_data);
    if (!_check.ok) return _check.reason;
    if (!scr_save_apply(_data, _player)) return "save could not be applied";
    return "loaded";
}

/// obj_npc : Create
/// One interactable: face it and press Z to talk. The body is drawn in code as a placeholder until the
/// NPC/sign art listed in docs/ASSET_INVENTORY.md exists; interaction does not depend on a sprite.
if (!variable_instance_exists(id, "dialogue_id")) dialogue_id = "npc_hermit";
/// Said instead once the primary scene has been heard. Leave empty for a one-scene NPC.
if (!variable_instance_exists(id, "dialogue_id_after")) dialogue_id_after = "";
/// The last scene in the chain, once the middle one has been heard too.
if (!variable_instance_exists(id, "dialogue_id_final")) dialogue_id_final = "";
/// "npc" draws a standing figure; "prop" draws a door or sign block instead.
if (!variable_instance_exists(id, "npc_kind")) npc_kind = "npc";
talk_range = 48;
sprite_index = -1;
/// Behind the player, so the player is never hidden under the NPC.
depth = 1;

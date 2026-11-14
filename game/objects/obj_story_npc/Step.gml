/// obj_story_npc : Step
/// Arm after the player has been seen off the tile, then fire once on contact
/// so FK_01 (on the bandit-camp north exit) cannot be walked past.
var _touching = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_touching) {
    armed = true;
    exit;
}
if (!armed || scr_input_locked()) exit;
armed = false;
interact();

"""Art for the ten engine marker sprites that shipped as flat single-colour blocks.

These sprites are the fallbacks and debug markers the objects draw when they have nothing
better: collision blocks, encounter/story triggers, the respawn point, the generic
interactable prop, the story-NPC stand-in, the trap plate and the player fallback. Most of
them are only visible with DEBUG_SHOW_TRIGGERS on, so the art is deliberately iconographic -
a level designer should be able to read the whole map at a glance - while the two that can
show in normal play (the chest fallback and the player fallback) are drawn as real props.

Run from game/sprites/:  python3 src/markers.py
"""
import os
import sys

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import canvas, px, rect

OUT = os.path.join(os.path.dirname(HERE), 'ui', 'markers')

OUTLINE = (22, 20, 26)
STONE = (118, 122, 130)
STONE2 = (84, 88, 96)
STONE3 = (150, 154, 162)
WOOD = (112, 80, 48)
WOOD2 = (78, 54, 32)
GOLD = (217, 184, 96)
GOLD2 = (250, 226, 150)
RED = (176, 64, 56)
RED2 = (216, 108, 88)
GREEN = (96, 150, 110)
BLUE = (86, 116, 180)
BONE = (226, 218, 200)
IRON = (96, 100, 108)
IRON2 = (140, 146, 154)
DARK = (34, 32, 40)
CLOTH = (108, 96, 132)
SKIN = (232, 180, 140)


def outline_pass(im, oc=OUTLINE):
    """Give every transparent neighbour of a filled pixel the dark outline colour."""
    out = im.copy()
    filled = [(x, y) for y in range(im.height) for x in range(im.width) if im.getpixel((x, y))[3]]
    for (x, y) in filled:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < im.width and 0 <= ny < im.height and im.getpixel((nx, ny))[3] == 0:
                out.putpixel((nx, ny), tuple(oc) + (255,))
    return out


def save(im, name):
    os.makedirs(OUT, exist_ok=True)
    path = os.path.join(OUT, name + '.png')
    im.save(path)
    return path


# ---------------------------------------------------------------- 16x16 markers
def solid():
    """Collision block: a brick hatch, so blocked tiles read instantly in debug view."""
    im = canvas(16, 16)
    rect(im, 1, 1, 14, 14, STONE2)
    for row in range(4):
        y = 2 + row * 3
        offset = 0 if row % 2 == 0 else 3
        for bx in range(-1, 5):
            x = 1 + offset + bx * 4
            rect(im, max(1, x), y, min(13, x + 2), y + 1, STONE)
    rect(im, 1, 1, 14, 1, STONE3)
    return save(outline_pass(im), 'spr_solid_placeholder')


def interactable():
    """Generic prop fallback: a closed chest with an iron band and a brass lock."""
    im = canvas(16, 16)
    rect(im, 2, 6, 13, 14, WOOD)          # body
    rect(im, 2, 4, 13, 6, WOOD)           # lid
    rect(im, 2, 6, 13, 6, WOOD2)          # lid/bottom seam
    rect(im, 2, 4, 13, 4, (140, 104, 64))  # lid highlight
    rect(im, 7, 4, 8, 14, IRON)           # centre band
    rect(im, 7, 8, 8, 10, GOLD)           # lock plate
    px(im, 8, 9, GOLD2)
    rect(im, 2, 13, 13, 14, WOOD2)        # shadowed base
    px(im, 3, 5, GOLD2)
    return save(outline_pass(im), 'spr_interactable_placeholder')


def story_npc():
    """Stand-in villager: a hooded figure, so an unassigned NPC still reads as a person."""
    im = canvas(16, 16)
    rect(im, 6, 4, 9, 8, SKIN)            # face, narrower than the cowl
    rect(im, 4, 3, 11, 5, CLOTH)          # cowl brim over the brow
    rect(im, 5, 1, 10, 3, CLOTH)          # hood crown
    px(im, 4, 5, CLOTH)
    px(im, 11, 5, CLOTH)
    px(im, 6, 6, OUTLINE)                 # eyes
    px(im, 9, 6, OUTLINE)
    px(im, 7, 8, (206, 150, 118))         # chin shadow
    rect(im, 4, 8, 11, 13, CLOTH)         # body
    rect(im, 4, 12, 11, 13, (86, 76, 106))
    rect(im, 6, 14, 7, 15, (58, 50, 70))  # legs
    rect(im, 9, 14, 10, 15, (58, 50, 70))
    return save(outline_pass(im), 'spr_story_npc_placeholder')


def player():
    """16x24 fallback for Kael: dark traveller's coat, ash-grey scarf, sword at the hip."""
    im = canvas(16, 24)
    cx = 8
    rect(im, cx - 2, 2, cx + 1, 8, (36, 34, 44))   # hair
    rect(im, cx - 2, 6, cx + 1, 9, (224, 178, 140))  # face
    px(im, cx - 1, 7, OUTLINE)
    px(im, cx + 1, 7, OUTLINE)
    rect(im, cx - 3, 9, cx + 2, 16, (58, 62, 78))   # coat
    rect(im, cx - 3, 10, cx + 2, 11, (150, 146, 138))  # scarf
    rect(im, cx - 3, 16, cx + 2, 17, (44, 46, 58))  # belt line
    rect(im, cx - 2, 17, cx - 1, 22, (70, 66, 74))  # legs
    rect(im, cx, 17, cx + 1, 22, (70, 66, 74))
    rect(im, cx - 2, 22, cx - 1, 23, (40, 38, 44))  # boots
    rect(im, cx, 22, cx + 1, 23, (40, 38, 44))
    rect(im, cx + 2, 13, cx + 2, 17, (196, 200, 208))  # blade at the hip
    px(im, cx + 2, 12, (232, 236, 240))
    px(im, cx + 2, 18, GOLD)
    return save(outline_pass(im), 'spr_player_placeholder')


def respawn_point():
    """Floor rune: a teal circle with a spark, the "you come back here" marker."""
    im = canvas(16, 16)
    cx, cy = 8, 9
    for (x, y) in [(4, 9), (12, 9), (8, 5), (8, 13), (5, 6), (11, 6), (5, 12), (11, 12)]:
        px(im, x, y, (86, 196, 178))
    for (x, y) in [(6, 9), (10, 9), (8, 7), (8, 11)]:
        px(im, x, y, (140, 226, 208))
    px(im, 8, 9, (216, 250, 240))
    px(im, 8, 8, (176, 240, 224))
    rect(im, 6, 14, 9, 14, (48, 96, 92))
    return save(outline_pass(im, (16, 40, 38)), 'spr_respawn_point_placeholder')


def encounter_trigger():
    """Fixed battle trigger: crossed swords on a red field."""
    im = canvas(16, 16)
    rect(im, 2, 2, 13, 13, (92, 40, 40))
    for i in range(9):
        px(im, 4 + i, 4 + i, (226, 230, 236))
        px(im, 4 + i, 11 - i, (226, 230, 236))
    rect(im, 2, 2, 13, 2, RED)
    px(im, 3, 12, GOLD)
    px(im, 12, 12, GOLD)
    rect(im, 3, 12, 4, 12, GOLD2)
    rect(im, 11, 12, 12, 12, GOLD2)
    return save(outline_pass(im, (40, 16, 18)), 'spr_encounter_trigger_placeholder')


def encounter_zone():
    """Random-encounter zone tile: a dashed red border with a small warning mark."""
    im = canvas(16, 16)
    for i in range(0, 16, 3):
        px(im, i, 0, RED)
        px(im, i + 1, 0, RED2)
        px(im, i, 15, RED)
        px(im, i + 1, 15, RED2)
        px(im, 0, i, RED)
        px(im, 0, i + 1, RED2)
        px(im, 15, i, RED)
        px(im, 15, i + 1, RED2)
    # small warning mark: an exclamation bar over a dot
    rect(im, 7, 5, 8, 8, RED)
    px(im, 7, 5, RED2)
    rect(im, 7, 10, 8, 11, RED)
    return save(im, 'spr_encounter_zone_placeholder')


def story_trigger():
    """Story beat marker: a gold pennant on a spear shaft."""
    im = canvas(16, 16)
    rect(im, 4, 2, 4, 15, WOOD)
    rect(im, 5, 2, 12, 6, GOLD)
    rect(im, 5, 2, 12, 2, GOLD2)
    px(im, 12, 4, GOLD2)
    px(im, 5, 6, (176, 140, 64))
    px(im, 4, 1, IRON2)
    rect(im, 2, 14, 6, 15, STONE2)
    return save(outline_pass(im), 'spr_story_trigger_placeholder')


def story_encounter():
    """Scripted battle marker: a bone skull, distinct from the crossed-swords trigger."""
    im = canvas(16, 16)
    rect(im, 4, 3, 11, 9, BONE)
    rect(im, 5, 9, 10, 11, BONE)
    rect(im, 5, 5, 6, 6, OUTLINE)   # eyes
    rect(im, 9, 5, 10, 6, OUTLINE)
    px(im, 7, 8, OUTLINE)
    px(im, 8, 8, OUTLINE)
    for x in range(6, 10):          # teeth
        px(im, x, 10, OUTLINE if x % 2 == 0 else BONE)
    rect(im, 2, 12, 13, 13, (92, 40, 40))
    return save(outline_pass(im, (30, 26, 24)), 'spr_story_encounter_placeholder')


def trap_plate():
    """Spike plate: an iron floor plate with four raised spikes."""
    im = canvas(16, 16)
    rect(im, 2, 2, 13, 13, IRON)
    rect(im, 2, 2, 13, 2, IRON2)
    for (x, y) in [(4, 5), (9, 4), (5, 9), (10, 9)]:
        px(im, x + 1, y, BONE)
        px(im, x, y + 1, BONE)
        px(im, x + 1, y + 1, BONE)
        px(im, x + 2, y + 1, BONE)
        px(im, x + 1, y + 2, BONE)
    rect(im, 3, 12, 12, 12, (70, 74, 82))
    return save(outline_pass(im), 'spr_trap_plate_placeholder')


BUILDERS = [solid, interactable, story_npc, player, respawn_point, encounter_trigger,
            encounter_zone, story_trigger, story_encounter, trap_plate]

if __name__ == '__main__':
    for fn in BUILDERS:
        print(fn())

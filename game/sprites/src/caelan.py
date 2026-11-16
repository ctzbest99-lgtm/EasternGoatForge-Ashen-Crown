"""Caelan Rook sprites (former royal scholar, Arcanist, deserter with a spellbook).

Overworld: 16x24, 4 directions, idle + 4 walk frames  -> game/sprites/npcs/caelan/
Battle:    32x48 idle/walk/hurt/defend, 48x48 attack/death -> game/sprites/party/caelan/
Portraits: 48x48 neutral / determined / pained     -> game/sprites/portraits/caelan/

Style matches the repo's flat-colour pixel sets: a long dark-blue robe with a gold
hem, short dark hair, and a staff whose crystal is the only bright accent.
Run from game/sprites/:  python3 src/caelan.py
"""
import os, sys

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import save_overworld, save_battle, save_portraits

P = dict(
    skin=(228, 182, 142), skin2=(196, 146, 112),
    hair=(70, 50, 42), hair2=(46, 32, 28),
    coat=(60, 66, 116), coat2=(42, 46, 84),
    trim=(150, 130, 84),
    pants=(48, 46, 56), boot=(34, 30, 28),
    metal=(170, 176, 190), metal2=(210, 216, 228),
    wood=(92, 66, 44),
    crystal=(140, 214, 224), crystal2=(214, 244, 246),
    out=(18, 18, 28),
    robe=True,
    long_hair=False,
)

if __name__ == '__main__':
    print('Caelan overworld ->', save_overworld(P, 'caelan', weapon='staff'))
    print('Caelan battle    ->', save_battle(P, 'caelan', weapon='staff'))
    print('Caelan portraits ->', save_portraits(P, 'caelan'))

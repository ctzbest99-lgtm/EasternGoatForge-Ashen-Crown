"""Lyra Veyne sprites — Lower City thief, twin daggers.

Overworld: 16x24, 4 directions, idle + 4 walk frames  -> game/sprites/npcs/lyra/
Battle:    32x48 idle/walk/hurt/defend, 48x48 attack/death -> game/sprites/party/lyra/
Portraits: 48x48 neutral / determined / pained     -> game/sprites/portraits/lyra/

Uses the shared party renderer (party_kit) that drew Sera and Caelan, so Lyra is now in the
same style as the rest of the party instead of the older flat placeholder set. Canon
(ACT2_OUTLINE.md §Lyra Veyne, CHAPTER3_SCRIPT.md 6.4): twin daggers, Lower City, criminal
underworld, dry humour. Colours are a design choice, not canon: dark teal leather, brass
buckles, tied-back auburn hair, two short blades.
Run from game/sprites/:  python3 src/lyra.py
"""
import os, sys

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import save_overworld, save_battle, save_portraits

P = dict(
    skin=(236, 186, 146), skin2=(200, 146, 110),
    hair=(104, 58, 36), hair2=(70, 38, 24),
    coat=(52, 88, 74), coat2=(38, 64, 55),
    trim=(176, 138, 74),
    pants=(56, 52, 48), boot=(34, 30, 28),
    metal=(198, 202, 208), metal2=(232, 236, 240),
    wood=(92, 66, 42),
    crystal=(150, 170, 160), crystal2=(196, 210, 200),
    out=(20, 18, 22),
    pauldron=False,
    long_hair=False,
    ponytail=True,
    robe=False,
)

if __name__ == '__main__':
    print('Lyra overworld ->', save_overworld(P, 'lyra', weapon='daggers'))
    print('Lyra battle    ->', save_battle(P, 'lyra', weapon='daggers'))
    print('Lyra portraits ->', save_portraits(P, 'lyra'))

"""Sera Thorn sprites (Seraphine "Sera" Thorn, Silver Guard deserter, Warden).

Overworld: 16x24, 4 directions, idle + 4 walk frames  -> game/sprites/npcs/sera/
Battle:    32x48 idle/walk/hurt/defend, 48x48 attack/death -> game/sprites/party/sera/
Portraits: 48x48 neutral / determined / pained     -> game/sprites/portraits/sera/

Style matches the repo's flat-colour pixel sets (hard edges, one dark outline, no AA):
a silver guard coat with gold trim, bright pauldrons, pale hair, and a long pale sword.
Run from game/sprites/:  python3 src/sera.py
"""
import os, sys

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import save_overworld, save_battle, save_portraits

P = dict(
    skin=(238, 194, 152), skin2=(206, 152, 116),
    hair=(204, 184, 132), hair2=(156, 136, 92),
    coat=(150, 158, 172), coat2=(110, 118, 132),
    trim=(196, 166, 84),
    pants=(70, 74, 86), boot=(42, 40, 46),
    metal=(214, 218, 224), metal2=(246, 240, 200),
    wood=(96, 70, 46),
    crystal=(206, 214, 226), crystal2=(246, 240, 200),
    out=(20, 22, 30),
    pauldron=True,
    long_hair=False,
)

if __name__ == '__main__':
    print('Sera overworld ->', save_overworld(P, 'sera', weapon='sword'))
    print('Sera battle    ->', save_battle(P, 'sera', weapon='sword'))
    print('Sera portraits ->', save_portraits(P, 'sera'))

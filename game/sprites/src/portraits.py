"""Lyra Veyne portraits (the only party member who had sprites but no portrait).

48x48 bust, neutral / determined / pained  -> game/sprites/portraits/lyra/
Palette is taken from src/lyra.py so the portrait matches her overworld and battle sets.
Run from game/sprites/:  python3 src/portraits.py
"""
import os, sys

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import save_portraits

P = dict(
    skin=(232, 180, 140), skin2=(200, 142, 108),
    hair=(74, 38, 28), hair2=(52, 26, 20),
    coat=(47, 74, 60), coat2=(38, 60, 49),
    trim=(150, 126, 72),
    pants=(58, 54, 48), boot=(36, 31, 26),
    metal=(200, 204, 208), metal2=(228, 232, 236),
    wood=(107, 82, 50),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(24, 20, 18),
    long_hair=True,
    ponytail=True,
)

if __name__ == '__main__':
    print('Lyra portraits ->', save_portraits(P, 'lyra'))

"""Character, menu and environmental audio.

Everything here is synthesised from the primitives in synth.py, so the set is original and
tiny on disk (all of it is well under a megabyte). Ambience beds are loop-safe: the tail
crossfades into the head so they can sit under a room indefinitely.
"""
import numpy as np

from synth import (SR, adsr, at, hat, kick, loop_safe, lowpass, mix, noise, normalise,
                   perc_env, pulse, sine, snare, soft_clip, triangle, saw, voice, write_wav)


def _n(dur):
    return int(round(dur * SR))


def _fade(x, a=0.004, r=0.02):
    n = len(x)
    a_n, r_n = max(1, int(a * SR)), max(1, int(r * SR))
    x = x.copy()
    x[:a_n] *= np.linspace(0, 1, a_n)
    x[-r_n:] *= np.linspace(1, 0, r_n)
    return x


# ------------------------------------------------------------------ character / battle
def attack_swing():
    dur = 0.22
    n = _n(dur)
    t = np.arange(n) / SR
    sweep = np.sin(2 * np.pi * np.cumsum(900 * np.exp(-9 * t) + 180) / SR)
    hiss = lowpass(noise(dur, seed=2, hold=3), 0.25) * perc_env(n, decay=18)
    body = (hiss * 0.7 + sweep * 0.25) * 0.6
    return ('snd_sfx_attack_swing', _fade(body))


def hit():
    dur = 0.18
    n = _n(dur)
    thud = sine(110, dur) * perc_env(n, decay=24) * 0.8
    crack = noise(dur, seed=4) * perc_env(n, decay=45) * 0.55
    return ('snd_sfx_hit', _fade(thud + crack))


def hit_crit():
    dur = 0.34
    n = _n(dur)
    thud = sine(92, dur) * perc_env(n, decay=14) * 0.85
    crack = noise(dur, seed=9, hold=2) * perc_env(n, decay=26) * 0.7
    ring = pulse(1320, dur, 0.3) * perc_env(n, decay=30) * 0.25
    return ('snd_sfx_hit_crit', _fade(thud + crack + ring))


def guard():
    dur = 0.30
    n = _n(dur)
    clank = (pulse(660, dur, 0.2) + pulse(987, dur, 0.5) * 0.7) * perc_env(n, decay=26) * 0.35
    grit = noise(dur, seed=12, hold=2) * perc_env(n, decay=40) * 0.4
    return ('snd_sfx_guard', _fade(clank + grit))


def cast():
    dur = 0.55
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['C5', 'E5', 'G5', 'C6']):
        at(out, i * 0.09, voice(note, 0.32, wave='pulse', duty=0.25, vol=0.28,
                                env=lambda k: adsr(k, 0.005, 0.1, 0.3, 0.18)))
    out += lowpass(noise(dur, seed=15, hold=4), 0.15) * perc_env(n, decay=7, attack=0.05) * 0.18
    return ('snd_sfx_cast', _fade(out, r=0.06))


def heal():
    dur = 0.8
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['F4', 'A4', 'C5', 'F5']):
        at(out, i * 0.11, voice(note, 0.7, wave='sine', vol=0.26,
                                env=lambda k: adsr(k, 0.02, 0.25, 0.45, 0.35)))
    shimmer = noise(dur, seed=21) * perc_env(n, decay=4, attack=0.06) * 0.06
    return ('snd_sfx_heal', _fade(out + shimmer, r=0.12))


def arrow():
    dur = 0.2
    n = _n(dur)
    t = np.arange(n) / SR
    twang = np.sin(2 * np.pi * np.cumsum(1400 * np.exp(-26 * t) + 320) / SR) * perc_env(n, decay=30)
    hiss = noise(dur, seed=24, hold=2) * perc_env(n, decay=35) * 0.4
    return ('snd_sfx_arrow', _fade(twang * 0.5 + hiss))


def enemy_fall():
    dur = 0.6
    n = _n(dur)
    t = np.arange(n) / SR
    fall = saw(1, dur)  # placeholder shape, replaced below by a swept pulse
    fall = np.where((np.cumsum(420 * np.exp(-3.4 * t) + 60) / SR) % 1.0 < 0.5, 1, -1)
    body = fall * perc_env(n, decay=6) * 0.35
    dust = lowpass(noise(dur, seed=27, hold=5), 0.12) * perc_env(n, decay=5, attack=0.03) * 0.3
    return ('snd_sfx_enemy_fall', _fade(body + dust, r=0.1))


def party_hurt():
    dur = 0.22
    n = _n(dur)
    t = np.arange(n) / SR
    grunt = np.where((np.cumsum(300 * np.exp(-5 * t) + 120) / SR) % 1.0 < 0.35, 1, -1)
    return ('snd_sfx_party_hurt', _fade(grunt * perc_env(n, decay=13) * 0.4))


def level_up():
    dur = 1.1
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['C5', 'E5', 'G5', 'C6', 'E6']):
        at(out, i * 0.1, voice(note, 0.85, wave='pulse', duty=0.25, vol=0.22, vib=True,
                               env=lambda k: adsr(k, 0.005, 0.15, 0.4, 0.4)))
    at(out, 0.5, voice('C4', 0.6, wave='tri', vol=0.18,
                       env=lambda k: adsr(k, 0.01, 0.1, 0.6, 0.3)))
    return ('snd_sfx_level_up', _fade(out, r=0.15))


def step():
    dur = 0.08
    n = _n(dur)
    body = lowpass(noise(dur, seed=31, hold=6), 0.09) * perc_env(n, decay=45) * 0.30
    return ('snd_sfx_step', _fade(body, r=0.01))


# ------------------------------------------------------------------ menu / UI
def menu_move():
    dur = 0.06
    n = _n(dur)
    blip = pulse(880, dur, 0.25) * perc_env(n, decay=55) * 0.30
    return ('snd_sfx_menu_move', _fade(blip, r=0.008))


def menu_confirm():
    dur = 0.22
    n = _n(dur)
    out = np.zeros(n)
    at(out, 0.0, voice('E5', 0.1, wave='pulse', duty=0.5, vol=0.3,
                       env=lambda k: adsr(k, 0.002, 0.02, 0.6, 0.02)))
    at(out, 0.07, voice('B5', 0.14, wave='pulse', duty=0.5, vol=0.3,
                        env=lambda k: adsr(k, 0.002, 0.03, 0.5, 0.05)))
    return ('snd_sfx_menu_confirm', _fade(out))


def menu_cancel():
    dur = 0.2
    n = _n(dur)
    out = np.zeros(n)
    at(out, 0.0, voice('B4', 0.09, wave='pulse', duty=0.5, vol=0.28,
                       env=lambda k: adsr(k, 0.002, 0.02, 0.6, 0.02)))
    at(out, 0.06, voice('E4', 0.13, wave='pulse', duty=0.5, vol=0.28,
                        env=lambda k: adsr(k, 0.002, 0.03, 0.5, 0.04)))
    return ('snd_sfx_menu_cancel', _fade(out))


def menu_open():
    dur = 0.32
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['G4', 'D5', 'G5']):
        at(out, i * 0.05, voice(note, 0.24, wave='pulse', duty=0.4, vol=0.16,
                                env=lambda k: adsr(k, 0.004, 0.05, 0.4, 0.1)))
    return ('snd_sfx_menu_open', _fade(out, r=0.06))


def menu_error():
    dur = 0.26
    n = _n(dur)
    buzz = np.where((np.arange(n) / SR * 120) % 1.0 < 0.5, 1, -1) * 0.22
    return ('snd_sfx_menu_error', _fade(buzz * perc_env(n, decay=9), r=0.04))


def save_chime():
    dur = 0.9
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['C5', 'G5', 'C6']):
        at(out, i * 0.12, voice(note, 0.7, wave='sine', vol=0.22,
                                env=lambda k: adsr(k, 0.01, 0.2, 0.35, 0.4)))
    return ('snd_sfx_save', _fade(out, r=0.16))


def item_get():
    dur = 0.45
    n = _n(dur)
    out = np.zeros(n)
    for i, note in enumerate(['E5', 'G5', 'B5', 'E6']):
        at(out, i * 0.06, voice(note, 0.3, wave='pulse', duty=0.125, vol=0.18,
                                env=lambda k: adsr(k, 0.003, 0.06, 0.3, 0.12)))
    return ('snd_sfx_item_get', _fade(out, r=0.1))


def coin():
    dur = 0.3
    n = _n(dur)
    out = np.zeros(n)
    at(out, 0.0, pulse(988, 0.08, 0.5) * perc_env(_n(0.08), decay=40) * 0.25)
    at(out, 0.06, pulse(1319, 0.2, 0.5) * perc_env(_n(0.2), decay=22) * 0.25)
    return ('snd_sfx_coin', _fade(out, r=0.05))


def text_blip():
    dur = 0.03
    n = _n(dur)
    return ('snd_sfx_text', _fade(pulse(1200, dur, 0.5) * perc_env(n, decay=90) * 0.10, r=0.005))


# ------------------------------------------------------------------ ambience beds
def wind(dur=10.0, seed=101):
    n = _n(dur)
    bed = lowpass(noise(dur, seed=seed, hold=8), 0.06)
    t = np.arange(n) / SR
    gust = 0.55 + 0.45 * np.sin(2 * np.pi * t / dur * 1.0) * np.sin(2 * np.pi * t / dur * 0.5)
    return ('snd_amb_wind', loop_safe(bed * gust * 0.9))


def forest(dur=12.0, seed=202):
    n = _n(dur)
    bed = lowpass(noise(dur, seed=seed, hold=8), 0.08) * 0.35
    rng = np.random.default_rng(seed)
    out = np.zeros(n)
    out[:len(bed)] += bed
    for _ in range(26):
        at(out, rng.uniform(0, dur - 0.3),
           voice(rng.choice(['E6', 'G6', 'A6', 'C7']), rng.uniform(0.05, 0.12),
                 wave='sine', vol=rng.uniform(0.06, 0.14),
                 env=lambda k: adsr(k, 0.004, 0.02, 0.2, 0.05)))
    return ('snd_amb_forest', loop_safe(out * 0.9, fade=0.5))


def dungeon(dur=12.0, seed=303):
    n = _n(dur)
    t = np.arange(n) / SR
    drone = (sine(55, dur) * 0.10 + sine(82.4, dur) * 0.05) * (0.7 + 0.3 * np.sin(2 * np.pi * t / dur * 2))
    out = drone.copy()
    rng = np.random.default_rng(seed)
    for _ in range(7):                      # water drips
        start = rng.uniform(0, dur - 0.4)
        drop = sine(rng.uniform(1100, 1600), 0.09) * perc_env(_n(0.09), decay=40) * 0.16
        at(out, start, drop)
    out += lowpass(noise(dur, seed=seed + 1, hold=10), 0.05) * 0.18
    return ('snd_amb_dungeon', loop_safe(out, fade=0.5))


def fire(dur=10.0, seed=404):
    n = _n(dur)
    out = lowpass(noise(dur, seed=seed, hold=4), 0.10) * 0.35
    rng = np.random.default_rng(seed)
    for _ in range(40):                     # crackles
        start = rng.uniform(0, dur - 0.1)
        c = noise(0.05, seed=int(rng.integers(1, 9999)), hold=1) * perc_env(_n(0.05), decay=70)
        at(out, start, c * rng.uniform(0.1, 0.5))
    return ('snd_amb_fire', loop_safe(out, fade=0.4))


def water(dur=10.0, seed=505):
    n = _n(dur)
    bed = lowpass(noise(dur, seed=seed, hold=3), 0.14) * 0.4
    t = np.arange(n) / SR
    flow = 0.7 + 0.3 * np.sin(2 * np.pi * t / dur * 3)
    out = bed * flow
    rng = np.random.default_rng(seed)
    for _ in range(10):                     # bubbles
        start = rng.uniform(0, dur - 0.2)
        b = sine(rng.uniform(300, 520), 0.07) * perc_env(_n(0.07), decay=34) * 0.10
        at(out, start, b)
    return ('snd_amb_water', loop_safe(out, fade=0.4))


def night(dur=12.0, seed=606):
    n = _n(dur)
    out = lowpass(noise(dur, seed=seed, hold=8), 0.05) * 0.22
    t = np.arange(n) / SR
    chirp = np.zeros(n)
    for k in range(24):                     # crickets: short high triplets
        start = k * (dur / 24.0) + 0.05
        for j in range(3):
            at(chirp, start + j * 0.045,
               sine(4200, 0.02) * perc_env(_n(0.02), decay=120) * 0.10)
    return ('snd_amb_night', loop_safe(out + chirp, fade=0.5))


BUILDERS = [
    attack_swing, hit, hit_crit, guard, cast, heal, arrow, enemy_fall, party_hurt,
    level_up, step,
    menu_move, menu_confirm, menu_cancel, menu_open, menu_error, save_chime, item_get,
    coin, text_blip,
    wind, forest, dungeon, fire, water, night,
]

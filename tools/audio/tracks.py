"""The three music loops: overworld, battle, boss.

Written as note tables so the harmony is readable and editable. Each track is an exact
number of bars rendered with no fade, so it loops seamlessly (the last bar's tail is
inside the buffer).
"""
import numpy as np

from synth import (SR, adsr, at, hat, kick, loop_safe, mix, normalise, pulse, pulse_v, reverb,
                   saw, sine, snare, timpani, triangle, voice, write_wav)


def _bars(n, beats=4, bpm=96):
    return n * beats * 60.0 / bpm


def _play(buf, pattern, bpm, start=0.0, **kw):
    """pattern: [(note, beats), ...] — rests are ('r', beats)."""
    spb = 60.0 / bpm
    t = start
    for note, beats in pattern:
        dur = beats * spb
        if note != 'r':
            at(buf, t, voice(note, dur, **kw))
        t += dur
    return t


def _repeat(pattern, times):
    return pattern * times


# ------------------------------------------------------------------ overworld
def build_overworld():
    """'The Ashen Road' — D dorian, 96 BPM, 16 bars. Plucked lead over a walking bass."""
    bpm = 96
    bars = 16
    total = _bars(bars, bpm=bpm)
    spb = 60.0 / bpm
    buf = np.zeros(int(total * SR) + 1)

    prog = ['Dm', 'Bb', 'F', 'C', 'Dm', 'Bb', 'C', 'Dm']          # 2 bars each, twice
    roots = {'Dm': 'D2', 'Bb': 'Bb1', 'F': 'F2', 'C': 'C2'}
    tones = {'Dm': ['D4', 'F4', 'A4'], 'Bb': ['Bb3', 'D4', 'F4'],
             'F': ['F4', 'A4', 'C5'], 'C': ['C4', 'E4', 'G4']}

    # pad: soft triangle chords, two bars each
    for i, ch in enumerate(prog * 2):
        t = i * 2 * 4 * spb
        for n in tones[ch]:
            # Held past the two-bar chord change so the pad never leaves a hole.
            at(buf, t, voice(n, 8.6 * spb, wave='tri', vol=0.055,
                             env=lambda k: adsr(k, 0.12, 0.3, 0.9, 0.25)))
    # Continuous eighth-note arpeggio: fills the mid range under the melody's phrase rests
    # and gives the field theme its NES-style motion.
    arps = {'Dm': ['D5', 'F5', 'A5', 'F5'], 'Bb': ['Bb4', 'D5', 'F5', 'D5'],
            'F': ['F5', 'A5', 'C6', 'A5'], 'C': ['C5', 'E5', 'G5', 'E5']}
    for i, ch in enumerate(prog * 2):
        t = i * 2 * 4 * spb
        seq = arps[ch] * 4
        for k, note in enumerate(seq):
            at(buf, t + k * 0.5 * spb,
               voice(note, 0.42 * spb, wave='pulse', duty=0.125, vol=0.045,
                     env=lambda n: adsr(n, 0.003, 0.05, 0.25, 0.05)))

    # bass: root on 1 and 3, fifth between
    for i, ch in enumerate(prog * 2):
        t = i * 2 * 4 * spb
        r = roots[ch]
        # Bass keeps walking under the melody's phrase rests, so the bed never thins out.
        _play(buf, [(r, 1), (r, 0.5), (r, 0.5), (r, 1), (r, 1),
                    (r, 0.5), (r, 0.5), (r, 0.5), (r, 0.5), (r, 1)], bpm, t,
              wave='tri', vol=0.16, env=lambda k: adsr(k, 0.006, 0.08, 0.5, 0.06))

    melody_a = [
        ('A4', 1), ('D5', 0.5), ('E5', 0.5), ('F5', 1), ('E5', 0.5), ('D5', 0.5),
        ('C5', 1.5), ('A4', 0.5), ('r', 1),
        ('Bb3', 1), ('D4', 0.5), ('F4', 0.5), ('G4', 1), ('F4', 0.5), ('D4', 0.5),
        ('C4', 2), ('r', 2),
    ]
    melody_b = [
        ('F4', 1), ('A4', 0.5), ('C5', 0.5), ('D5', 1), ('C5', 0.5), ('A4', 0.5),
        ('G4', 1.5), ('E4', 0.5), ('r', 1),
        ('D4', 1), ('F4', 0.5), ('A4', 0.5), ('G4', 1), ('F4', 0.5), ('E4', 0.5),
        ('D4', 1.5), ('A3', 0.5), ('D4', 1), ('r', 1),
    ]
    for rep in range(2):
        t = rep * 8 * 4 * spb
        _play(buf, melody_a, bpm, t, wave='pulse', duty=0.25, vol=0.15, vib=True,
              env=lambda k: adsr(k, 0.01, 0.12, 0.55, 0.18))
        _play(buf, melody_b, bpm, t + 4 * 4 * spb, wave='pulse', duty=0.25, vol=0.15, vib=True,
              env=lambda k: adsr(k, 0.01, 0.12, 0.55, 0.18))

    # light percussion from bar 5 so the loop opens quietly
    for bar in range(bars):
        t = bar * 4 * spb
        if bar >= 4:
            at(buf, t, kick(0.14, 0.30))
            at(buf, t + 2 * spb, snare(0.12, 0.14))
            for k in range(4):
                at(buf, t + (k + 0.5) * spb, hat(0.05, 0.055, seed=11 + k))

    buf = reverb(buf, mix_level=0.12, decay=0.5)
    return write_wav('snd_mus_overworld', loop_safe(buf, fade=0.04))


# ------------------------------------------------------------------ battle
def build_battle():
    """'Steel and Ash' — E minor, 152 BPM, 24 bars. Eighth-note bass, brass stabs, snare."""
    bpm = 152
    bars = 24
    total = _bars(bars, bpm=bpm)
    spb = 60.0 / bpm
    buf = np.zeros(int(total * SR) + 1)

    roots = ['E2', 'E2', 'C2', 'C2', 'G2', 'G2', 'D2', 'D2']
    stabs = [['E4', 'G4', 'B4'], ['E4', 'G4', 'B4'], ['C4', 'E4', 'G4'], ['C4', 'E4', 'G4'],
             ['G3', 'B3', 'D4'], ['G3', 'B3', 'D4'], ['D4', 'F#4', 'A4'], ['D4', 'F#4', 'A4']]
    for i, r in enumerate(roots * 3):
        t = i * 4 * spb
        for k in range(8):
            note = r if k % 2 == 0 else r
            at(buf, t + k * 0.5 * spb,
               voice(note, 0.46 * spb, wave='pulse', duty=0.5, vol=0.17,
                     env=lambda n: adsr(n, 0.004, 0.03, 0.35, 0.02)))
        for n in stabs[i % len(stabs)]:
            at(buf, t, voice(n, 0.9 * spb, wave='pulse', duty=0.4, vol=0.12, detune=0.004,
                             env=lambda n: adsr(n, 0.004, 0.1, 0.25, 0.06)))

    lead = [
        ('B4', 0.5), ('E5', 0.5), ('G5', 0.5), ('E5', 0.5), ('F#5', 0.5), ('E5', 0.5), ('D5', 1),
        ('C5', 0.5), ('E5', 0.5), ('G5', 0.5), ('E5', 0.5), ('D5', 0.5), ('B4', 0.5), ('A4', 1),
        ('G4', 0.5), ('B4', 0.5), ('D5', 0.5), ('B4', 0.5), ('C5', 0.5), ('B4', 0.5), ('A4', 1),
        ('F#4', 0.5), ('A4', 0.5), ('D5', 0.5), ('C5', 0.5), ('B4', 1), ('r', 1),
    ]
    for rep in range(3):
        t = rep * 8 * 4 * spb
        _play(buf, lead, bpm, t, wave='pulse', duty=0.125, vol=0.14, vib=True,
              env=lambda n: adsr(n, 0.005, 0.06, 0.5, 0.05))

    for bar in range(bars):
        t = bar * 4 * spb
        at(buf, t, kick(0.15, 0.42))
        at(buf, t + 2 * spb, kick(0.13, 0.30))
        at(buf, t + spb, snare(0.13, 0.24, seed=5 + bar))
        at(buf, t + 3 * spb, snare(0.13, 0.24, seed=17 + bar))
        for k in range(8):
            at(buf, t + k * 0.5 * spb, hat(0.04, 0.07, seed=21 + bar * 8 + k))

    buf = reverb(buf, mix_level=0.08, decay=0.4)
    return write_wav('snd_mus_battle', loop_safe(buf, fade=0.04))


# ------------------------------------------------------------------ boss
def build_boss():
    """'Crown of Black Sun' — C minor with a flat fifth, 168 BPM, 24 bars."""
    bpm = 168
    bars = 24
    total = _bars(bars, bpm=bpm)
    spb = 60.0 / bpm
    buf = np.zeros(int(total * SR) + 1)

    roots = ['C2', 'C2', 'Ab1', 'Ab1', 'F1', 'F1', 'Gb1', 'Gb1']
    chords = [['C4', 'Eb4', 'G4'], ['C4', 'Eb4', 'G4'], ['Ab3', 'C4', 'Eb4'], ['Ab3', 'C4', 'Eb4'],
              ['F3', 'Ab3', 'C4'], ['F3', 'Ab3', 'C4'], ['Gb3', 'Bb3', 'Db4'], ['Gb3', 'Bb3', 'Db4']]
    for i, r in enumerate(roots * 3):
        t = i * 4 * spb
        # low drone
        at(buf, t, voice(r, 4 * spb, wave='saw', vol=0.13,
                         env=lambda n: adsr(n, 0.02, 0.2, 0.75, 0.2)))
        # tom pattern
        for k in range(4):
            at(buf, t + k * spb, timpani(r[:-1] + '2', 0.42, 0.22 if k % 2 else 0.3))
        # choir-ish pad
        for n in chords[i % len(chords)]:
            at(buf, t, voice(n, 4 * spb, wave='sine', vol=0.09, detune=0.003,
                             env=lambda k: adsr(k, 0.25, 0.3, 0.7, 0.35)))

    horn = [
        ('C4', 1.5), ('Eb4', 0.5), ('G4', 1), ('Ab4', 1),
        ('G4', 1.5), ('Eb4', 0.5), ('C4', 2),
        ('Ab3', 1.5), ('C4', 0.5), ('Eb4', 1), ('F4', 1),
        ('Gb4', 2), ('F4', 1), ('Eb4', 1),
    ]
    for rep in range(3):
        t = rep * 8 * 4 * spb
        _play(buf, horn, bpm, t, wave='pulse', duty=0.5, vol=0.15, detune=0.006,
              env=lambda n: adsr(n, 0.03, 0.15, 0.6, 0.2))
        _play(buf, horn[:6], bpm, t + 6 * 4 * spb, wave='pulse', duty=0.5, vol=0.10, detune=0.01,
              env=lambda n: adsr(n, 0.03, 0.15, 0.6, 0.2))

    for bar in range(bars):
        t = bar * 4 * spb
        at(buf, t, kick(0.17, 0.45))
        at(buf, t + 2 * spb, kick(0.17, 0.45))
        if bar % 2 == 1:
            at(buf, t + 3.5 * spb, snare(0.14, 0.16, seed=31 + bar))
        for k in range(4):
            at(buf, t + k * spb, hat(0.05, 0.06, seed=41 + bar * 4 + k))

    buf = reverb(buf, mix_level=0.16, decay=0.55)
    return write_wav('snd_mus_boss', loop_safe(buf, fade=0.04))

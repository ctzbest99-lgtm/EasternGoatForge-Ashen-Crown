"""ASHEn CROWN — tiny chiptune synthesiser (no external deps beyond numpy).

Everything in this project's audio is generated from this file, so the music and SFX are
original to Eastern Goat Forge: no sampled or licensed material is used anywhere.

Design goals: 16-bit console palette (pulse / triangle / noise), mono 22050 Hz, loops that
join cleanly (the last sample flows into the first), and a conservative mix that leaves
headroom for the game's own volume sliders.

Run `python3 tools/audio/make_audio.py` to regenerate every asset.
"""
import os
import wave

import numpy as np

SR = 22050
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
                   'game', 'audio')


# ------------------------------------------------------------------ notes
NOTE_BASE = {'C': 0, 'C#': 1, 'Db': 1, 'D': 2, 'D#': 3, 'Eb': 3, 'E': 4, 'F': 5,
             'F#': 6, 'Gb': 6, 'G': 7, 'G#': 8, 'Ab': 8, 'A': 9, 'A#': 10, 'Bb': 10, 'B': 11}


def hz(name):
    """'A4' -> 440.0, 'C#3' -> 138.59. 'r' is a rest and returns 0."""
    if name in ('r', '', None):
        return 0.0
    i = 1
    while i < len(name) and name[i] in '#b':
        i += 1
    pitch, octave = name[:i], int(name[i:])
    midi = 12 * (octave + 1) + NOTE_BASE[pitch]
    return 440.0 * 2 ** ((midi - 69) / 12)


# ------------------------------------------------------------------ oscillators
def _phase(freq, dur, sr=SR, phase=0.0):
    n = int(round(dur * sr))
    if freq <= 0:
        return np.zeros(n)
    t = np.arange(n) / sr
    return (phase + freq * t) % 1.0


def pulse(freq, dur, duty=0.5, sr=SR):
    ph = _phase(freq, dur, sr)
    return np.where(ph < duty, 1.0, -1.0)


def triangle(freq, dur, sr=SR):
    ph = _phase(freq, dur, sr)
    return 4.0 * np.abs(ph - 0.5) - 1.0


def saw(freq, dur, sr=SR):
    return 2.0 * _phase(freq, dur, sr) - 1.0


def sine(freq, dur, sr=SR):
    return np.sin(2 * np.pi * _phase(freq, dur, sr))


def noise(dur, sr=SR, seed=1, hold=1):
    """Sample-and-hold noise: `hold` samples per value gives a fatter, console-ish hiss."""
    n = int(round(dur * sr))
    rng = np.random.default_rng(seed)
    raw = rng.uniform(-1, 1, n // hold + 2)
    return np.repeat(raw, hold)[:n]


def vibrato(wave_fn, freq, dur, depth=0.006, rate=5.5, sr=SR):
    """Frequency wobble, the cheap way: sum of detuned copies is not the same thing, so
    this varies phase directly."""
    n = int(round(dur * sr))
    t = np.arange(n) / sr
    f = freq * (1 + depth * np.sin(2 * np.pi * rate * t))
    ph = np.cumsum(f) / sr
    return wave_fn(ph)


def pulse_v(freq, dur, duty=0.5, depth=0.006, rate=5.5, sr=SR):
    ph = (np.cumsum(freq * (1 + depth * np.sin(2 * np.pi * rate * np.arange(int(dur * sr)) / sr))) / sr) % 1.0
    return np.where(ph < duty, 1.0, -1.0)


# ------------------------------------------------------------------ envelopes
def adsr(n, a=0.005, d=0.05, s=0.7, r=0.05, sr=SR):
    a_n = max(1, int(a * sr))
    d_n = max(1, int(d * sr))
    r_n = max(1, int(r * sr))
    s_n = max(0, n - a_n - d_n - r_n)
    env = np.concatenate([
        np.linspace(0, 1, a_n, endpoint=False),
        np.linspace(1, s, d_n, endpoint=False),
        np.full(s_n, s),
        np.linspace(s, 0, r_n),
    ])
    if len(env) < n:
        env = np.pad(env, (0, n - len(env)))
    return env[:n]


def pluck(n, decay=6.0, sr=SR):
    t = np.arange(n) / sr
    return np.exp(-decay * t)


def perc_env(n, attack=0.002, decay=9.0, sr=SR):
    t = np.arange(n) / sr
    a_n = max(1, int(attack * sr))
    env = np.exp(-decay * t)
    env[:a_n] *= np.linspace(0, 1, a_n)
    return env


# ------------------------------------------------------------------ voices
def voice(note, dur, wave='pulse', duty=0.5, vol=0.2, env=None, vib=0.0, detune=0.0):
    f = hz(note) * (1 + detune)
    if f <= 0:
        return np.zeros(int(round(dur * SR)))
    if wave == 'pulse':
        w = pulse_v(f, dur, duty) if vib else pulse(f, dur, duty)
    elif wave == 'tri':
        w = triangle(f, dur)
    elif wave == 'saw':
        w = saw(f, dur)
    elif wave == 'sine':
        w = sine(f, dur)
    elif wave == 'noise':
        w = noise(dur, seed=abs(hash(note)) % 9999, hold=2)
    else:
        raise ValueError(wave)
    if len(w) < int(round(dur * SR)):
        w = np.pad(w, (0, int(round(dur * SR)) - len(w)))
    e = adsr(len(w)) if env is None else (env(len(w)) if callable(env) else env[:len(w)])
    return w[:len(e)] * e * vol


# ------------------------------------------------------------------ drums
def kick(dur=0.16, vol=0.5):
    n = int(dur * SR)
    t = np.arange(n) / SR
    f = 120 * np.exp(-18 * t) + 42
    body = np.sin(2 * np.pi * np.cumsum(f) / SR)
    return body * perc_env(n, decay=16) * vol


def snare(dur=0.14, vol=0.32, seed=3):
    n = int(dur * SR)
    tone = sine(190, dur) * np.exp(-22 * np.arange(n) / SR) * 0.35
    hiss = noise(dur, seed=seed) * perc_env(n, decay=26)
    return (tone + hiss) * vol


def hat(dur=0.06, vol=0.16, seed=7):
    n = int(dur * SR)
    return noise(dur, seed=seed, hold=1) * perc_env(n, decay=60) * vol


def timpani(note='D2', dur=0.5, vol=0.42):
    f = hz(note)
    n = int(dur * SR)
    t = np.arange(n) / SR
    body = np.sin(2 * np.pi * f * t) * np.exp(-5 * t)
    body += 0.4 * np.sin(2 * np.pi * f * 1.5 * t) * np.exp(-8 * t)
    return body * vol


# ------------------------------------------------------------------ mixing
def mix(*tracks):
    n = max((len(t) for t in tracks), default=0)
    out = np.zeros(n)
    for t in tracks:
        out[:len(t)] += t
    return out


def at(buf, t, layer, gain=1.0):
    """Add `layer` into `buf` starting at time t seconds."""
    i = int(round(t * SR))
    if i >= len(buf):
        return buf
    n = min(len(layer), len(buf) - i)
    buf[i:i + n] += layer[:n] * gain
    return buf


def soft_clip(x, drive=1.0):
    return np.tanh(x * drive) / np.tanh(drive)


def lowpass(x, k=0.35):
    """One-pole low-pass; small k = duller."""
    out = np.empty_like(x)
    acc = 0.0
    for i, v in enumerate(x):
        acc += k * (v - acc)
        out[i] = acc
    return out


def reverb(x, mix_level=0.18, decay=0.55, taps=(0.031, 0.047, 0.071, 0.097), sr=SR):
    """Cheap Schroeder-ish tail: a few delayed, decaying copies. Enough to sit a lead
    in a space without the cost of a real convolution."""
    out = x.copy()
    for i, tap in enumerate(taps):
        d = int(tap * sr)
        g = decay ** (i + 1) * mix_level
        if d < len(x):
            out[d:] += x[:-d] * g
    return out


def loop_safe(x, fade=0.35):
    """Crossfade the tail into the head so the loop point is inaudible."""
    n = int(fade * SR)
    if n * 2 >= len(x):
        return x
    head = x[:n].copy()
    tail = x[-n:].copy()
    ramp = np.linspace(0, 1, n)
    x = x[:-n].copy()
    x[:n] = head * ramp + tail * (1 - ramp)
    return x


def dc_block(x, k=0.0015):
    """Remove the DC bias of narrow-duty pulses so loops do not thump at the seam."""
    out = np.empty_like(x)
    prev_in = 0.0
    prev_out = 0.0
    for i, v in enumerate(x):
        prev_out = v - prev_in + (1 - k) * prev_out
        prev_in = v
        out[i] = prev_out
    return out


def normalise(x, peak=0.72):
    m = np.max(np.abs(x)) or 1.0
    return x * (peak / m)


def write_wav(name, x, fade=False):
    os.makedirs(OUT, exist_ok=True)
    x = dc_block(soft_clip(normalise(x)))
    data = np.clip(x, -1, 1)
    pcm = (data * 32767).astype('<i2')
    path = os.path.join(OUT, name + '.wav')
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())
    return path, len(pcm) / SR

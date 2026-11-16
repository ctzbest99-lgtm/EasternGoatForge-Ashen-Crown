"""Regenerate every sound asset into game/audio/.

    python3 tools/audio/make_audio.py

Deterministic: the same code always produces byte-identical WAVs, so re-running is a no-op.
Nothing here is sampled or licensed - the tracks and effects are synthesised from scratch.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import sfx
import tracks
from synth import OUT, write_wav


def main():
    os.makedirs(OUT, exist_ok=True)
    made = []
    for name, fn in (('snd_mus_overworld', tracks.build_overworld),
                     ('snd_mus_battle', tracks.build_battle),
                     ('snd_mus_boss', tracks.build_boss)):
        path, dur = fn()
        made.append((name, dur))

    for fn in sfx.BUILDERS:
        name, buf = fn()
        path, dur = write_wav(name, buf)
        made.append((name, dur))

    total = 0.0
    for name, dur in made:
        size = os.path.getsize(os.path.join(OUT, name + '.wav'))
        total += size / 1024.0 / 1024.0
        print(f'{name:26s} {dur:6.2f}s  {size / 1024:7.1f} KiB')
    print(f'\n{len(made)} assets, {total:.1f} MiB total')


if __name__ == '__main__':
    main()

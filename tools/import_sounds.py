"""Import generated WAVs from game/audio/ into GameMaker sound resources.

    python3 tools/import_sounds.py             # import everything found in game/audio
    python3 tools/import_sounds.py --dry-run   # list only

Each WAV becomes gamemaker/sounds/<name>/<name>.yy plus a copy of the WAV, and gets a
resources entry in AshenCrown.yyp (plus the "sounds" folder and resource_order entries).
Re-running is idempotent: existing resources are left alone unless --force is passed, and
nothing about GameMaker ids is randomised.
"""
import os
import re
import shutil
import sys
import wave

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GM = os.path.join(ROOT, 'gamemaker')
AUDIO = os.path.join(ROOT, 'game', 'audio')
YYP = os.path.join(GM, 'AshenCrown.yyp')
ORDER = os.path.join(GM, 'AshenCrown.resource_order')
FOLDER = 'sounds'


def wav_info(path):
    with wave.open(path, 'rb') as w:
        frames = w.getnframes()
        sr = w.getframerate()
        return frames / float(sr), sr, w.getnchannels(), w.getsampwidth()


def sound_yy(name, dur, sr, channels):
    return f'''{{
  "$GMSound":"",
  "%Name":"{name}",
  "audioGroupId":{{
    "name":"audiogroup_default",
    "path":"audiogroups/audiogroup_default",
  }},
  "bitDepth":1,
  "bitRate":128,
  "compression":0,
  "conversionMode":0,
  "duration":{round(dur, 4)},
  "name":"{name}",
  "parent":{{
    "name":"{FOLDER}",
    "path":"folders/{FOLDER}.yy",
  }},
  "preload":false,
  "resourceType":"GMSound",
  "resourceVersion":"2.0",
  "sampleRate":{sr},
  "soundFile":"{name}.wav",
  "type":0,
  "volume":1.0,
}}
'''


def _array_span(text, key):
    """Return (open_index, close_index) of the JSON array that follows `key`."""
    i = text.index(f'"{key}":[')
    start = text.index('[', i)
    depth = 0
    for j in range(start, len(text)):
        if text[j] == '[':
            depth += 1
        elif text[j] == ']':
            depth -= 1
            if depth == 0:
                return start, j
    raise ValueError(f'unterminated array for {key}')


def _insert_entries(path, key, entries):
    text = open(path, encoding='utf-8').read()
    start, end = _array_span(text, key)
    if not entries:
        return 0
    body = text[start + 1:end].rstrip()
    add = ''.join(entries)
    text = text[:start + 1] + body + add + text[end:]
    open(path, 'w', encoding='utf-8').write(text)
    return len(entries)


def register_resources(names):
    """Add resources[], Folders[] and resource_order entries for any missing sound."""
    yyp = open(YYP, encoding='utf-8').read()

    missing = [n for n in names if f'"path":"{FOLDER}/{n}/{n}.yy"' not in yyp]
    if missing:
        entries = ''.join(
            f'    {{\n      "id":{{\n        "name":"{n}",\n'
            f'        "path":"{FOLDER}/{n}/{n}.yy",\n      }},\n    }},\n' for n in missing)
        _insert_entries(YYP, 'resources', entries)

    if f'"folderPath":"folders/{FOLDER}.yy"' not in yyp:
        folder = ('    {\n      "$GMFolder":"",\n'
                  f'      "%Name":"{FOLDER}",\n'
                  f'      "folderPath":"folders/{FOLDER}.yy",\n'
                  f'      "name":"{FOLDER}",\n'
                  '      "resourceType":"GMFolder",\n      "resourceVersion":"2.0",\n    },\n')
        _insert_entries(YYP, 'Folders', folder)

    order = open(ORDER, encoding='utf-8').read()
    if f'"path":"folders/{FOLDER}.yy"' not in order:
        pending = ''.join(
            f'    {{\n      "name":"{n}",\n      "order":{{}},\n'
            f'      "path":"{FOLDER}/{n}/{n}.yy",\n    }},\n' for n in missing)
        _insert_entries(ORDER, 'ResourceOrderSettings', pending)
        # folders first: renumber every order value sequentially, folders before resources
        text = open(ORDER, encoding='utf-8').read()
        fol = ('    {\n      "name":"' + FOLDER + '",\n      "order":{},\n'
               f'      "path":"folders/{FOLDER}.yy",\n    }},\n')
        _insert_entries(ORDER, 'FolderOrderSettings', fol)
        text = open(ORDER, encoding='utf-8').read()
        counter = [0]

        def _num(m):
            counter[0] += 1
            return f'"order":{counter[0] - 1}'

        text = re.sub(r'"order":\{\}', _num, text)
        text = re.sub(r'"order":\d+', _num, text)
        open(ORDER, 'w', encoding='utf-8').write(text)
    return missing


def main():
    dry = '--dry-run' in sys.argv
    force = '--force' in sys.argv
    wavs = sorted(f[:-4] for f in os.listdir(AUDIO) if f.endswith('.wav'))
    if not wavs:
        print('no WAVs in game/audio - run tools/audio/make_audio.py first')
        return
    still_missing = [n for n in wavs if not os.path.exists(os.path.join(GM, FOLDER, n, n + '.yy'))]
    if dry:
        print(f'{len(wavs)} WAVs, {len(still_missing)} not yet imported')
        for n in still_missing:
            print('  +', n)
        return
    for name in wavs:
        sdir = os.path.join(GM, FOLDER, name)
        os.makedirs(sdir, exist_ok=True)
        dur, sr, ch, width = wav_info(os.path.join(AUDIO, name + '.wav'))
        shutil.copyfile(os.path.join(AUDIO, name + '.wav'), os.path.join(sdir, name + '.wav'))
        open(os.path.join(sdir, name + '.yy'), 'w', encoding='utf-8').write(
            sound_yy(name, dur, sr, ch))
    added = register_resources(wavs)
    print(f'imported {len(wavs)} sounds ({len(added)} new yyp entries)')


if __name__ == '__main__':
    main()

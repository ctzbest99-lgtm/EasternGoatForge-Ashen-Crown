"""Import generated PNGs from game/sprites/ into GameMaker sprite resources.

Usage (from the repo root):
    python3 tools/import_sprites.py            # import everything in MANIFEST
    python3 tools/import_sprites.py --dry-run  # list what would be created

Each sprite becomes gamemaker/sprites/<name>/<name>.yy plus one PNG per frame (named by
frame UUID) and layers/<layer-uuid>/<layer-uuid>.png, and gets a sprites entry in
AshenCrown.yyp. Frame and layer UUIDs are derived with uuid5 from the sprite name, so
re-running this tool repoints nothing and never churns resource IDs.

Origin: overworld sets sit on their feet (origin 7 = bottom centre, matching the other
16x24 sets); battle strips use the same bottom-centre anchor; portraits are top-left
(origin 0) like the existing spr_portrait_* resources.
"""
import json
import os
import re
import sys
import uuid

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GM = os.path.join(ROOT, 'gamemaker')
SRC = os.path.join(ROOT, 'game', 'sprites')
NS = uuid.UUID('6f3c9a52-0f61-4d3f-9d5a-2a1c8f0e5b11')

PARTY = ('sera', 'caelan', 'lyra')
BATTLE = (  # stem suffix, frame width, height, frame count, folder
    ('idle_strip4', 32, 48, 4),
    ('walk_strip8', 32, 48, 8),
    ('attack_strip6', 48, 48, 6),
    ('hurt_strip3', 32, 48, 3),
    ('defend_strip3', 32, 48, 3),
    ('death_strip6', 48, 48, 6),
)
PORTRAITS = [('lyra',), ('caelan',), ('sera',)]

# Engine marker sprites that were shipped as flat single-colour blocks and are redrawn by
# game/sprites/src/markers.py. They are refreshed in place only: each already has a resource
# and an id, so the manifest keeps them out of a normal import run.
MARKERS = [
    ('spr_solid_placeholder', 16, 16),
    ('spr_interactable_placeholder', 16, 16),
    ('spr_story_npc_placeholder', 16, 16),
    ('spr_player_placeholder', 16, 24),
    ('spr_respawn_point_placeholder', 16, 16),
    ('spr_encounter_trigger_placeholder', 16, 16),
    ('spr_encounter_zone_placeholder', 16, 16),
    ('spr_story_trigger_placeholder', 16, 16),
    ('spr_story_encounter_placeholder', 16, 16),
    ('spr_trap_plate_placeholder', 16, 16),
]
EXPRS = ('neutral', 'determined', 'pained')


def manifest():
    """(resource name, png path, frame w, frame h, frames, origin mode)"""
    out = []
    for ch in PARTY:
        for d in ('down', 'up', 'left', 'right'):
            out.append((f'spr_{ch}_ow16_idle_{d}',
                        f'npcs/{ch}/spr_{ch}_ow16_idle_{d}.png', 16, 24, 1, 'feet'))
            out.append((f'spr_{ch}_ow16_walk_{d}_strip4',
                        f'npcs/{ch}/spr_{ch}_ow16_walk_{d}_strip4.png', 16, 24, 4, 'feet'))
        for suffix, fw, fh, n in BATTLE:
            out.append((f'spr_{ch}_{suffix}', f'party/{ch}/spr_{ch}_{suffix}.png',
                        fw, fh, n, 'feet'))
    for (ch,) in PORTRAITS:
        for e in EXPRS:
            out.append((f'spr_portrait_{ch}_{e}', f'portraits/{ch}/spr_portrait_{ch}_{e}.png',
                        48, 48, 1, 'topleft'))
    for name, w, h in MARKERS:
        out.append((name, f'ui/markers/{name}.png', w, h, 1, 'topleft'))
    return out


def uid(*parts):
    return str(uuid.uuid5(NS, ':'.join(parts)))


def sprite_yy(name, w, h, nframes, origin_mode, frame_ids, layer_id):
    def frame_entry(fid):
        return {
            '$GMSpriteFrame': '',
            '%Name': fid,
            'name': fid,
            'resourceType': 'GMSpriteFrame',
            'resourceVersion': '2.0',
        }

    keyframes = []
    for i, fid in enumerate(frame_ids):
        keyframes.append({
            '$Keyframe<SpriteFrameKeyframe>': '',
            'Channels': {'0': {
                '$SpriteFrameKeyframe': '',
                'Id': {'name': fid, 'path': f'sprites/{name}/{name}.yy'},
                'resourceType': 'SpriteFrameKeyframe',
                'resourceVersion': '2.0',
            }},
            'Disabled': False,
            'id': uid(name, 'key', str(i)),
            'IsCreationKey': False,
            'Key': float(i),
            'Length': 1.0,
            'resourceType': 'Keyframe<SpriteFrameKeyframe>',
            'resourceVersion': '2.0',
            'Stretch': False,
        })

    xo, yo = (w // 2, h - 1) if origin_mode == 'feet' else (0, 0)
    return {
        '$GMSprite': '',
        '%Name': name,
        'bboxMode': 1,
        'bbox_bottom': h - 1,
        'bbox_left': 0,
        'bbox_right': w - 1,
        'bbox_top': 0,
        'collisionKind': 1,
        'collisionTolerance': 0,
        'DynamicTexturePage': False,
        'edgeFiltering': False,
        'For3D': False,
        'frames': [frame_entry(f) for f in frame_ids],
        'gridX': 0,
        'gridY': 0,
        'height': h,
        'HTile': False,
        'layers': [{
            '$GMImageLayer': '',
            '%Name': layer_id,
            'blendMode': 0,
            'displayName': 'default',
            'isLocked': False,
            'name': layer_id,
            'opacity': 100.0,
            'resourceType': 'GMImageLayer',
            'resourceVersion': '2.0',
            'visible': True,
        }],
        'name': name,
        'nineSlice': None,
        'origin': 0 if origin_mode == 'topleft' else 7,
        'parent': {'name': 'sprites', 'path': 'folders/sprites.yy'},
        'preMultiplyAlpha': False,
        'resourceType': 'GMSprite',
        'resourceVersion': '2.0',
        'sequence': {
            '$GMSequence': '',
            '%Name': name,
            'autoRecord': True,
            'backdropHeight': 1080,
            'backdropImageOpacity': 0.5,
            'backdropImagePath': '',
            'backdropWidth': 1920,
            'backdropXOffset': 0.0,
            'backdropYOffset': 0.0,
            'eventStubScript': None,
            'eventToFunction': {},
            'events': {
                '$KeyframeStore<MessageEventKeyframe>': '',
                'Keyframes': [],
                'resourceType': 'KeyframeStore<MessageEventKeyframe>',
                'resourceVersion': '2.0',
            },
            'length': float(nframes),
            'lockOrigin': False,
            'moments': {
                '$KeyframeStore<MomentsEventKeyframe>': '',
                'Keyframes': [],
                'resourceType': 'KeyframeStore<MomentsEventKeyframe>',
                'resourceVersion': '2.0',
            },
            'name': name,
            'playback': 1,
            'playbackSpeed': 0.0,
            'playbackSpeedType': 0,
            'resourceType': 'GMSequence',
            'resourceVersion': '2.0',
            'showBackdrop': True,
            'showBackdropImage': False,
            'timeUnits': 1,
            'visibleRange': None,
            'volume': 1.0,
            'xorigin': xo,
            'yorigin': yo,
            'tracks': [{
                '$GMSpriteFramesTrack': '',
                'builtinName': 0,
                'events': [],
                'inheritsTrackColour': True,
                'interpolation': 1,
                'isCreationTrack': False,
                'keyframes': {
                    '$KeyframeStore<SpriteFrameKeyframe>': '',
                    'Keyframes': keyframes,
                    'resourceType': 'KeyframeStore<SpriteFrameKeyframe>',
                    'resourceVersion': '2.0',
                },
                'modifiers': [],
                'name': 'frames',
                'resourceType': 'GMSpriteFramesTrack',
                'resourceVersion': '2.0',
                'spriteId': None,
                'trackColour': 0,
                'tracks': [],
                'traits': 0,
            }],
        },
        'swatchColours': None,
        'swfPrecision': 2.525,
        'textureGroupId': {'name': 'Default', 'path': 'texturegroups/Default'},
        'type': 0,
        'VTile': False,
        'width': w,
    }


def _yy_frames(name):
    """Frame ids + layer id already recorded for an existing sprite resource."""
    path = os.path.join(GM, 'sprites', name, name + '.yy')
    text = open(path, encoding='utf-8').read()
    start = re.search(r'"frames"\s*:\s*\[', text).end()
    end = re.search(r'"gridX"', text).start()
    frames = re.findall(r'"name"\s*:\s*"([0-9a-f-]{36})"', text[start:end])
    lstart = re.search(r'"layers"\s*:\s*\[', text).end()
    layer = re.findall(r'"name"\s*:\s*"([0-9a-f-]{36})"', text[lstart:])[0]
    return frames, layer


def refresh_sprite(name, png, fw, fh, n, origin_mode):
    """Rewrite the pixels of an already-imported sprite, keeping every id in its .yy.
    Used when a generator improves the art: the resource keeps its frames, layer, origin
    and yyp entry, only the PNGs change."""
    src = os.path.join(SRC, png)
    im = Image.open(src).convert('RGBA')
    if im.width != fw * n or im.height != fh:
        raise SystemExit(f'{name}: {src} is {im.size}, expected {fw * n}x{fh}')
    frames, layer_id = _yy_frames(name)
    if len(frames) != n:
        raise SystemExit(f'{name}: resource has {len(frames)} frames, art has {n}')
    d = os.path.join(GM, 'sprites', name)
    for i, fid in enumerate(frames):
        cell = im.crop((i * fw, 0, (i + 1) * fw, fh))
        cell.save(os.path.join(d, fid + '.png'))
        ld = os.path.join(d, 'layers', fid)
        os.makedirs(ld, exist_ok=True)
        cell.save(os.path.join(ld, layer_id + '.png'))
    return name


def write_sprite(name, png, fw, fh, n, origin_mode):
    src = os.path.join(SRC, png)
    im = Image.open(src).convert('RGBA')
    if im.width != fw * n or im.height != fh:
        raise SystemExit(f'{name}: {src} is {im.size}, expected {fw * n}x{fh}')
    d = os.path.join(GM, 'sprites', name)
    os.makedirs(os.path.join(d, 'layers'), exist_ok=True)
    layer_id = uid(name, 'layer')
    frame_ids = []
    for i in range(n):
        fid = uid(name, 'frame', str(i))
        frame_ids.append(fid)
        cell = im.crop((i * fw, 0, (i + 1) * fw, fh))
        cell.save(os.path.join(d, fid + '.png'))
        ld = os.path.join(d, 'layers', fid)
        os.makedirs(ld, exist_ok=True)
        cell.save(os.path.join(ld, layer_id + '.png'))
    with open(os.path.join(d, name + '.yy'), 'w', encoding='utf-8', newline='\n') as fh_:
        json.dump(sprite_yy(name, fw, fh, n, origin_mode, frame_ids, layer_id),
                  fh_, indent=2)
        fh_.write('\n')
    return name


def register_in_yyp(names):
    yyp_path = os.path.join(GM, 'AshenCrown.yyp')
    text = open(yyp_path, encoding='utf-8').read()
    added = []
    for name in names:
        rel = f'sprites/{name}/{name}.yy'
        if f'"{rel}"' in text:
            continue
        anchor = '"path":"sprites/spr_lyra_idle_strip4/spr_lyra_idle_strip4.yy",\n      },\n    },'
        block = (anchor + '\n    {\n      "id":{\n        "name":"' + name +
                 '",\n        "path":"' + rel + '",\n      },\n    },')
        if anchor not in text:
            raise SystemExit('yyp anchor for sprite registration not found')
        text = text.replace(anchor, block, 1)
        added.append(name)
    if added:
        open(yyp_path, 'w', encoding='utf-8', newline='\n').write(text)
    return added


def main(argv):
    dry = '--dry-run' in argv
    refresh = '--refresh' in argv
    made = []
    for name, png, fw, fh, n, om in manifest():
        if dry:
            print(f'{name:34s} <- {png} ({n}x {fw}x{fh}) {om}')
            continue
        exists = os.path.exists(os.path.join(GM, 'sprites', name, name + '.yy'))
        if refresh and exists:
            made.append(refresh_sprite(name, png, fw, fh, n, om))
        else:
            made.append(write_sprite(name, png, fw, fh, n, om))
    if refresh:
        print(f'refreshed pixels of {len(made)} sprite resources (no yyp changes)')
        return 0
    if dry:
        return 0
    added = register_in_yyp(made)
    print(f'wrote {len(made)} sprite resources, {len(added)} new yyp entries')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

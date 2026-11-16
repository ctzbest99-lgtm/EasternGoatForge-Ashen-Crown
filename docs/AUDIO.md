# Audio

ASHEN CROWN had no audio. As of 2026-11-16 it has 29 original assets: three music loops, 20
effects and six ambience beds, all **synthesised from scratch** by `tools/audio/` — there are
no samples, no purchased packs and no licensed material anywhere in `game/audio/`.

Everything is the property of Eastern Goat Forge, so the "verify rights/licenses" gap on the
old asset list is closed for audio.

## How it is made

| File | Role |
|---|---|
| `tools/audio/synth.py` | Oscillators (pulse with duty, triangle, saw, sine, sample-and-hold noise), ADSR / pluck / percussive envelopes, vibrato, drums (kick, snare, hat, timpani), mixing, soft clip, DC blocker, reverb, loop-safe crossfade, WAV writer. |
| `tools/audio/tracks.py` | The three compositions, written as note tables (chords, bass, melody, drum grid). |
| `tools/audio/sfx.py` | Every effect and ambience bed, each built from the synth primitives. |
| `tools/audio/make_audio.py` | Writes all 29 WAVs into `game/audio/`. Deterministic: a re-run produces byte-identical files. |
| `tools/import_sounds.py` | Turns each WAV into a GameMaker sound resource (`gamemaker/sounds/<name>/<name>.yy` + the WAV) and registers it in `AshenCrown.yyp`, the `sounds` folder and `AshenCrown.resource_order`. Idempotent. |

Format: **22050 Hz, mono, 16-bit PCM, uncompressed** (`compression: 0`, `bitDepth: 1`,
`type: 0`, audio group `audiogroup_default`). That is deliberate — a chiptune palette gains
nothing from 44.1 kHz stereo, and the whole set is 7.7 MiB.

Regenerate everything:

```bash
python3 tools/audio/make_audio.py     # writes game/audio/*.wav
python3 tools/import_sounds.py        # creates/refreshes the GameMaker resources
python3 validate_gamemaker.py
```

## Music

| Asset | Length | Key / tempo | Use |
|---|---|---|---|
| `snd_mus_overworld` — "The Ashen Road" | 39.96 s | D dorian, 96 BPM, 16 bars | Field, towns, interiors, title screen. Plucked 25% pulse lead with vibrato over a walking triangle bass, soft chord pad, percussion enters at bar 5. |
| `snd_mus_battle` — "Steel and Ash" | 37.85 s | E minor, 152 BPM, 24 bars | Ordinary encounters. Eighth-note pulse bass, detuned brass stabs, 12.5% pulse lead, snare backbeat. |
| `snd_mus_boss` — "Crown of Black Sun" | 34.25 s | C minor with a flat fifth (Gb), 168 BPM, 24 bars | Boss fights. Detuned saw drone, timpani, sine "choir" pad, 50% pulse horn line. |

All three are looped with `audio_play_sound(..., true)` and are rendered to an exact bar
length so the loop point lands on a bar line. Each loop also gets a 40 ms crossfade of its tail into its head, which puts the measured
seam discontinuity at 0.005–0.007 of full scale — below one sample step for these
waveforms — so the loop does not click. The loss is 40 ms of the final bar; the loop stays
bar-aligned in practice.

## Ambient beds (loops)

| Asset | Length | Where |
|---|---|---|
| `snd_amb_wind` | 9.65 s | Overworld, Millhaven road, Valemere and its road, Hollow approach, old watchtower |
| `snd_amb_forest` | 11.50 s | Wrenfield, Blackwood garrison |
| `snd_amb_dungeon` | 11.50 s | Watchtower basement, warehouse, Hollow sanctuary, Greyhaven chapel |
| `snd_amb_fire` | 9.60 s | Greyhaven tavern, blacksmith, Varyn's house, the Bent Post, the Salt Lamp, garrison keep |
| `snd_amb_water` | 9.60 s | *Unused for now* — for the flooded ruins and the Saltreach pier |
| `snd_amb_night` | 11.50 s | *Unused for now* — for night-time scenes (crickets) |

The beds are rendered 0.4–0.5 s longer than their loop length, then the tail is crossfaded
into the head, so they can sit under a room indefinitely without a seam.

## Character / battle effects

| Asset | Length | Plays when |
|---|---|---|
| `snd_sfx_attack_swing` | 0.22 s | A party Attack resolves (`scr_audio_skill_cue`, `_sk.id == "attack"`) |
| `snd_sfx_hit` | 0.18 s | Any damaging skill or attack lands |
| `snd_sfx_hit_crit` | 0.34 s | The same, when at least one target crit |
| `snd_sfx_guard` | 0.30 s | A member takes the Guard command |
| `snd_sfx_cast` | 0.55 s | Status / buff / non-damaging skill resolves |
| `snd_sfx_heal` | 0.80 s | A healing skill resolves |
| `snd_sfx_arrow` | 0.20 s | A ranged release: the Ashbound Hunter attacks, or any `crossbow_bolt` resolves (`scr_audio_skill_cue`, actor id passed from `run_skill`) |
| `snd_sfx_enemy_fall` | 0.60 s | A non-yielding enemy's death clip starts (`apply_pending_hit`) |
| `snd_sfx_party_hurt` | 0.22 s | A party member takes damage (`apply_pending_hit`) |
| `snd_sfx_level_up` | 1.10 s | A victory that produced at least one level-up |
| `snd_sfx_step` | 0.08 s | Generated, deliberately **not** hooked (a footstep tick every tile is fatiguing) |

## Menu / UI effects

| Asset | Length | Plays when |
|---|---|---|
| `snd_sfx_menu_move` | 0.06 s | Adventure menu cursor move |
| `snd_sfx_menu_confirm` | 0.22 s | Confirm press in the Adventure menu |
| `snd_sfx_menu_cancel` | 0.20 s | Cancel press in the Adventure menu |
| `snd_sfx_menu_open` | 0.32 s | The Adventure menu opens (`obj_adventure_menu` Create, gain 0.8) |
| `snd_sfx_menu_error` | 0.26 s | A shop refuses a buy or sell (`scr_shop_buy` / `scr_shop_sell`: no gold, key item, nothing to sell) |
| `snd_sfx_save` | 0.90 s | A save slot is written |
| `snd_sfx_item_get` | 0.45 s | Loot or a pickup adds an item |
| `snd_sfx_coin` | 0.30 s | Loot grants gold |
| `snd_sfx_text` | 0.03 s | A dialogue box opens and each page advance (gain 0.6–0.7, quiet) |

## Settings and the Options screen

Gains live in `global.audio_ctx` (`master`, `music_gain`, `amb_gain`, `sfx_gain`, `muted`) and are changed through `scr_audio_set_gain(kind, value)` or `scr_audio_mute(on)`. `scr_audio_get_gain(kind)` reads one back.

The title screen's **Options** entry is the only UI for them so far: Music, Ambience, Sound effects and Mute, left/right in 5% steps. Every change is written immediately to `ashen_settings.ini` in the game's sandbox save area (`scr_audio_settings_save()`), and `scr_audio_settings_load()` runs once in `obj_title`'s Create, so the mix survives a restart. A missing or unreadable file keeps the compiled-in defaults — the game is never silent on a first run.

There is no in-game Options entry yet: the Adventure menu still has no settings page, so a player who wants to change the mix mid-chapter has to return to the title screen.

## Code

`game/scripts/scr_audio.gml` (mirrored to `gamemaker/scripts/scr_audio/`):

| Function | Purpose |
|---|---|
| `scr_audio_init()` | Creates `global.audio_ctx` (volumes, current keys, instance ids, asset cache). Called from `obj_game_controller : Create`. |
| `scr_audio_sound(name)` | Resolves `snd_sfx_*` / `snd_mus_*` / `snd_amb_*` by short key, cached. Returns -1 when the asset is missing. |
| `scr_audio_sfx(name, pitch_var, gain)` | One-shot with optional pitch variation. No-ops if the asset or context is missing. |
| `scr_audio_music(key)` | Switches the loop: `"overworld"`, `"battle"`, `"boss"`, `""`. Re-requesting the same key does nothing, so re-entering a room never restarts the track. |
| `scr_audio_ambience(key)` | Same for beds: `wind`, `forest`, `dungeon`, `fire`, `water`, `night`, `""`. |
| `scr_audio_room_enter(room)` | Room → music + ambience. Battle room picks `"boss"` when `pending_battle.boss_index >= 0`. |
| `scr_audio_skill_cue(sk, hit, side)` | Effect → SFX mapping for a resolved skill. |
| `scr_audio_set_gain(kind, 0..1)` / `scr_audio_mute(on)` | Hooks for a future options screen; nothing calls them yet. |

Gains: master 1.0, music 0.55, ambience 0.30, SFX 0.80, so music sits under effects without
a ducking system. Change them in `scr_audio.gml` or through `scr_audio_set_gain`.

### Hook points

- `obj_game_controller : Create` → `scr_audio_init()`
- `obj_game_controller : Room Start` → `scr_audio_room_enter(room)` (fires before the
  battle/title early exits, so battle and boss music are chosen here)
- `obj_battle_controller`, `run_skill` → `scr_audio_skill_cue(...)` just before `begin_anim`
- `obj_battle_controller : Step` → guard cue, level-up cue
- `obj_adventure_menu : Step` → move / confirm / cancel
- `obj_dialogue_box : Create` and `: Step` → page blip
- `obj_save_menu : Step` → save chime
- `scr_inventory.gml` → `item_get` / `coin` on loot

## Not verified in engine

There is no GameMaker IDE here. The WAVs have been measured (durations, peak ≈ 0.81–0.86,
no clipping, DC ≈ 0, loop seam ≤ one sample step) and every key used in GML resolves to a
resource, but **nobody has heard them play in GameMaker**, and the sound-resource `.yy`
schema was written by hand from the GameMaker 2024 format rather than exported by the IDE.
The first IDE open should confirm:

1. All 29 sounds appear under Sounds → `sounds`, and each plays from the Sound editor.
2. Music loops seamlessly at the room start, battle transition and return.
3. Boss fights (e.g. the Blackguard) use `snd_mus_boss`; ordinary fights use `snd_mus_battle`.
4. Menu, save and loot cues do not stack or double-fire.
5. The ambience bed stops in battle and resumes on return.

If a field name in the sound `.yy` is wrong for this GameMaker version, re-importing the WAVs
through the IDE fixes it without touching the compositions, and `tools/import_sounds.py`
stays the source of truth for names and durations.

## Mixing notes and known limits

- The three tracks share a palette but no melodic material; the boss theme is the only one in
  a minor key with a flat fifth, so it is recognisably "the bad one".
- Music is mono and 22.05 kHz. That is a deliberate 16-bit-console choice, not a placeholder,
  but if the project later wants orchestral audio it should be re-authored, not resampled.
- `snd_amb_water` and `snd_amb_night` are finished and imported but not yet assigned to a room
  (`rm_flooded_ruins`, `rm_saltreach_pier` and night scenes do not exist yet).
- Every effect is hooked except `step`, which stays unused on purpose (a tick every tile is
  fatiguing). `arrow` is keyed off the attacking actor and skill rather than added as a new bow
  skill, so no balance data changed to make the sound play.
- No voice, no jingle for game over, no fanfare for victory (the level-up chime covers the
  level-up screen only).

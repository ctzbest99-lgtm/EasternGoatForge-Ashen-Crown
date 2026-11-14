# Zone 1 sprites (GameMaker)
All strips face right, real alpha, frames edge-to-edge, no padding. Feet sit on row 47 in every frame.
Import: Sprite Editor > Import > pick the PNG; the `_stripN` suffix auto-splits it.

| Sprite | Frames | Frame size | Origin |
|---|---|---|---|
| spr_hero_idle/walk/attack/hurt | 4/8/6/3 | 32x48 | (16,47) |
| spr_hero_death_strip6 | 6 | 48x48 | (16,47) |
| spr_bandit_idle/walk/attack/hurt | 4/4/6/4 | 32x48 | (16,47) |
| spr_bandit_death_strip6 | 6 | 48x48 | (16,47) |
| spr_fallen_knight_idle/walk/hurt | 8/8/6 | 32x48 | (16,47) |
| spr_fallen_knight_attack_strip6 | 6 | 64x48 | (32,47) |
| spr_fallen_knight_death_strip8 | 8 | 48x48 | (16,47) |

Death strips are 48 wide so the body can fall flat. They fall forward to the right of the origin.
The knight's attack is 64 wide: 16px of wind-up space behind and 32px of reach in front.
Use a fixed collision mask, such as the idle frame bbox, so the wider strips don't change hitboxes.
Source: src/*.py (Python + Pillow). Run `python3 src/hero.py` etc. to regenerate.

## Overworld (top-down, FF1-style exploration)
Each character has 4 directions, a 1-frame idle and a 4-frame walk loop: step, pass, other step, pass. Play the walk at about 6–8 fps.
Feet sit on the bottom row of every frame. `left` is a hand-mirrored copy of `right`, so you don't need image_xscale.

| Set | Folder | Frame | Origin | Tile footprint (16x16 tiles) |
|---|---|---|---|---|
| Kael 32x48 | hero/overworld/ | 32x48 | (16,47) | 2 wide x 3 tall |
| Kael 16x24 (FF1 scale) | hero/overworld/16x24/ | 16x24 | (8,23) | 1 wide x 1.5 tall |
| Bandit 32x48 | bandit/overworld/ | 32x48 | (16,47) | 2 wide x 3 tall |
| Bandit 16x24 (FF1 scale) | bandit/overworld/16x24/ | 16x24 | (8,23) | 1 wide x 1.5 tall |

Names: `spr_kael_ow_idle_<dir>.png`, `spr_kael_ow_walk_<dir>_strip4.png`, and the same with `ow16` for the small set. The Bandit uses `spr_bandit_ow...`.
`<dir>` is down, up, left or right.
On a 16px grid, the 16x24 sprites stand on their tile, and their head overlaps the tile above. Draw them sorted by y (`depth = -y`).
Kael's longsword is sheathed on his hip in the overworld; the Bandit carries his knife low.
Previews: `*_ow_preview.png` (6x) and `*_ow16_preview.png` (8x). The `*_walk_preview.gif` files animate down, left, right and up side by side.
Source: src/kael_ow.py and src/bandit_ow.py, with shared helpers in src/ow_common.py.

## The Blackguard (Zone 1 boss)
A former Royal Knight corrupted by the Ash (STORY_BIBLE 5.13 / GDD Part 12), drawn in his Phase 1 "The Knight" look: armour, longsword and kite shield.
To set him apart from the Fallen Knight (rounded dark-steel helm, red eyes, red cloak, two-handed greatsword), he has:
- black-lacquered plate with tarnished gold trim, and a flat-topped great helm with a gold crown circlet;
- a T-visor that glows ember orange, and a long ash-grey horsehair plume;
- a royal-purple tabard;
- a kite shield bearing the gold crown crest;
- glowing ember cracks in the plate, with ash flecks drifting off him.
He is larger than everyone else, on a 48x64 boss frame.

### Battle strips (`blackguard/`)
| Sprite | Frames | Frame size | Origin |
|---|---|---|---|
| spr_blackguard_idle_strip8 | 8 | 48x64 | (24,63) |
| spr_blackguard_walk_strip8 | 8 | 48x64 | (24,63) |
| spr_blackguard_attack_strip6 (Heavy Slash) | 6 | 96x64 | (40,63) |
| spr_blackguard_shieldbash_strip8 (Shield Bash, special) | 8 | 96x64 | (40,63) |
| spr_blackguard_hurt_strip6 | 6 | 48x64 | (24,63) |
| spr_blackguard_death_strip8 | 8 | 64x64 | (24,63) |

The origin always sits under the body's centre, so switching between strips never makes him jump. The wide frames add 16px behind him and 32px in front for the swing and the bash.
Death follows the canon ending "collapses into ash and empty armor":
1. He staggers.
2. He drops to one knee with his sword planted.
3. His visor glow dies out.
4. His body crumbles away into ash.
5. All that's left is his helm, a pauldron and the shield on an ash mound, with the sword still standing.

GIFs: blackguard_{idle,walk,attack,shieldbash,death}_preview.gif. Sheet: blackguard_preview.png (6x).

### Overworld / arena (`blackguard/overworld/`, `blackguard/overworld/16x24/`)
Each direction (down, up, left, right) has a 1-frame idle and a 4-frame walk.
- `spr_blackguard_ow_*`: 32x48, origin (16,47).
- `spr_blackguard_ow16_*`: 16x24, origin (8,23).

The down view shows the sword on his right hand and the shield on his left arm. The up view shows the plume down his back and the back of the shield.
The left set is mirrored from the right, so the shield and sword swap hands, as with every other mirrored sprite.

### Blackguard palette (19 colours)
| key | hex | use |
|---|---|---|
| o | #0E0B10 | outline |
| k | #1C1A22 | black plate, dark |
| K | #2E2C38 | black plate, mid |
| A | #4A4858 | black plate, light |
| S | #7A7890 | plate sheen |
| w | #C9CCD6 | blade / bright steel |
| g | #6B4E1E | tarnished gold, dark |
| G | #A8823A | tarnished gold |
| Y | #D9B860 | gold highlight |
| a | #4D4747 | ash, dark |
| m | #7D7570 | ash, mid |
| n | #B4ACA4 | ash, light (plume) |
| e | #8A2A0E | ember, dark |
| E | #E0601A | ember |
| F | #FFC24A | ember core / visor flare |
| p | #2A1E33 | royal tabard, dark |
| P | #4A3658 | royal tabard, mid |
| l | #3A2A20 | leather, dark |
| L | #6E5038 | leather (grip, belt) |

Source: src/blackguard.py (battle) and src/blackguard_ow.py (overworld).
Phase 2 and Phase 3 are now drawn: see the next section.

## Zone 1 enemies (`enemies/<id>/`) — batch 1
Folder names and sprite prefixes match the encounter ids in /workspace/zone1 (`ash_wolf`, `ashen_wretch`, `ashbound_hunter`, `grave_spider`, `hollow_soldier`). `first_bandit` reuses the Bandit, and the Fallen Knight / Blackguard are above.
All of them face right (they stand on the left of the battle screen), with feet or paws on the bottom row of every battle frame.

| Sprite | Frames | Frame size | Origin |
|---|---|---|---|
| spr_ashen_wretch_idle/attack(Claw)/scream/hurt | 4/6/4/3 | 32x48 | (16,47) |
| spr_ashen_wretch_death_strip6 (crumbles to ash) | 6 | 48x48 | (16,47) |
| spr_ashbound_hunter_idle/attack(Ash Arrow)/hurt | 4/6/3 | 32x48 | (16,47) |
| spr_ashbound_hunter_death_strip6 | 6 | 48x48 | (16,47) |
| spr_ashbound_hunter_arrow_strip3 (projectile, origin at the tip) | 3 | 16x8 | (15,4) |
| spr_ash_wolf_idle/walk/attack(Pounce+Bite)/howl(Pack Howl)/hurt/death | 4/4/6/4/3/6 | 48x32 | (24,31) |
| spr_grave_spider_idle/walk/attack(Poison Fang)/cast(Web, Egg Sac)/hurt/death | 4/4/6/4/3/6 | 48x32 | (24,31) |
| spr_spiderling_idle/walk/attack/death (Egg Sac summon) | 4/4/4/4 | 16x16 | (8,15) |
| spr_grave_spider_web_proj_strip3 (web projectile) | 3 | 16x16 | (8,8) |
| spr_hollow_soldier_idle/walk(Last March)/attack(Rusty Slash)/guard(Shield Wall)/hurt | 4/4/6/3/3 | 32x48 | (16,47) |
| spr_hollow_soldier_death_strip6 (falls apart into a rusted armour pile) | 6 | 48x48 | (16,47) |

The 48x32 beasts are low and wide, so they use a bottom-centre origin. Death strips: the Wretch, Wolf and Spider crumble to ash or bone dust; the Hunter falls face down; the Hollow Soldier collapses into bones, helm, shield and sword.
Overworld (`enemies/<id>/overworld/`), each with a 1-frame idle and 4-frame walk per direction plus a preview and walk GIF:
- `spr_ashen_wretch_ow16_*`, `spr_ashbound_hunter_ow16_*`, `spr_hollow_soldier_ow16_*`: 16x24, origin (8,23)
- `spr_ash_wolf_ow16_*`, `spr_grave_spider_ow16_*`: 16x16 (one tile), origin (8,15)

Source: src/en_wretch.py, en_hunter.py, en_wolf.py, en_spider.py, en_hollow.py; shared helpers in src/humanoid.py (side-view humanoid rig), src/ow16.py (16x24 4-direction builder) and src/en_common.py.

## Story NPCs and portraits — batch 2
### Overworld NPCs (`npcs/<id>/`), 16x24, origin (8,23)
Each set has `spr_<id>_ow16_idle_<dir>.png` + `spr_<id>_ow16_walk_<dir>_strip4.png` for down/up/right/left (left = mirrored right), a preview (8x) and a walk GIF.
Ids `tomas_varyn`, `pell` and `fallen_knight_story` match the NPC ids in /workspace/zone1; the others use the character's name.

| id | Who | Look |
|---|---|---|
| tomas_varyn | Kael's father, ex-soldier blacksmith | bald, grey beard, worn shirt, leather smith's apron |
| pell | young survivor tending Tomas, runs the forge shop | messy dark hair, blue shirt, leather apron (script gives no gender; drawn as a teen) |
| renn | Old Hunter Renn, Hunter's Camp | fur cap, grey beard, green shirt, leather jerkin |
| hob | tavern keeper | bald, brown beard, cream shirt, white tavern apron |
| ilse | Sister Ilse, chapel keeper | white wimple, dark habit with a pale cord (no faith symbol, since her order is still unnamed) |
| marda | shopkeeper | auburn hair, green dress, pale apron |
| wenna | Old Wenna, Town Square | purple-grey headscarf, brown shawl dress |
| dov | boy about Mira's age, Town Square | child proportions, sandy hair, blue tunic |
| corwin | militia watchman, North Gate | iron cap, quilted gambeson, spear |
| fallen_knight_story | the non-hostile Fallen Knight (FK_01 / FK_02) | same design and palette as the battle Fallen Knight: round helm, red eyes, red cloak, greatsword held point-down |

Tomas on his pallet: `npcs/tomas_varyn/spr_tomas_varyn_ow16_lying_strip2.png` (16x16 x2 frames, slow breathing; play at ~1.5 fps) and `spr_tomas_varyn_ow16_lying_awake.png` (eyes open, for when he speaks). They are 16x16 with origin (8,15) and are drawn to sit exactly on the `pallet` tile (id 574) of ts_zone1.png. Place the sprite at the tile's bottom-centre (tile x+8, y+15) with depth just above the tile. `spr_tomas_varyn_lying_preview.png/.gif` shows them on the real tile.

### Dialogue portraits (`portraits/<id>/`), 48x48, origin (0,0)
| Character | Files (`spr_portrait_<name>_<expr>.png`) |
|---|---|
| Kael | neutral, determined, sad, surprised |
| Tomas | neutral (weak), pained, smile |
| Pell | neutral, worried, smile |
| Renn | neutral (gruff), smirk, stern |
| Fallen Knight | neutral, flare (eyes blaze), dim |

Busts face the viewer, lit from the upper left, with real alpha (transparent background) so they can sit on any window colour. Each folder has `*_portraits_preview.png` (4x). Use them as one sprite per expression, or import all expressions of a character as frames of one sprite and pick with image_index.
Mira has no portrait: she doesn't appear in person in Chapter 1 (only her pendant and carving).
Source: src/npc_ow.py (parts-based 16x24 NPC builder), src/portrait.py and src/portraits_ch1.py.

### Blackguard Phase 2, Phase 3 and transitions (`blackguard/phases/`) — batch 3
Same 19-colour palette and the same rig as Phase 1, so origins line up and you can swap sprite_index without the body jumping.
**Phase 2 "The Corruption"** (60% HP): the helm is cracked, with a chunk and a crown spike broken off and ember light in the crack. The plume is torn short, more ember cracks show in the breastplate, and ash pours continuously out of the helm crack and the armour joints, pooling at his feet. The shield is gone, so he holds the longsword two-handed in a low guard.
**Phase 3 "Hollow Knight"** (20% HP): the armour is crusted over with ash, with ember veins and a flickering ash aura rising off the silhouette. His eyes blaze white-gold and embers drift up around him.

| Sprite | Frames | Frame size | Origin |
|---|---|---|---|
| spr_blackguard_p2_idle_strip8 / walk_strip8 | 8/8 | 48x64 | (24,63) |
| spr_blackguard_p2_attack_strip6 (Ash Slash) | 6 | 96x64 | (40,63) |
| spr_blackguard_p2_lunge_strip6 (Dark Lunge) | 6 | 96x64 | (40,63) |
| spr_blackguard_p2_oath_strip6 (Blood Oath: plants sword, fist to chest, ember aura) | 6 | 48x64 | (24,63) |
| spr_blackguard_p2_hurt_strip4 | 4 | 48x64 | (24,63) |
| spr_blackguard_p3_idle_strip8 / walk_strip8 | 8/8 | 48x64 | (24,63) |
| spr_blackguard_p3_attack_strip5 (faster Ash Slash) | 5 | 96x64 | (40,63) |
| spr_blackguard_p3_execution_strip8 (Execution: ash-fed overhead cleave + ash pillars) | 8 | 96x64 | (40,63) |
| spr_blackguard_p3_hurt_strip4 | 4 | 48x64 | (24,63) |
| spr_blackguard_p3_death_strip8 (final death: crumbles to ash, leaving the cracked helm, a pauldron and the planted sword) | 8 | 64x64 | (24,63) |
| spr_blackguard_transition_p1to2_strip8 (helm cracks, shield slips, falls and crumbles, ash bursts out, two-handed grip) | 8 | 64x64 | (24,63) |
| spr_blackguard_transition_p2to3_strip8 (ash floods up from his feet over the armour, eyes ignite, aura burst) | 8 | 64x64 | (24,63) |

Suggested flow: when HP drops to 60%, play `transition_p1to2` once (about 10 fps), then switch to the `p2_*` set. At 20%, do the same with `transition_p2to3` and the `p3_*` set. Use `p3_death` for the final defeat (the Phase 1 `spr_blackguard_death_strip8` still has the shield and suits only a debug kill in Phase 1).
GIFs: `spr_blackguard_p2_{idle,attack,lunge,oath}_preview.gif`, `spr_blackguard_p3_{idle,execution,death}_preview.gif`, `spr_blackguard_transition_{p1to2,p2to3}_preview.gif`. Sheets: `*_preview.png` (6x).
Source: src/blackguard_phases.py.

## FF1-style menu battle screen — batch 4 (`ui/`)
Everything targets a **320x180** base resolution (16:9, scales x4 to 1280x720). Shared UI palette is in src/ui.py (`UIPAL`). Mockups: `ui/mockups/spr_mockup_battle.png` (+ `_4x`), and `spr_mockup_battle_arena_bg.png`.

### Battle backgrounds (`ui/battle_bg/`, 320x180, origin (0,0))
| Sprite | Scene |
|---|---|
| spr_bg_battle_greyhaven | Greyhaven / Farmlands: dusk sky, ruined village and chapel spire with smoke, furrowed fields, broken fence, falling ash |
| spr_bg_battle_forest | Forest / Old Road: canopy, trunks, light shafts, rutted road, weathered Crown Patrol sign |
| spr_bg_battle_bandit_camp | Abandoned Bandit Camp: palisade with a gap, "turn back" sign (second line crossed out), tents, campfire, crates |
| spr_bg_battle_watchtower | Old Watchtower interior: brick walls, arched moonlit window, faded crown banners, torches, cobwebs, plank floor |
| spr_bg_battle_blackguard_arena | Watchtower basement: pillars, braziers, ash-strewn flagstones, the sealed stone door (crown ring around a black sun) |

The horizon sits around y=84–100. Stand battlers with their feet on y≈105–125, enemies on the left (they face right) and the party on the right (draw the hero strips with `image_xscale = -1`). The bottom 52px (y 128–179) is meant to sit under the menu windows. `*_2x_preview.png` files are just previews.

### Windows, cursor, bars
| Sprite | Size | Notes |
|---|---|---|
| spr_ui_window | 24x24 | default window (navy fill, bone border, gold corner brackets). **Nine-slice: on, left/right/top/bottom = 8, mode Stretch or Repeat**, then `draw_sprite_stretched(spr_ui_window, 0, x, y, w, h)` |
| spr_ui_window_dim | 24x24 | inactive window, same nine-slice settings |
| spr_ui_window_gold | 24x24 | boss / title / important prompt, same nine-slice settings |
| spr_ui_select_bar | 24x12 | row highlight, nine-slice 3 on every side |
| spr_ui_cursor_strip2 | 16x12 x2 | pointing gauntlet; origin (15,4) (fingertip). Two frames = a 1px bob, ~4 fps |
| spr_ui_bar_frame | 50x6 | HP/MP bar frame, origin (0,0); the fill area starts at (1,1), 48x4 |
| spr_ui_bar_fill_hp / hp_low / hp_crit / mp / back | 1x4 | stretch to `48 * hp / maxhp` wide at (1,1) of the frame. Switch hp → hp_low under 50% → hp_crit under 25% |

### Fonts and numbers
- `spr_font_main_strip95`: 95 glyphs (ASCII 32 ' ' to 126 '~'), 6x10 cells, white with a 1px dark drop shadow (`spr_font_main_noshadow_strip95` has no shadow). 5x7 caps with 2-row descenders.
  ```gml
  global.fnt_main = font_add_sprite_ext(spr_font_main_strip95,
      " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~", true, 1);
  draw_set_font(global.fnt_main);
  ```
  Line height is 10–11 px. White glyphs tint cleanly with `draw_text_colour` (UI yellow `#D9B860`, grey `#9A9284`).
- `spr_ui_dmg_digits_strip10`, `spr_ui_heal_digits_strip10` (green) and `spr_ui_crit_digits_strip10` (ember) are chunky outlined digits "0123456789", 7x9 per frame. Use `font_add_sprite_ext(spr, "0123456789", true, -1)` or draw them per digit with a 6px advance.
- `spr_ui_dmg_miss`, `spr_ui_dmg_critical` and `spr_ui_dmg_weak` are pop-up words.

### Status icons: `spr_ui_status_strip12` (10x10 frames, origin (5,5))
Frame order: 0 poison, 1 bleed, 2 ashburn, 3 stun, 4 fear, 5 defense down, 6 attack up, 7 attack down, 8 speed up, 9 speed down, 10 marked (Hunter's Mark), 11 guard (Shield Wall / Guard). These cover the GDD's planned status list.
Source: src/ui.py, src/ui_font.py, src/bg_battle.py, src/battle_mockup.py, src/ui_kit_preview.py (writes `ui/ui_kit_preview.png`).

## Items and chests — batch 5 (`items/`)
16x16 icons, origin (8,8), outlined, lit from the upper left, sharing one item palette (src/items.py `IPAL`). Preview: `items/items_preview.png`.

| File `spr_item_<id>.png` | Item |
|---|---|
| minor_potion | Minor Potion (consumable) |
| antidote | Antidote (consumable) |
| gold | Gold (coin pile, for loot pop-ups and shop UI) |
| iron_sword | Iron Sword (chest loot) |
| kaels_longsword | Kael's Longsword (starting weapon) |
| blackguards_longsword | Blackguard's Longsword (boss reward, black blade with ember glints) |
| hunters_knife | Hunter's Knife (Ashbound Hunter drop) |
| ashen_longbow | Ashen Longbow (Ashbound Hunter drop) |
| ashen_arrow | Ashen Arrow (Ashbound Hunter drop) |
| blackened_feather | Blackened Feather (crafting material) |
| hunters_charm | Hunter's Charm (Renn's quest reward, accessory: a wolf fang on a cord) |
| ashbound_parchment | Ashbound Parchment (key item) |
| watchtower_key | Watchtower Key (key item) |
| crownveil_fragment | Crownveil Fragment (boss reward / key item: a violet shard) |
| mira_pendant | Mira's Wooden Pendant: an unchanged copy of the existing /workspace/zone1/items icon, so there is only one design |
| leather_armor, iron_helm | **Generic placeholders.** The GDD and Chapter 1 script name no Chapter 1 armour; these are for Pell's equipment shop until the item DB defines real pieces |

Chests (`items/chests/`, 16x16 tiles, origin (0,0), same palette as the `chest` tile in ts_zone1.png): `spr_chest_wood_closed`, `spr_chest_wood_open`, `spr_chest_wood_open_strip3` (closed → lid lifting with a gold glint → open, play once at ~10 fps), plus the same three for `spr_chest_iron_*` (iron-bound, for the Watchtower dungeon and locked chests). Feet-style shadow on the bottom row matches the tileset chest. Use the sprite as an object over the floor so it can animate, or put the closed/open frames in a tileset and swap the tile.

## Title screen and main menu — batch 5 (`title/`)
Two sizes of everything: `title/320/` for a 320x180 GUI and `title/640/` for 640x360. The 640 backgrounds, logo, option graphics and cursor are drawn natively at 640 with finer detail. The 640 panels are 2x nearest upscales of the 320 panels, so the window and font pixels match the rest of the UI.

| Asset | 320 size | 640 size | Origin |
|---|---|---|---|
| `spr_menu_bg0_sky_<res>` (dusk gradient, low sun, cloud streaks, stars; opaque) | 320x180 | 640x360 | (0,0) |
| `spr_menu_bg1_hills_<res>` (two ranges of far hills, transparent above) | 320x180 | 640x360 | (0,0) |
| `spr_menu_bg2_ruins_<res>` (Greyhaven ruins: burned houses with ember-lit windows, the broken keep and the chapel spire) | 320x180 | 640x360 | (0,0) |
| `spr_menu_bg3_foreground_<res>` (rubble ridge, dead tree, fence posts, tattered banner) | 320x180 | 640x360 | (0,0) |
| `spr_menu_embers_<res>_strip24` (rising embers + drifting ash, seamless 24-frame loop, transparent) | 320x180 x24 | 640x360 x24 | (0,0) |
| `spr_logo_ashen_crown_<res>` (gold-bevelled "ASHEN CROWN" with ash on the letter tops, ember cracks and a crown with one broken point) | 250x71 | 501x143 | use (w/2, 0) |
| `spr_menu_opt_{new_game,continue,options,quit}_{normal,selected}_<res>` (+ `continue_disabled`) | 56–104 x30 | 2x | (w/2, 15) / (w/2, 30) |
| `spr_menu_cursor_<res>_strip4` (flickering ember, points right) | 10x12 x4 | 20x24 x4 | (9,6) / (19,12) |
| `spr_menu_panel_options_<res>`, `spr_menu_panel_saves_<res>` (finished panel mock-ups) | 200x118, 220x132 | 400x236, 440x264 | centre |
| `spr_title_screen_<res>` (flattened title: background + logo + "Press any key") | 320x180 | 640x360 | (0,0) |

Each option graphic is the same size in all its states (normal, selected, disabled), so you can swap sprites without moving anything. Selected = gold with an ember glow; normal = bone/grey; disabled = dark grey (use it for Continue when there is no save).
Widgets for the panels (in `ui/`): `spr_ui_slider_track` (12x6, nine-slice 2 on every side), `spr_ui_slider_knob` (8x10, origin (4,5)), `spr_ui_toggle_strip2` (16x10, frame 0 off, frame 1 on).
Mockups (`title/mockups/`): `spr_mockup_main_menu_<res>.png`, `..._options_<res>.png`, `..._saves_<res>.png`, plus an animated `main_menu_<res>_preview.gif` that shows the parallax drift, ember loop and cursor flicker.

### Laying out the main menu in GameMaker
Assumes a 320x180 GUI. For 640x360, use the `_640` sprites and double every number below.
1. **Room `rm_main_menu`** with a 320x180 camera (viewport 1280x720). Turn off interpolation: Game Options > Graphics > uncheck "Interpolate colours between pixels".
2. **Background layers** (Room Editor, top to bottom): `bg3_foreground`, `bg2_ruins`, `bg1_hills`, `bg0_sky`. Assign `spr_menu_bg3_foreground_320`, etc. Tick **Horizontal Tile** on every layer and set **Horizontal Speed** to give the parallax: sky 0, hills -0.05, ruins -0.1, foreground -0.2 (pixels per frame at 60 fps). Every layer tiles seamlessly left to right.
3. **Ember loop:** in `obj_menu` Draw GUI, draw `spr_menu_embers_320_strip24` at (0,0) after the background layers and before the logo. Use `image_speed` 0 and step the frame yourself at 12 fps: `ember_f = (ember_f + 12/60) mod 24; draw_sprite(spr_menu_embers_320_strip24, ember_f, 0, 0);`. For more depth, draw it a second time at 50% alpha, offset by 12 frames and mirrored (`draw_sprite_ext(..., -1, 1, ...)` at x=320).
4. **Logo:** set the origin to Top Centre and draw at (160, 6). It looks good fading in over the first second (`draw_sprite_ext` alpha 0 → 1).
5. **Options:** a list `["new_game","continue","options","quit"]`. Draw each option centred at x=160, starting at y=80 with a 22px step (origins at middle-centre: y = 95, 117, 139, 161). Use the `_selected` sprite for the current index, `_disabled` for Continue when `!file_exists("save1.sav")` (and skip it when moving the cursor), and `_normal` otherwise.
6. **Cursor:** draw `spr_menu_cursor_320_strip4` (origin (9,6)) at `x = 160 - sprite_get_width(opt)/2 + 2`, at the selected option's centre y, animated at ~8 fps. Ease its y towards the target (`cy = lerp(cy, target, 0.35)`) so it glides between rows.
7. **Panels:** when Options or Continue is chosen, draw a dither/50% black rectangle over the screen. Then either draw the window live (`draw_sprite_stretched(spr_ui_window, 0, 60, 35, 200, 118)` with the rows in `fnt_main`, 15px apart starting 22px from the top, sliders `spr_ui_slider_track` stretched to 70x6 at x+106, knob at `x+106 + 62*value`, toggles `spr_ui_toggle_strip2`), or use `spr_menu_panel_options_320` / `spr_menu_panel_saves_320` as a static placeholder. The save panel is a 220x132 window with three 188x34 slot windows (`spr_ui_window_gold` for the selected slot, `spr_ui_window_dim` for empty slots), a Kael 16x24 overworld idle sprite at (+8,+5), and text at (+30,+6) and (+30,+18). The menu cursor for panels is `spr_ui_cursor_strip2`.
8. **Title screen:** the same room and layers, with the logo at (160, 22) and "Press any key" (`fnt_main` or the flattened `spr_title_screen_320`) blinking at y≈132. On any key, slide the logo up to y=6 over ~0.3 s and fade the four options in.
Source: src/title_menu.py (backgrounds, embers, logo, options, cursor, panels, mockups) and src/items.py.

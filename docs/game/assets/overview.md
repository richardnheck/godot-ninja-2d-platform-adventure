# Assets — Folder Overview

Top-level layout of `assets/`. This file is a map, not an exhaustive list — per-component docs name the specific files they consume.

```
assets/
├── dlxfont.ttf                  # top-level font (unused?)
├── art/
├── fonts/
├── music/
├── sounds/
└── themes/
```

## art/

| Folder | Contents |
|--------|----------|
| `backgrounds/` | Parallax/layer backgrounds for caves and rooms. Includes `cave_background_layer_1..4.png`, stalactite/stalagmite props, `spr_CAVE_bck_paralax_strip4.png`. |
| `effects/` | Reusable visual effects. Currently `multi_sparkle_puff/` (66-frame sparkle used by gem collection). |
| `ideas/` | Concept art and scrapped ideas. Not referenced by any scene. |
| `promotion/` | Marketing / screenshot art. Not referenced at runtime. |
| `props/` | Object sprites grouped by type — `collectibles/` (coin, gem-hearts), `door/`, `kamon-key/`, `lamps-and-signs.aseprite`, `tutorial-arrows/`. |
| `sprites/` | Character sprites — `player/` (player atlas + death effects), `enemy-death/` (shared enemy death effects). Individual enemy sprite atlases live next to their `.gd` under `src/characters/enemies/<name>/` rather than here. |
| `textures/` | Stand-alone material textures (`GOLDROCKS.png`, `PAVEMENT.png`, `SLIMROCKS.png`, `brick4_s.jpg`). |
| `tilesets/` | Tileset atlases and `.tres` definitions — see [../levels/tilemaps/](../levels/tilemaps/). |
| `ui/` | Button sprites and UI atlases — back/play/quit/retry/settings/close/skip/continue, music/sound toggle states (1–4 frames), mobile-button atlases (`mobile-buttons.png`), scrollbar grabber/scroll, pause/resume buttons, on-screen jump/left/right mobile buttons. Multiple variants per button — see referenced screens in `ui/`. |

### Tilesets (`art/tilesets/`)

Subdivided by world. Full per-tileset reference lives in `docs/game/levels/tilemaps/`:

- `cave-level/` — `CaveLevelTileset.tres`, `CaveLevelBackgroundTileset.tres`, `CaveLevelTilesetNoCollisions.tres`, props/platform atlases.
- `world2/` — multiple tilesets (`world2-tileset`, `world2-props-tileset`, `sky-tileset`, `roof-wall-tileset`, `bricks_tileset`, `pylons-tileset`, `stone-bricks-tileset`, `stone-ground-tileset`, `wooden-slats-tileset`) plus animated textures under `flame-trap/`, `flame-trap2/`, `water-tileset/`. Has an `ideas/` subfolder with scrapped/reference tile sheets.
- `world3/` — `World3-Floor-Wall-Roof-Tileset.tres`, `World3-Background-Tileset.tres`, `World3-Props-Tileset.tres`.

## fonts/

Bitmap fonts for UI. Three TTFs with matching `DynamicFont` resources:
- `8-bit fortress.ttf` + `8-bit-fortress-font-7px.tres`
- `PixelOperator8.ttf` + `pixeloperator8-font.tres`
- `kongtext.ttf` + `kongtext.tres`
- `m5x7.ttf` + `m5x7.tres`

Themes select fonts by `.tres` reference.

## music/

(TBD — verify whether `assets/music/` is empty or holds reference tracks. Shipping BGM tracks live under `assets/sounds/bgm/`.)

## sounds/

```
sounds/
├── Sound Effects.flp          # FL Studio project for the SFX (source)
├── select-blip-longer.wav     # one-off, possibly unused
├── bgm/                       # background music (.ogg)
└── sfx/
    ├── character/
    ├── collectibles/
    ├── environments/
    └── ui/
```

Every shipping SFX is loaded into `Game_AudioManager` (see [../systems/autoloads.md](../systems/autoloads.md) for the full catalogue of `sfx_*` and `bgm_*` node names). BGM tracks loaded by `AudioManager.tscn`:
- `main theme song (idea #2).ogg`
- `story intro theme.ogg`, `story outro theme.ogg`
- `cave level theme song.ogg`, `cave boss theme.ogg`, `cave boss intro.ogg`, `cave boss outro.ogg`
- `world2 level theme song.ogg`, `world2 boss theme song.ogg`
- `world3 level theme song.ogg`, `world3 boss theme song.ogg`, `world3 boss outro.ogg`

## themes/

Godot `Theme` resources:
- `cave-level/` — World 1 theme.
- `world2/` — World 2 theme.
- `world3/` — World 3 theme.
- `main/` — main menu theme.
- `pause/` — pause overlay theme.
- `settings/` — settings screen theme.
- `test_theme.tres` — dev/test theme.

Screens reference the appropriate theme via their `theme` property.

## Naming conventions

- **kebab-case** for asset filenames (e.g. `cave-platform.png`, `daruma-Sheet.png`).
- **`-Sheet.png`** suffix on sprite atlases (e.g. `nekekubi-headsheet.png`, `HannyaSheet.png`).
- **`.aseprite`** source files are kept alongside their exported `.png` (the `.aseprite` is the editable source).
- **`.tres`** for Godot resources (Theme, TileSet, AnimatedTexture, DynamicFont).
- **`.import`** files are Godot auto-generated import metadata — ignore for the port.

## Texture import preset

All textures import with: `flags/filter = false` (nearest-neighbour), `mipmaps = false`, lossless. See [../systems/project-config.md](../systems/project-config.md#importer-defaults). Pixel-art fidelity depends on these.

# World 2 Tilesets

**Category:** Level / Tilemaps
**Folder:** `assets/art/tilesets/world2/`

World 2 (Within the Walls) is the largest tileset family — the visual world is composed of many themed tilemaps stacked in front of a hidden `TileMapWorld` (using [CaveLevelTileset.tres](cave-tilesets.md)) that owns the actual collision. See [overview.md](overview.md) for the layer pattern.

All world 2 tilesets use 16x16 cells unless noted. Collision shapes are full per-tile rectangles (`( 0, 0 ), ( 16, 0 ), ( 16, 16 ), ( 0, 16 )`) except where noted.

## `world2-tileset.tres`

The trap-and-effects tileset. Drives `TileMapTraps` in every World 2 level. Also used as `TileMapBg` in some levels.

- **Source atlases:**
  - `world2-tileset.png` — main atlas (ids 0, 1, 2, 3, 8, 9 — wall/spike/effect tiles).
  - `water_00_animated.tres` (AnimatedTexture) — water surface (id 5).
  - `water_00_block.png` — solid water block (id 6).
  - `flame-trap_animatedtexture.tres` — flame trap variant 1 (id 7).
  - `flame_trap2_animatedtexture.tres` — flame trap variant 2 (id 10).
- **Tile count:** 11 records (ids 0–10).
- **Autotile:** All `tile_mode = 0` (single tile).
- **Collision shapes:** mixture of full 16x16 rectangles and custom narrow polygons. The two spike-like tiles (sub_resource ids 10, 4) use thin polygons for tighter hitboxes (e.g. `( 4.31, 16 ), ( 6.63, 1.94 ), ( 10.13, 11.94 ), ( 10.13, 16 )` for an angled spike).
- **Animated tiles:** ids 5, 7, 10 (see below).

## `world2-props-tileset.tres`

Decorative props (no collision). Used by `TileMapProps` in World 2 Level 6.

- **Source atlas:** `world2-props-tileset.png`.
- **Tile count:** 3 records (ids 0, 1, 2). All `tile_mode = 0`.
- **Collision shapes:** none.

## `sky-tileset.tres`

The sky band. Used by `TileMapSky` in every World 2 level and reused in World 3.

- **Source atlas:** `sky-tileset.png` — region `(0, 32, 16, 152)`.
- **Tile count:** 1 autotile (id 0, `sky-tileset.png 0`).
- **Autotile:** `tile_mode = 2`, 16x16 autotile cells. Used as a vertical strip of sky bands.
- **Collision shapes:** none.

## `roof-wall-tileset.tres`

Visual roof + wall layer (no collision). Used by `TileMapWallsRoof` in every World 2 level.

- **Source atlases:**
  - `roof-wall-tileset.png` — region `(0, 16, 16, 448)` (id 0).
  - `roof-wall-details-tileset.png` — region `(0, 16, 16, 256)` (id 1).
- **Tile count:** 2 records.
- **Autotile:** both `tile_mode = 2`, 16x16 cells.
- **Collision shapes:** none.

## `bricks_tileset.tres`

Brick wall variants. Used by `TileMapBricks`.

- **Source atlas:** `bricks-tileset.png`.
- **Tile count:** 12 records (ids 0–11). All `tile_mode = 0` (single tiles).
- **Collision shapes:** none — purely visual.

## `pylons-tileset.tres`

Stone pylon vertical tiles. Used by `TileMapPylons` in World 2 Level 3, Level 4.

- **Source atlas:** `pylons-tileset.png` — region `(0, 16, 16, 96)`.
- **Tile count:** 1 record (id 0).
- **Autotile:** `tile_mode = 2`, 16x16 autotile cells (6 cells vertical).
- **Collision shapes:** each autotile cell has a full 16x16 rectangle shape; pylons are solid.

## `stone-bricks-tileset/tileset_stone-bricks-tileset.tres`

Stone brick blocks used for free-floating platforms ("stones in air"). Used by `TileMapWorldStonesInAir`.

- **Source atlases:**
  - `tileset_stone-bricks-tileset.png` — large 3x3 autotile region (id 0).
  - `stone-bricks-single-brick.png` (id 1).
  - `stone-bricks-thin-tiles.png` (id 2).
- **Tile count:** 3 records.
- **Autotile:** id 0 uses `tile_mode = 1` (3x3 minimal autotile with bitmask) — the only bitmask-driven tileset in World 2. id 1 is `tile_mode = 0`. id 2 is `tile_mode = 2`.
- **Collision shapes:** id 0 has per-bitmask-position shapes (full 16x16 rectangles); id 2 also has 16x16 rectangles per autotile cell.

## `stone-ground-tileset.tres`

Solid stone ground. Used by `TileMapWorldStone` in every World 2 level.

- **Source atlas:** `stone-ground-tileset.png`.
- **Tile count:** 2 records.
  - id 1 — region `(8, 24, 8, 32)`, `tile_mode = 2`, autotile cell `Vector2( 8, 8 )` (smaller 8x8 sub-tiles), no collision.
  - id 2 — region `(0, 16, 16, 224)`, `tile_mode = 2`, 16x16 autotile cells, 14 collision rectangles (one per autotile coord `(0, 0)` … `(0, 13)`) each a full 16x16.
- **Animated tiles:** none.

## `wooden-slats-tileset.tres`

Wooden slat boards used by `TileMapWoodenSlats` in every World 2 level.

- **Source atlas:** `wooden-slats-tileset.png`.
- **Tile count:** 4 records (ids 0–3). All `tile_mode = 2`, 16x16 autotile cells.
- **Collision shapes:** none (visual only — the underlying invisible `TileMapWorld` handles solidity).

## Animated textures

These `AnimatedTexture` resources are referenced by `world2-tileset.tres` and play directly on the tilemap.

### `flame-trap/flame-trap_animatedtexture.tres`

- **Frames:** 4 (`flame-trap1.png` → `flame-trap2.png` → `flame-trap3.png` → `flame-trap4.png`).
- **FPS:** 8.0 (each frame ~0.125 s, but actual `delay_sec` is 0.0 so it uses the global fps).
- **Used as:** tile id 7 in `world2-tileset.tres` (vertical flame jet).

### `flame-trap2/flame_trap2_animatedtexture.tres`

- **Frames:** 3 (`flame1.png` → `flame2.png` → `flame3.png`).
- **FPS:** 5.0 (slower flicker variant).
- **Used as:** tile id 10 in `world2-tileset.tres`.

### `water-tileset/water_00_animated.tres`

- **Frames:** 4 (`water_00_strip4.png` → `water_00_strip5.png` → `water_00_strip6.png` → `water_00_strip7.png`).
- **FPS:** uses the default `AnimatedTexture` rate (no explicit `fps` written — Godot 3 default is 4 fps).
- **Used as:** tile id 5 in `world2-tileset.tres` (water surface). The companion `water_00_block.png` (id 6) is the static under-surface water tile.
- **Trap tagging:** `TileMapWater` in Level 5 is placed in both the `trap` and `water-trap` groups so the player dies on contact (the `DieByWater` branch in `player_controller.gd` is commented out — currently routes to normal death).

## Standalone PNGs (not tileset-wrapped)

- `clouds.png` — used as a tiled `Sprite` background in every world 2 level (parallax-style).
- `pylon.png` — referenced directly by the world 2 Boss level (free-standing pylon).
- `tilesetter-test-tiles.aseprite/png`, `wall-roof-sky-tilesets.aseprite`, `stone-bricks-tileset2.tset`, `tilesetter-test.tset` — Tilesetter project files; not loaded at runtime.
- `test-corner-bottom-tile.png` — debug.

## Used by

- `world2-tileset.tres` → `TileMapTraps` in every World 2 level + boss.
- `roof-wall-tileset.tres` → `TileMapWallsRoof` in every World 2 level + boss.
- `stone-bricks-tileset/…tres` → `TileMapWorldStonesInAir`.
- `stone-ground-tileset.tres` → `TileMapWorldStone`.
- `wooden-slats-tileset.tres` → `TileMapWoodenSlats`.
- `bricks_tileset.tres` → `TileMapBricks`.
- `pylons-tileset.tres` → `TileMapPylons` (Level 3, Level 4, boss).
- `sky-tileset.tres` → `TileMapSky`.
- `world2-props-tileset.tres` → `TileMapProps` (Level 6).

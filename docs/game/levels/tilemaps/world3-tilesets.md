# World 3 Tilesets

**Category:** Level / Tilemaps
**Folder:** `assets/art/tilesets/world3/`

World 3 (Inside the Tower) ships three TileSet resources. Like World 2 (see [world2-tilesets.md](world2-tilesets.md)), the visual surface is drawn from these tilesets but the actual collision is carried by a hidden `TileMapWorld` using [CaveLevelTileset.tres](cave-tilesets.md). See [overview.md](overview.md) for the layer pattern and the `Section1` … `Section5` organisation that World 3 levels use.

All World 3 tilesets use 16x16 cells. Collision shapes (where present) are full per-tile rectangles (`( 0, 0 ), ( 16, 0 ), ( 16, 16 ), ( 0, 16 )`) except where noted.

## `World3-Floor-Wall-Roof-Tileset.tres`

The largest of the three — every visible structural tile in World 3 (floors, walls, roof beams, ladder rails, eaves). Used by `TileMapWorld` (visual variant) and structural overlay tilemaps in every World 3 level and the boss.

- **Source atlas:** `Floor+Wall+Roof Tileset.png`.
- **Tile count:** 131 tile records (ids 1–134 with gaps at 7, 113, 127).
- **Autotile:**
  - 129 tiles are `tile_mode = 0` (single tile, hand-placed).
  - 2 tiles are `tile_mode = 2` (atlas mode) with 16x16 autotile cells — ids 114 (region `(16, 0, 16, 16)`) and 115 (region `(160, 0, 16, 16)`). Used for the long repeating floor/roof bands.
  - No `tile_mode = 1` (3x3 minimal bitmask) tiles — World 3 lays everything down by hand.
- **Collision shapes:** 118 `ConvexPolygonShape2D` sub-resources. The vast majority are full 16x16 rectangles. Five thin polygons cover one-way platform tops:
  - sub_resource id 93 — `( 16, 0 ), ( 16, 6.875 ), ( 0, 6.875 ), ( 0, 3.60 ), ( 0, 0 ), ( 9.125, 0 )`.
  - sub_resource id 94 — `( 15.875, 0 ), ( 16, 1 ), ( 0, 0.9375 ), ( 0, 0 ), ( 5.6875, 0 )`.
  - sub_resource ids 95, 96, 97 — sub-pixel-thin top edges (`y <= 1`) used as drop-through platform surfaces.
  - 4 of these are flagged `shape_one_way = true` (tile ids 81, 82, 83, 84).
- **Animated tiles:** none.

## `World3-Background-Tileset.tres`

Non-collidable background fill used by `TileMapBackground` (or equivalent visual layer) in every World 3 level.

- **Source atlas:** `Background Tileset.png`.
- **Tile count:** 8 records (ids 0–7), regions stepping across the top row at `(16, 0)` … `(128, 0)` (each 16x16).
- **Autotile:** all `tile_mode = 0` (single tile).
- **Collision shapes:** none (`shapes = [ ]` on every entry). Background only.
- **Animated tiles:** none.

## `World3-Props-Tileset.tres`

Small decorative props (paper banners, talisman details) layered on top of the structural tiles.

- **Source atlas:** `world3-props-tileset.png` — vertical strip at x=0, three 16x16 rows.
- **Tile count:** 3 records (ids 0–2) at regions `(0, 0, 16, 16)`, `(0, 16, 16, 16)`, `(0, 32, 16, 16)`.
- **Autotile:** all `tile_mode = 0`.
- **Collision shapes:** none.
- **Animated tiles:** none.

## Standalone atlases & PNGs

The `assets/art/tilesets/world3/` folder also contains source `.aseprite` files (`Floor+Wall+Roof Tileset.aseprite`, etc.) and PNG companions that are not wrapped as TileSet resources. They are not loaded at runtime — only the three `.tres` files above are referenced from level scenes.

## Used by

- `World3-Floor-Wall-Roof-Tileset.tres` → the visible structural tilemap in every `World3Level_LevelN.tscn` (placed inside each `Section1` … `Section5` child node) and the `World3Level_Boss.tscn` arena.
- `World3-Background-Tileset.tres` → the rear background layer in every World 3 level.
- `World3-Props-Tileset.tres` → decorative prop tilemaps in selected World 3 levels.
- The hidden `TileMapWorld` that owns collision in every World 3 level continues to reference [CaveLevelTileset.tres](cave-tilesets.md) (see [overview.md](overview.md)).
- `sky-tileset.tres` from World 2 is reused for the sky band — see [world2-tilesets.md](world2-tilesets.md).

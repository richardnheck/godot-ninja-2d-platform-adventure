# Cave (World 1) Tilesets

**Category:** Level / Tilemaps
**Folder:** `assets/art/tilesets/cave-level/`

World 1 (Beneath the Castle) uses three TileSet resources. The same `cave-tileset.png` atlas is referenced by multiple tilesets at different regions and tile modes. See [overview.md](overview.md) for the system-wide layer pattern.

## `CaveLevelTileset.tres`

The shipping cave tileset — used as `tile_set` for `TileMapWorld` and `TileMapTraps` in every World 1 level. Also reused as the **invisible collision** `TileMapWorld` in World 2 and World 3 levels.

- **Source atlases:**
  - `cave-tileset.png` — main atlas (walls, floors, roofs, platforms, ladders, shadow tiles).
  - `cave-props-tileset.png` — secondary atlas (cave-props details, banners).
  - `cave_blue_stalectite.png` — background atlas for the stalactite tiles.
- **Tile count:** 28 named tile records (ids 0–35 with gaps). Notable entries:
  - `1. these-are-walls` (id 0), `1. these are walls 2` (id 16) — autotile walls, 16x16.
  - `platforms` (id 1) — autotile, 16x16.
  - `0. objects` (id 2), `background` (id 3), `shadow` (id 4) — autotile.
  - `black rock` (id 13), `black rock edges` (id 35) — autotile.
  - Roof / wall variants `1. roof variant #1` … `1.roof-var4` (ids 20–22, 25, 26).
  - `floor-slime1` / `floor-slime2` (ids 23, 24) — single-tile slime variants used as trap tiles.
  - Stalactite atlases (ids 27–30, 32–34) — single tiles for decoration.
  - `prototype` (id 11), `empty collision block` (id 14) — debug/utility tiles.
- **Autotile:** `tile_mode = 2` (atlas mode) on ids 0, 1, 2, 3, 4, 13, 16, 18, 31, 35. All autotile tiles use `Vector2( 16, 16 )` cell size. Atlas-mode tilesets in Godot 3 do not encode bitmask rules; the layout is laid down by hand and the tileset just provides regions.
- **Collision shapes:** every collidable tile uses a `ConvexPolygonShape2D` with points `( 0, 0 ), ( 16, 0 ), ( 16, 16 ), ( 0, 16 )` — i.e. a per-tile full 16x16 rectangle. One exception (sub_resource id 25) has a thin top-edge polygon `( 0, 0 ), ( 16, 0 ), ( 16, 4.66 ), ( 0, 4.57 )` used for one-way platform tops.
- **Animated tiles:** none in this tileset.

## `CaveLevelBackgroundTileset.tres`

The non-collidable background tileset used by `TileMapBg` in every World 1 level.

- **Source atlases:**
  - `cave-tileset.png` — region `(0, 192, 96, 64)` used as autotile (id 0, name `background`, autotile cell `Vector2( 32, 32 )`).
  - `cave-brick.png` — single 48x48 tile (id 1) used as the giant brick fill behind levels (`cell_size = Vector2( 48, 48 )` on `TileMapBg`).
- **Tile count:** 2 records.
- **Autotile:** id 0 is `tile_mode = 2` with 32x32 autotile cells. id 1 is `tile_mode = 0` (single tile).
- **Collision shapes:** none (`shapes = [ ]`). Background only.

## `CaveLevelTilesetNoCollisions.tres`

A second non-collidable variant of `cave-tileset.png` used for decorative cave geometry that should not interact with the player (e.g. `TileMapWorldBg` in Level 2 — modulated red to look like distant cave geometry).

- **Source atlas:** `cave-tileset.png` — region `(0, 0, 128, 96)`.
- **Tile count:** 1 record (id 0, name `cave-tileset.png 0`).
- **Autotile:** `tile_mode = 2`, autotile cell `Vector2( 16, 16 )`.
- **Collision shapes:** none.

## Platform & track atlases (cave-level folder)

These are PNGs only — they have no `.tres` TileSet wrapper. They are loaded as `Texture` resources and used as the `texture` property of Sprite/NinePatchRect/Polygon2D nodes in moving-platform scenes:

- `cave-platform.png` — the moving cave platform body sprite.
- `cave-platform-track.png`, `cave-platform-track-48.png`, `cave-platform-track-64.png`, `cave-platform-track-80.png` — five rail-track length variants drawn behind moving platforms.
- `cave-wood-platform-horizontal.png`, `cave-wood-platform-vertical.png` — wood-styled platform variants.
- `default-prototype-tile.png` — placeholder tile.
- `onigawara-head.aseprite` — source for the onigawara (roof guardian) decor; not currently a tileset.

For how moving platforms reference these textures, see [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md).

## Used by

- `TileMapWorld` / `TileMapTraps` in every `World1Level_LevelN.tscn` and `World1Level_Boss.tscn`.
- `TileMapWorld` (the hidden physics tilemap) in every World 2 and World 3 level.
- `TileMapBg` in every World 1 level (background variant + brick).
- World 2 Level 6 also references `CaveLevelTileset.tres` as a secondary visual layer (`TileMapCaveLevel`).

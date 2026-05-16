# Tilemap Overview

**Category:** Level / Tilemaps

System-wide notes on how every shipping level lays out its TileMap layers. Per-world tileset details live in:

- [cave-tilesets.md](cave-tilesets.md)
- [world2-tilesets.md](world2-tilesets.md)
- [world3-tilesets.md](world3-tilesets.md)

## Tile size

Every TileMap that participates in collision or rendering uses `cell_size = Vector2( 16, 16 )`. This matches `Constants.SNAP_LENGTH = 16` (see [../../systems/autoloads.md#Constants](../../systems/autoloads.md)) so the player's `move_and_slide_with_snap` lines up with tile grid corners.

Non-16 exceptions seen in shipping scenes:

- `TileMapBg` in World 1 levels uses `cell_size = Vector2( 48, 48 )` (large `cave-brick.png` background blocks).
- A few decorative cave variants use `Vector2( 16, 8 )` for half-height props that get layered behind the world.

## Layer pattern

Every shipping level uses the same naming convention so `LevelBase.gd` can find them by exact name. From [../level-base.md](../level-base.md):

| Name | Required? | Role |
|------|-----------|------|
| `TileMapWorld` | Yes | The collidable world geometry. Camera bounds are computed from `TileMapWorld.get_used_rect()`. |
| `TileMapTraps` | Yes | Hazard tiles. Added to the `trap` group at `_ready`. Any tile here kills the player on `KinematicCollision2D`. |
| `TileMapBg` / `TileMapSky` | Optional | Pure visual background layer (`collision_layer = 0` / `collision_mask = 0`). |
| `TileMapWorldBg` / `TileMapTexture` | Optional | Detail / texture overlay tiles (no collision). |
| `TileMapWater` | Optional | World 2 only. Joins both `trap` and `water-trap` groups (the `water-trap` route into `DieByWater` is commented out in `player_controller.gd`). |
| `TileMapBlockHole` / `TileMapInvisibleFrame` | Optional | Hidden collision used to seal level edges. Visible = false. |
| `TileMapWallsRoof`, `TileMapBricks`, `TileMapWoodenSlats`, `TileMapWorldStone`, `TileMapWorldStonesInAir`, `TileMapPylons`, `TileMapProps` | Optional | World 2 / 3 split the world into multiple non-collidable visual layers atop a hidden `TileMapWorld`. The hidden world tilemap (`visible = false`) carries the actual collision. |
| `TileMapBossWorld`, `TileMapBossFallingSpikesWorld` | Boss only | Swapped in by the boss during specific phases (kept `visible = false` until needed). |

### Visible-vs-collidable split (World 2 & 3)

Most World 2 and World 3 levels keep `TileMapWorld` invisible (`visible = false`) and rely on multiple themed visual tilemaps stacked on top. The invisible `TileMapWorld` uses [CaveLevelTileset.tres](cave-tilesets.md) for its collision shapes regardless of theme, so the player's physics behavior is identical across all three worlds.

World 3 levels organise content into `Section1` … `Section5` child `Node2D`s, each containing its own `TileMapWorld` and `TileMapTraps`. All trap tilemaps (including section-scoped ones) are tagged with `groups=["trap"]` directly in the scene so they are picked up at `_ready` without LevelBase needing to walk into the section nodes.

## Pixel-perfect rendering

- Atlas PNGs are imported with `flags/filter=false` (nearest-neighbor) — see any `*.png.import` file.
- The project enables `display/window/integer_resolution_handler/base_height=180` via the `IntegerResolutionHandler` autoload (see [../../systems/autoloads.md#IntegerResolutionHandler](../../systems/autoloads.md)). This locks the viewport to integer multiples of the 320 x 180 base.
- TileMap nodes have no per-node filter override; they inherit the texture import setting.

## Naming conventions for tileset files

- Folder layout: `assets/art/tilesets/<theme>/`.
- Tileset resources end in `.tres` with `type="TileSet"`. World 1 uses PascalCase (`CaveLevelTileset.tres`), World 2 uses kebab-case (`world2-tileset.tres`), World 3 mixes PascalCase + kebab (`World3-Floor-Wall-Roof-Tileset.tres`).
- Source atlas PNGs sit alongside the `.tres` file and share the base name (sometimes via `.aseprite` source).
- Animated textures (flame traps, water surface) are separate `AnimatedTexture` `.tres` files referenced from the tileset's `ext_resource` block — see `world2-tilesets.md` for animation timings.
- `tile_mode` values in a `.tres` file mean: `0` = single tile, `1` = 3x3 minimal autotile, `2` = atlas (uniform 16x16 cells, no autotile rules).

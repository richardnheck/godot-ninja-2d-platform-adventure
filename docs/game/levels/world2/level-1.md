# Hold your Hori

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level1.tscn`
**Inherits:** `LevelBase` (script attached directly via `ExtResource(11)`)

## Display name & BGM
"Hold your Hori" / `Bgm_World2LevelTheme` (resolved by node-name lookup, see [overview.md](overview.md)).

The "hori" is a castle moat — the level is a long water-skip across cloud platforms with fish (WaterJumpYokai) bursting out beneath the player.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).

## TileMap layers
- `TileMapSky` — sky band background.
- `TileMapWallsRoof` — castle roof / wall art.
- `TileMapBricks` — brick wall accents.
- `TileMapWoodenSlats` — wooden slat surfaces.
- `TileMapWorldStone` — solid stone ground (visual).
- `TileMapWorldStonesInAir` — floating stone-brick platforms.
- `TileMapTraps` (group `trap`) — water surface + hazard tiles.
- `TileMapWorld` — hidden collision layer (uses `CaveLevelTileset.tres` for shapes via inherited convention).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| WaterJumpYokaiSpawner | 9 | [../../objects/hazards/water-jump-yokai.md](../../objects/hazards/water-jump-yokai.md) |
| Kappa | 3 | [../../enemies/path-follow/kappa.md](../../enemies/path-follow/kappa.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| CloudPlatform | 14 | [../../objects/platforms/cloud-platform.md](../../objects/platforms/cloud-platform.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

## Checkpoints

- 1 `CheckPoint` instance under `InteractiveProps/` (`CheckPoint`). See [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md).

## Notes

- First World 2 level. No `CameraAdjustArea2D`s — camera is flat horizontal travel.
- No FireBallSpinners, no Cannons, no ClockSwitches — the level is intentionally a gentle introduction focused on platforming over water with the new WaterJumpYokai hazard and Kappa enemies.
- The bulk of the CloudPlatform instances form the moat-crossing path.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- Enemy/object docs linked in the tables above.

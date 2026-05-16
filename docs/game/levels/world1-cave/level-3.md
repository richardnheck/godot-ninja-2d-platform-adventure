# Unstable ishi

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level3.tscn`
**Root node:** `CrumblingRocksLevel2`
**Inherits:** LevelBase (script ExtResource id 5)

## Display name & BGM

"Unstable ishi" / `Bgm_CaveLevelTheme`.

`LevelData.levelsArray[2]`. Introduces crumbling-platform traversal — the floor itself becomes a hazard. Also brings horizontal moving cave platforms and the first falling spikes.

## Tilesets used

- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — `TileMapWorld` + `TileMapTraps`.
- `assets/art/tilesets/cave-level/CaveLevelBackgroundTileset.tres` — `TileMapBg`.

See [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers

- `TileMapBg` — cave-brick background.
- `TileMapWorld` — collidable world geometry.
- `TileMapTraps` — hazard tiles (group `["trap"]`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| Ashimigarari | 1 | [ashimigarari](../../enemies/path-follow/ashimigarari.md) |
| RedCreepyCrawly | 1 | [red-creepy-crawly](../../enemies/path-follow/red-creepy-crawly.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| DoorStart (CaveDoorStart) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CrumblingPlatform | 21 (`CrumblingPlatform5` … `CrumblingPlatform26`) | [crumbling-platform](../../objects/platforms/crumbling-platform.md) |
| MovingPlatformCave2H | 7 (`MovingPlatformCave2H`, `MovingPlatformCave2H2`–`5`, `MovingPlatformCave2H44`) | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| FallingSpike | 2 (`FallingSpike2`, `FallingSpike3`) | [falling-spike](../../objects/hazards/falling-spike.md) |
| JapaneseLamp | 7 | [decorations](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 3 (`CameraAdjustAreaDown`, `CameraAdjustAreaReset`, `CameraAdjustAreaDown2`) | [camera-adjust-area](../../objects/camera/camera-adjust-area.md) |

## Checkpoints

- None placed in this scene — the level is short enough to restart from spawn.

## Notes

- Heaviest use of `CrumblingPlatform` in the game (21 instances).
- Moving platforms use the `HorizontalRightLeft64.tres` and `HorizontalLeftRight64.tres` curves (ExtResource ids 14, 15).
- Enemies parent `enemies` Node2D instead of `InteractiveProps` — both forms work because `LevelBase.gd` enumerates via `get_tree().call_group("enemy", ...)` rather than walking a fixed path.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/path-follow/ashimigarari.md](../../enemies/path-follow/ashimigarari.md)
- [../../enemies/path-follow/red-creepy-crawly.md](../../enemies/path-follow/red-creepy-crawly.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/platforms/crumbling-platform.md](../../objects/platforms/crumbling-platform.md)
- [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md)
- [../../objects/hazards/falling-spike.md](../../objects/hazards/falling-spike.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md)

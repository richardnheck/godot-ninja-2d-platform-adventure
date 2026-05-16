# Kabe sliding all the way

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level4.tscn`
**Root node:** `CaveLevel`
**Inherits:** LevelBase (script ExtResource id 7)

## Display name & BGM

"Kabe sliding all the way" / `Bgm_CaveLevelTheme`.

`LevelData.levelsArray[3]`. Wall-slide / wall-jump focus level. Vertical and horizontal moving platforms combine with `OneEyedSpikey` patrols and `CreepyCrawly` chasers.

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
| OneEyedSpikey | 2 (`OneEyedSpikey`, `OneEyedSpikey2`) | [one-eyed-spikey](../../enemies/path-follow/one-eyed-spikey.md) |
| CreepyCrawly | 1 | [creepy-crawly](../../enemies/path-follow/creepy-crawly.md) |
| Ashimigarari | 2 (`Ashimigarari`, `Ashimigarari2`) | [ashimigarari](../../enemies/path-follow/ashimigarari.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| DoorStart (CaveDoorStart) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CheckPoint | 2 (`CheckPoint1` default, `CheckPoint2` id `"2"`) | [checkpoint](../../objects/interactive/checkpoint.md) |
| MovingPlatformCave2H | 3 (`MovingPlatformCave2H`, `…2`, `…5`) | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave1H | 7 (`MovingPlatformCave1H`, `…2`–`…7`) | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| JapaneseLamp | 12 | [decorations](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 2 (`CameraAdjustAreaDown`, `CameraAdjustAreaReset`) | [camera-adjust-area](../../objects/camera/camera-adjust-area.md) |

## Checkpoints

- `CheckPoint1` — default id.
- `CheckPoint2` — id `"2"`.

## Notes

- Moving platforms reference four `Curve2D` resources: `VerticalTopDown6L.tres`, `VerticalBottomUp6L.tres`, `HorizontalLeftRight64.tres`, `HorizontalRightLeft64.tres` (ExtResource ids 4, 10, 8, 9).
- Wall-slide / wall-jump mechanics rely entirely on the player FSM — no level-specific helper script.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/path-follow/one-eyed-spikey.md](../../enemies/path-follow/one-eyed-spikey.md)
- [../../enemies/path-follow/creepy-crawly.md](../../enemies/path-follow/creepy-crawly.md)
- [../../enemies/path-follow/ashimigarari.md](../../enemies/path-follow/ashimigarari.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md)

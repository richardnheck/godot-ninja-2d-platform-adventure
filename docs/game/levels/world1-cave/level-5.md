# Shiver me shi

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level5.tscn`
**Root node:** `CaveLevel - DeathFromAbove`
**Inherits:** LevelBase (script ExtResource id 6)

## Display name & BGM

"Shiver me shi" / `Bgm_CaveLevelTheme`.

`LevelData.levelsArray[4]`. "Death from above" — falling spikes and moving bamboo spikes dominate. The player has to read overhead hazards while still managing crumbling platforms and moving cave platforms.

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
| RedCreepyCrawly | 2 (`RedCreepyCrawly`, `RedCreepyCrawly2`) | [red-creepy-crawly](../../enemies/path-follow/red-creepy-crawly.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| DoorStart (CaveDoorStart) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CheckPoint | 1 (default id) | [checkpoint](../../objects/interactive/checkpoint.md) |
| FallingSpike | 10 (`FallingSpike`, `…2`–`…5`, `…10`, `…11`, `…14`, `…23`, `…25`) | [falling-spike](../../objects/hazards/falling-spike.md) |
| MovingBambooSpike | 9 (`MovingBambooSpike`, `…2`–`…7`, `…10`, `…11`) | [moving-bamboo-spike](../../objects/hazards/moving-bamboo-spike.md) |
| CrumblingPlatform | 4 (`CrumblingPlatform`, `…2`, `…3`, `…4`) | [crumbling-platform](../../objects/platforms/crumbling-platform.md) |
| SpikeyRock | 2 (`SpikeyRock4`, `SpikeyRock5`) | [spikey-rock](../../objects/hazards/spikey-rock.md) |
| MovingPlatformCave1H | 1 | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave2H | 3 (`MovingPlatformCave2H`, `…2`, `…3`) | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| JapaneseLamp | 12 + 2 stragglers parented to the root (`JapaneseLamp`, `JapaneseLamp2`) | [decorations](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 1 (`CameraAdjustAreaDown`) | [camera-adjust-area](../../objects/camera/camera-adjust-area.md) |

## Checkpoints

- `CheckPoint` — default id.

## Notes

- Highest concentration of falling/bamboo spikes in World 1.
- Two `JapaneseLamp` instances are parented directly to the level root rather than `Props/` — purely a scene-tree quirk; both still render the same.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/path-follow/one-eyed-spikey.md](../../enemies/path-follow/one-eyed-spikey.md)
- [../../enemies/path-follow/red-creepy-crawly.md](../../enemies/path-follow/red-creepy-crawly.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/hazards/falling-spike.md](../../objects/hazards/falling-spike.md)
- [../../objects/hazards/moving-bamboo-spike.md](../../objects/hazards/moving-bamboo-spike.md)
- [../../objects/hazards/spikey-rock.md](../../objects/hazards/spikey-rock.md)
- [../../objects/platforms/crumbling-platform.md](../../objects/platforms/crumbling-platform.md)
- [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md)

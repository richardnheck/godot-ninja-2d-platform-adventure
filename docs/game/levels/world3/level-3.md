# Master my Mushin

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level3.tscn`
**Inherits:** LevelBase

## Display name & BGM
"Master my Mushin" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres`
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `CaveLevelTileset.tres` — hidden collision `TileMapWorld`s.
- `sky-tileset.tres` — `TileMapSky`.
- Standalone art: `window.png`, `sashimono.png`, `pane.png`, `clouds.png`, `cave-platform-track-80.png`.

## TileMap layers
- Root: `TileMapBg`, `TileMapSky`, `TileMapWorld`, `TileMapTraps` (group `trap`).
- `Section1`–`Section5` each have `TileMapWorld` + `TileMapTraps` (group `trap`).
- `SectionTemplate5` carries unused template tilemaps.

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| ChochinObake | 5 | [../../enemies/path-follow/chochin-obake.md](../../enemies/path-follow/chochin-obake.md) |
| Daruma | 3 | [../../enemies/jumpers/daruma.md](../../enemies/jumpers/daruma.md) |
| Hannya | 3 | [../../enemies/patrol/hannya.md](../../enemies/patrol/hannya.md) |
| ChochinObakeShooter | 1 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| MegamanElectricity | 22 | [../../objects/hazards/megaman-electricity.md](../../objects/hazards/megaman-electricity.md) |
| ElectricityBeam | 7 | [../../objects/hazards/electricity-beam.md](../../objects/hazards/electricity-beam.md) |
| LongMovingSpike | 5 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| Spring | 11 | [../../objects/interactive/spring.md](../../objects/interactive/spring.md) |
| ConveyorBelt | 9 | [../../objects/platforms/conveyor-belt.md](../../objects/platforms/conveyor-belt.md) |
| MovingPlatformCave2H | 1 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| SmallLantern | 13 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CameraAdjustArea2D | 1 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

## Checkpoints
- 2 — two `CheckPoint` instances.

## Notes
- "Mushin" (無心) = no-mind / focus state. The level is built around timing the `MegamanElectricity` wall pulses while springing across conveyors.
- Section 2 alone has 8 `MegamanElectricity` units + 6 `Spring`s — a vertical bounce-tower puzzle.
- Section 5 stacks 12 more `MegamanElectricity` units in two grouped `Node2D` columns plus the final `MovingPlatformCave2H` traversal.
- Two checkpoints help the player retry the dense electricity sequences without restarting from spawn.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

# Heya, heya and heya

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level4.tscn`
**Inherits:** LevelBase

## Display name & BGM
"Heya, heya and heya" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres`
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `CaveLevelTileset.tres` — hidden collision `TileMapWorld`s.
- `sky-tileset.tres` — `TileMapSky`.
- Standalone art: `window.png`, `sashimono.png`, `banners.png`, `pane.png`, `clouds.png`.

## TileMap layers
- Root: `TileMapBg`, `TileMapSky`, `TileMapWorld`, `TileMapTraps` (group `trap`).
- `Section1`–`Section5` each have `TileMapNew` (visible) + `TileMapTraps` (group `trap`). Per-section collision lives on the root `TileMapWorld`.
- `SectionTemplate8` for authoring.

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| Hannya | 6 | [../../enemies/patrol/hannya.md](../../enemies/patrol/hannya.md) |
| ChochinObake | 7 | [../../enemies/path-follow/chochin-obake.md](../../enemies/path-follow/chochin-obake.md) |
| Bakezori | 3 | [../../enemies/path-follow/bakezori.md](../../enemies/path-follow/bakezori.md) |
| ZenchuuNoHikari | 4 | [../../enemies/path-follow/zenchuu-no-hikari.md](../../enemies/path-follow/zenchuu-no-hikari.md) |
| Daruma | 1 | [../../enemies/jumpers/daruma.md](../../enemies/jumpers/daruma.md) |
| RotatingOnibi | 5 | [../../objects/hazards/rotating-onibi.md](../../objects/hazards/rotating-onibi.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| FallingPlatform | 31 | [../../objects/platforms/falling-platform.md](../../objects/platforms/falling-platform.md) |
| MegamanElectricity | 12 | [../../objects/hazards/megaman-electricity.md](../../objects/hazards/megaman-electricity.md) |
| LongMovingSpike | 4 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| TriggerSpike | 2 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| RotatingPlatform | 4 | [../../objects/platforms/rotating-platform.md](../../objects/platforms/rotating-platform.md) |
| ConveyorBelt | 2 | [../../objects/platforms/conveyor-belt.md](../../objects/platforms/conveyor-belt.md) |
| Spring | 4 | [../../objects/interactive/spring.md](../../objects/interactive/spring.md) |
| MovingPlatformCave1H | 1 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| SmallLantern | 15 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CameraAdjustArea2D | 2 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

## Checkpoints
- 3 — three `CheckPoint` instances spread across sections.

## Notes
- "Heya" = room. The level visits multiple themed rooms (the three "heyas" in the title).
- `FallingPlatform` is the dominant traversal mechanic — 31 placements form the floor of Sections 2 and 3.
- Section 2 is a `FallingPlatform` + `MegamanElectricity` gauntlet; Section 3 mixes them with `LongMovingSpike` and a `RotatingPlatform` pair.
- Two `CameraAdjustArea2D` instances (named `CameraAdjustAreaDown` and `CameraAdjustAreaZeroXOffset`) reframe drops and a final section transition.
- Three checkpoints — most generous spacing in World 3 so far.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

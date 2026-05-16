# Saigo no nobori

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level6.tscn`
**Inherits:** LevelBase

## Display name & BGM
"Saigo no nobori" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres`
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `CaveLevelTileset.tres` — hidden collision `TileMapWorld`s.
- Standalone art: `window.png`, `sashimono.png`, `banners.png`, `pane.png`, `clouds.png`, `cave-platform-track-80.png`, `platform-track-for-9-patch-rect.png`.

No `TileMapSky` and no World3-Props-Tileset on this level — it is entirely interior (uses CaveLevelSlidingDoor for the exit).

## TileMap layers
- Root: `TileMapBg`, `TileMapWorld`, `TileMapTraps` (group `trap`).
- `Section1`–`Section5` each have `TileMapWorld` + `TileMapTraps` (group `trap`).
- `Section5` adds `TileMapProps` (uses Background tileset for decoration).

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| ChochinObake | 6 | [../../enemies/path-follow/chochin-obake.md](../../enemies/path-follow/chochin-obake.md) |
| LaserLantern | 8 | [../../enemies/path-follow/laser-lantern.md](../../enemies/path-follow/laser-lantern.md) |
| ShardLantern | 4 | [../../enemies/path-follow/shard-lantern.md](../../enemies/path-follow/shard-lantern.md) |
| Hannya | 4 | [../../enemies/patrol/hannya.md](../../enemies/patrol/hannya.md) |
| ChochinObakeShooter | 2 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |
| Bakezori | 3 | [../../enemies/path-follow/bakezori.md](../../enemies/path-follow/bakezori.md) |
| TofuKozo | 3 | [../../enemies/throwers/tofu-kozo.md](../../enemies/throwers/tofu-kozo.md) |
| Daruma | 2 | [../../enemies/jumpers/daruma.md](../../enemies/jumpers/daruma.md) |
| KasaObake | 2 | [../../enemies/jumpers/kasa-obake.md](../../enemies/jumpers/kasa-obake.md) |
| Nekekubi | 1 | [../../enemies/chasers/nekekubi.md](../../enemies/chasers/nekekubi.md) |
| Shirime | 1 | [../../enemies/patrol/shirime.md](../../enemies/patrol/shirime.md) |
| ZenchuuNoHikari | 2 | [../../enemies/path-follow/zenchuu-no-hikari.md](../../enemies/path-follow/zenchuu-no-hikari.md) |
| RotatingOnibi | 5 | [../../objects/hazards/rotating-onibi.md](../../objects/hazards/rotating-onibi.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| MegamanElectricity | 40 | [../../objects/hazards/megaman-electricity.md](../../objects/hazards/megaman-electricity.md) |
| TriggerSpike | 36 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| LongMovingSpike | 9 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| ElectricityBeam | 5 | [../../objects/hazards/electricity-beam.md](../../objects/hazards/electricity-beam.md) |
| Spring | 9 | [../../objects/interactive/spring.md](../../objects/interactive/spring.md) |
| ConveyorBelt | 4 | [../../objects/platforms/conveyor-belt.md](../../objects/platforms/conveyor-belt.md) |
| FallingPlatform | 8 | [../../objects/platforms/falling-platform.md](../../objects/platforms/falling-platform.md) |
| RotatingPlatform | 2 | [../../objects/platforms/rotating-platform.md](../../objects/platforms/rotating-platform.md) |
| PlatformBelt | 3 | [../../objects/platforms/platform-belt.md](../../objects/platforms/platform-belt.md) |
| MovingPlatformCave1H | 7 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave2H | 2 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| SmallLantern | 20 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| CaveLevelSlidingDoor | 1 | [../../objects/doors/cave-sliding-door.md](../../objects/doors/cave-sliding-door.md) |
| CameraAdjustArea2D | 6 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

## Checkpoints
- 3 — three `CheckPoint` instances.

## Notes
- "Saigo no nobori" = "the final climb". This is the longest, densest non-boss level in the game.
- 13 distinct enemy types appear — almost every shipping enemy.
- Section 1 alone has 6 `MegamanElectricity` units grouped under `MegamanElectricityGroup`, two `TriggerSpikeGroup` columns of 7 each, plus 3 `ElectricityBeam`s.
- Section 5 is the climb itself — 7 `MovingPlatformCave1H` + 2 `MovingPlatformCave2H` ladder with `LaserLantern` and `Hannya` flanking, 12 `MegamanElectricity` in two grouped pillars, and the level's only `Shirime` near the start of Section 1 for atmosphere.
- Exit is `CaveLevelSlidingDoor` (not a regular `Door`) — same key-detection but different visuals.
- Six `CameraAdjustArea2D` instances handle the section-to-section reframing along the climb.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

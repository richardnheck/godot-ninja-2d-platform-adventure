# No yuka...no cry

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level5.tscn`
**Inherits:** LevelBase

## Display name & BGM
"No yuka...no cry" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres`
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `World3-Props-Tileset.tres` — `TileMapProps` (decorative props).
- `CaveLevelTileset.tres` — hidden `TileMapWorld` collision.
- Standalone art: `window.png`, `sashimono.png`, `banners.png`, `pane.png`, `platform-track-for-9-patch-rect.png`, `clouds.png`, `cave-platform-track-80.png`, `door-top.png` (CaveLevelSlidingDoor companion).

Note: this is the first World 3 level to use `World3-Props-Tileset.tres`. No `TileMapSky` here.

## TileMap layers
- Root: `TileMapWorld`, `TileMapBg`, `TileMapTraps` (group `trap`).
- `Section1`–`Section3` each have `TileMapWorld` + `TileMapTraps` + a second `TileMapTrapsHiddenFloor` (also group `trap`) used for invisible kill-floors below platforms.
- `Section4` adds a plain `TileMap`, `TileMapWorld`, `TileMapTraps`.
- `Section5` has `TileMapWorld`, `TileMapTraps`, and `TileMapProps` (props tileset decorations).

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| ShardLantern | 6 | [../../enemies/path-follow/shard-lantern.md](../../enemies/path-follow/shard-lantern.md) |
| TofuKozo | 2 | [../../enemies/throwers/tofu-kozo.md](../../enemies/throwers/tofu-kozo.md) |
| RotatingOnibi | 3 | [../../objects/hazards/rotating-onibi.md](../../objects/hazards/rotating-onibi.md) |
| ChochinObakeShooter | 1 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |
| ChochinObake | 3 | [../../enemies/path-follow/chochin-obake.md](../../enemies/path-follow/chochin-obake.md) |
| ZenchuuNoHikari | 2 | [../../enemies/path-follow/zenchuu-no-hikari.md](../../enemies/path-follow/zenchuu-no-hikari.md) |
| Nekekubi | 3 | [../../enemies/chasers/nekekubi.md](../../enemies/chasers/nekekubi.md) |
| Hannya | 2 | [../../enemies/patrol/hannya.md](../../enemies/patrol/hannya.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| FallingPlatform | 31 | [../../objects/platforms/falling-platform.md](../../objects/platforms/falling-platform.md) |
| PlatformBelt | 6 | [../../objects/platforms/platform-belt.md](../../objects/platforms/platform-belt.md) |
| RotatingPlatform | 3 | [../../objects/platforms/rotating-platform.md](../../objects/platforms/rotating-platform.md) |
| MovingPlatformCave1H | 4 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave2H | 2 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| Spring | 4 | [../../objects/interactive/spring.md](../../objects/interactive/spring.md) |
| TriggerSpike | 3 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| LongMovingSpike | 1 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| ElectricityBeam | 1 | [../../objects/hazards/electricity.md](../../objects/hazards/electricity.md) |
| SmallLantern | 13 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CameraAdjustArea2D | 5 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

## Checkpoints
- 2 — two `CheckPoint` instances.

## Notes
- "Yuka" = floor. Title pun: "no floor... no cry" — the level is built on disappearing/moving floors.
- The `TileMapTrapsHiddenFloor` layers in Sections 1–3 are invisible death floors below the platform sequences — fall off and die instantly.
- Section 1's `PlatformBelt` + `FallingPlatform` chain (4 `PlatformBelt`s, 9 `FallingPlatform`s, plus a `RotatingPlatform`) is the level's signature traversal.
- Section 3 has the densest enemy mix (Nekekubi chasers, Hannya patrols, ShardLantern).
- Five `CameraAdjustAreaDown` instances reframe each section's downward drop.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

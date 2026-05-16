# Obake Kaidan

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level2.tscn`
**Inherits:** LevelBase

## Display name & BGM
"Obake Kaidan" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres` — visible walls/roof.
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `CaveLevelTileset.tres` — hidden collision `TileMapWorld`.
- `sky-tileset.tres` — `TileMapSky`.
- Standalone art: `window.png`, `sashimono.png`, `pane.png`, `clouds.png`, `cave-platform-track-80.png`.

## TileMap layers
- Root: `TileMapBg`, `TileMapSky`, `TileMapWorld`, `TileMapTraps` (group `trap`).
- `Section1`–`Section5` each carry `TileMapNew` (visible art) + `TileMapTraps` (group `trap`). Note: no per-section `TileMapWorld` in this level — root `TileMapWorld` handles all collision.
- `SectionTemplate2` holds unused template tilemaps.

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| Bakezori | 6 | [../../enemies/path-follow/bakezori.md](../../enemies/path-follow/bakezori.md) |
| KasaObake | 3 | [../../enemies/jumpers/kasa-obake.md](../../enemies/jumpers/kasa-obake.md) |
| RotatingOnibi | 5 | [../../objects/hazards/rotating-onibi.md](../../objects/hazards/rotating-onibi.md) |
| TofuKozo | 2 | [../../enemies/throwers/tofu-kozo.md](../../enemies/throwers/tofu-kozo.md) |
| ChochinObakeShooter | 1 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| TriggerSpike | 11 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| LongMovingSpike | 8 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| MovingPlatformCave1H | 3 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave2H | 1 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| SmallLantern | 19 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CameraAdjustArea2D | 1 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

`RotatingOnibi` is technically an object (hazard) — counted in enemies row above because the level files them under each section's `enemies/` node.

## Checkpoints
- 1 — single `CheckPoint` instance.

## Notes
- "Obake Kaidan" = "ghost stairs". The level is a sustained ascent through 5 sections.
- Heavy use of `LongMovingSpike` as oscillating wall hazards, paired with `KasaObake` jumpers and patrolling `Bakezori`.
- Section 5 introduces the moving-platform sequence (`MovingPlatformCave1H` x2, `MovingPlatformCave2H` x1) to reach the exit door.
- Single `CameraAdjustAreaDown` near the end shifts the camera downward over the final drop.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

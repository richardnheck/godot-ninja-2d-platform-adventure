# Taste the Tenshu

**Category:** Level / World 3
**Scene:** `src/levels/World3Levels/World3Level_Level1.tscn`
**Inherits:** LevelBase

## Display name & BGM
"Taste the Tenshu" / `Bgm_World3LevelTheme`

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres` — visible floor/wall/roof art.
- `World3-Background-Tileset.tres` — `TileMapBg` interior pattern.
- `CaveLevelTileset.tres` — hidden `TileMapWorld` collision.
- `sky-tileset.tres` — `TileMapSky` band (shared with World 2).
- Standalone art: `window.png`, `sashimono.png`, `clouds.png`, `world3-door.png`, `world3-door-plain.png`.

See [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md).

## TileMap layers
- Root: `TileMapBg`, `TileMapSky`, `TileMapWorld`, an unnamed `TileMap`, `TileMapTraps` (group `trap`).
- `Section1`/`Section2`/`Section3`/`Section4` each carry their own `TileMap`, `TileMapWorld`, `TileMapTraps` (group `trap`).
- A `SectionTemplate` node holds an unused template `TileMap` + `TileMapTraps` for level-authoring.

## Enemies placed

| Enemy | Count | Doc |
|-------|-------|-----|
| KasaObake | 4 | [../../enemies/jumpers/kasa-obake.md](../../enemies/jumpers/kasa-obake.md) |
| Bakezori | 3 | [../../enemies/path-follow/bakezori.md](../../enemies/path-follow/bakezori.md) |
| ChochinObakeShooter | 3 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |
| TofuKozo | 2 | [../../enemies/throwers/tofu-kozo.md](../../enemies/throwers/tofu-kozo.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| TriggerSpike | 30 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| SmallLantern | 10 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart (CaveDoorStart) | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |

## Checkpoints
- 1 — single `CheckPoint` instance under `InteractiveProps/`.

## Notes
- First World 3 level — introduces the tower theme. Heaviest hazard density is `TriggerSpike` fields across Section 1.
- Section layout (1 → 4) walks the player up and through a four-room ascent. There are no `CameraAdjustAreaDown` instances here.
- No moving platforms, no springs — pure traversal + spike-timing + light enemy avoidance.
- A `Node3` (typo'd parent name) holds two ceiling `SmallLantern`s near the start.

## Dependencies
- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md)

# Klimb that Kuruwa

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level2.tscn`
**Inherits:** `LevelBase` (script attached via `ExtResource(11)`)

## Display name & BGM
"Klimb that Kuruwa" / `Bgm_World2LevelTheme`.

A `kuruwa` is a castle bailey / enclosure. The level introduces the World 2 castle interior — Canon turrets line the walls and FireBallSpinners guard ledges as the player climbs.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps`, also referenced as `TileMapBg`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).

## TileMap layers
- `TileMapSky`
- `TileMapBg` — uses `world2-tileset.tres` as a back-layer decoration (unique to this level among World 2).
- `TileMapWallsRoof`
- `TileMapTraps` (group `trap`)
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapWorld` — hidden collision.

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| Hyakume | 6 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| Canon | 5 | [../../objects/test/guns.md](../../objects/test/guns.md) |
| FireBallSpinner | 3 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |

The Canon scene is implemented in `src/objects/test-objects/Guns/Canon/` but is used as a shipping enemy/hazard from Level 2 onward.

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

## Checkpoints

- 1 `CheckPoint` instance under `InteractiveProps/`.

## Notes

- Introduces Canon turrets and FireBallSpinners — the two hazards that dominate the rest of World 2.
- Six Hyakume eyeballs are the bulk of the enemy roster; they patrol on Path2D loops around walls and ceilings.
- Adds a `TileMapBg` layer that the other World 2 levels do not use.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- Enemy/object docs linked in the tables above.

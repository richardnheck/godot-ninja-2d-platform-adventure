# Uh Oh Ote-mon

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level4.tscn`
**Inherits:** `LevelBase` (script attached via `ExtResource(11)`)

## Display name & BGM
"Uh Oh Ote-mon" / `Bgm_World2LevelTheme`.

The `Ote-mon` is the main castle gate. The level is the densest of the World 2 line-up — a long sprawl past gatehouses, Canon batteries on the walls, and Hyakume sentries.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/pylons-tileset.tres` — `TileMapPylons`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).

## TileMap layers
- `TileMapSky`
- `TileMapWallsRoof`
- `TileMapPylons`
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapWorld` — hidden collision.
- `TileMapTraps` (group `trap`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| Canon | 16 | [../../objects/test/guns.md](../../objects/test/guns.md) |
| FireBallSpinner | 9 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |
| Hyakume | 8 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| Shirime | 4 | [../../enemies/patrol/shirime.md](../../enemies/patrol/shirime.md) |
| TsurubeOtoshi | 3 | [../../enemies/jumpers/tsurube-otoshi.md](../../enemies/jumpers/tsurube-otoshi.md) |
| Zugaikotsu | 2 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| ClockSwitch | 1 | [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md) |

First appearance of TsurubeOtoshi and Shirime in World 2. The 16 Canon turrets are the heaviest projectile concentration in the world.

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

No `CameraAdjustArea2D` nodes — the level is largely horizontal.

## Checkpoints

- 3 `CheckPoint` instances under `InteractiveProps/` (`CheckPoint`, `CheckPoint2`, `CheckPoint3`) — the first World 2 level with multiple checkpoints, reflecting its length.

## Notes

- Densest enemy roster in World 2 (43 enemy-class instances counting all Canons / FireBallSpinners / ClockSwitch).
- Introduces the four-checkpoint length pattern that Level 5 also adopts.
- Continues the `TileMapPylons` theme from Level 3.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- Enemy/object docs linked in the tables above.

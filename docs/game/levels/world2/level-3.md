# My My Maru

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level3.tscn`
**Inherits:** `LevelBase` (script attached via `ExtResource(11)`)

## Display name & BGM
"My My Maru" / `Bgm_World2LevelTheme`.

A `maru` is a castle bailey. The level is a FireBallSpinner gauntlet stitched together with stone pylons — the level uses the World 2 `pylons-tileset` for the first time.

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
- `TileMapPylons` — new this level (vertical stone pylons player can walk between).
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapWorld` — hidden collision.
- `TileMapTraps` (group `trap`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| FireBallSpinner | 19 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |
| Canon | 4 | [../../objects/test/guns.md](../../objects/test/guns.md) |
| Zugaikotsu | 2 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| Hyakume | 2 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| ClockSwitch | 1 | [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md) |

The ClockSwitch is parented under the `Enemies` node here (rather than `InteractiveProps`) — the same pattern as Level 4 / Level 5 — but it is still the interactive timing switch from `src/objects/clock-switch/`.

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 3 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

The three `CameraAdjustArea2D`s are grouped under a `CameraAreas` node — one "down" adjuster and two reset-back-to-default markers, used to bias the camera while the player descends among the pylons.

## Checkpoints

- 1 `CheckPoint` instance under `InteractiveProps/`.

## Notes

- The FireBallSpinner count (19) is the highest in any World 2 level.
- First level to use `TileMapPylons` and the first to ship `CameraAdjustArea2D` nodes.
- First appearance of Zugaikotsu in World 2.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- Enemy/object docs linked in the tables above.

# Help! Help! Hori!

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level5.tscn`
**Script:** `src/levels/World2Levels/World2Level_Level5.gd` (extends `LevelBase`)

## Display name & BGM
"Help! Help! Hori!" / `Bgm_World2LevelTheme`.

The level returns to the moat (`hori`) — water sections, fish, Boats, and a much larger cloud-platform traversal — and adds the Funa-yurei (boat ghosts) as new enemies.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps` and `TileMapWater`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).

## TileMap layers
- `TileMapSky`
- `TileMapWallsRoof`
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapWorld` — hidden collision.
- `TileMapTraps` (group `trap`).
- `TileMapWater` (groups `trap`, `water-trap`) — the only `TileMapWater` in the shipping game.

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| WaterJumpYokaiSpawner | 16 | [../../objects/hazards/water-jump-yokai.md](../../objects/hazards/water-jump-yokai.md) |
| FireBallSpinner | 11 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |
| Kappa | 4 | [../../enemies/path-follow/kappa.md](../../enemies/path-follow/kappa.md) |
| Zugaikotsu | 4 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| ClockSwitch | 2 | [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md) |
| FunaYurei | 2 | [../../enemies/path-follow/funa-yurei.md](../../enemies/path-follow/funa-yurei.md) |
| TsurubeOtoshi | 1 | [../../enemies/jumpers/tsurube-otoshi.md](../../enemies/jumpers/tsurube-otoshi.md) |

First appearance of FunaYurei in World 2.

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| CloudPlatform | 24 | [../../objects/platforms/cloud-platform.md](../../objects/platforms/cloud-platform.md) |
| Boat | 2 | [../../objects/interactive/boat.md](../../objects/interactive/boat.md) |
| CameraAdjustArea2D | 3 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| Door | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

## Checkpoints

- 2 `CheckPoint` instances under `InteractiveProps/` (`CheckPoint`, `CheckPoint2`).

## Notes

- Only level in the game with a `TileMapWater` layer. The tilemap is placed in both the `trap` and `water-trap` groups; the `water-trap` route to `DieByWater` is wired in `player_controller.gd` but commented out, so contact with water currently triggers the normal death path.
- Only level in World 2 to ship `Boat.tscn` instances.
- Highest CloudPlatform count in the world (24).
- **Level-specific script behavior** (`World2Level_Level5.gd`):
  - On `_ready`, fetches the player's `CameraManager` and calls `set_y_offset_type(CameraManager.yOffsetType.OFFSET_DOWN)`.
  - The script comment explains the rationale: "Always set the y offset of the camera to be down for this level. It is easier to do it in a script here than adding camera adjust areas at the start and at the checkpoints, so camera is set properly if player respawns."
  - This overrides the normal CameraAdjustArea-driven behavior — the camera always biases downward regardless of which checkpoint the player respawns at. The three `CameraAdjustArea2D` nodes still present (`CameraAdjustAreaResetToUp`, `CameraAdjustAreaDown`, `CameraAdjustAreaResetToUp2`) handle local overrides in specific sub-sections.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- [../../objects/camera/camera-manager.md](../../objects/camera/camera-manager.md) — for `set_y_offset_type` and the `yOffsetType` enum.
- Enemy/object docs linked in the tables above.

# Towards the Tenshu

**Category:** Level / World 2
**Scene:** `src/levels/World2Levels/World2Level_Level6.tscn`
**Inherits:** `LevelBase` (script attached via `ExtResource(11)`)

## Display name & BGM
"Towards the Tenshu" / `Bgm_World2LevelTheme`.

Final non-boss World 2 level. The `tenshu` is the castle's central keep. The level previews the boss by introducing WanyudoMini spawners — flaming wheels that roll along the floor — and ends by transitioning the player into a cave-tileset corridor leading to the keep.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.
- `assets/art/tilesets/world2/world2-props-tileset.tres` — `TileMapProps` (the only level in the game that uses this).
- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — `TileMapCaveLevel` (used for the final corridor leading toward the keep).

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md) and [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers
- `TileMapSky`
- `TileMapWallsRoof`
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapProps` — new this level (uses `world2-props-tileset.tres`).
- `TileMapTraps` (group `trap`).
- `TileMapWorld` — hidden collision.
- `TileMapCaveLevel` — cave-themed bridge into the keep, layered on top.

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| FireBallSpinner | 19 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |
| ClockSwitch | 6 | [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md) |
| Canon | 6 | [../../objects/test/guns.md](../../objects/test/guns.md) |
| WanyudoMiniSpawner | 6 | [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) |
| FunaYurei | 3 | [../../enemies/path-follow/funa-yurei.md](../../enemies/path-follow/funa-yurei.md) |
| Zugaikotsu | 3 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| TsurubeOtoshi | 2 | [../../enemies/jumpers/tsurube-otoshi.md](../../enemies/jumpers/tsurube-otoshi.md) |
| Hyakume | 1 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| Shirime | 1 | [../../enemies/patrol/shirime.md](../../enemies/patrol/shirime.md) |

WanyudoMini scenes themselves are not instanced directly — they are emitted at runtime by `WanyudoMiniSpawner.tscn`. See [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md).

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| CloudPlatform | 6 | [../../objects/platforms/cloud-platform.md](../../objects/platforms/cloud-platform.md) |
| MovingPlatformCave2H | 3 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| WanyudoMiniKillArea | 3 | [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) |
| CameraAdjustArea2D | 3 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |
| MovingPlatformCave1H | 1 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| CaveLevelSlidingDoor | 1 | [../../objects/doors/cave-sliding-door.md](../../objects/doors/cave-sliding-door.md) |
| KamonKey | 1 | [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |

`Door` (the standard `Door.tscn`) is replaced here by `CaveLevelSlidingDoor.tscn` — the level uses the sliding cave door variant as its exit to fit the cave-corridor finale.

## Checkpoints

- 3 `CheckPoint` instances under `InteractiveProps/` (`CheckPoint`, `CheckPoint2`, `CheckPoint3`).

## Notes

- Introduces `WanyudoMiniSpawner` (and its companion `WanyudoMiniKillArea` cleanup zones) as a preview of the boss.
- The only level to use both `TileMapProps` (world2 props) and `TileMapCaveLevel` (cave tileset), reflecting the visual transition from castle wall to keep interior.
- The `CaveLevelSlidingDoor` exit hooks into the boss-intro cutscene via the standard LevelData progression.
- Uses `MovingPlatformCave2H` / `MovingPlatformCave1H` (the cave-level moving platforms) rather than World-2-specific platforms.
- A `sashimono.png` (war banner) is referenced as a sprite asset — same prop used in the boss arena.

## Dependencies

- [../level-base.md](../level-base.md)
- [overview.md](overview.md)
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md) — for the `TileMapCaveLevel` overlay.
- Enemy/object docs linked in the tables above.

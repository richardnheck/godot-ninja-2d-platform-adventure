# World 2 — Within the Walls

**Category:** Level / World 2
**Folder:** `src/levels/World2Levels/`
**Tilesets:** [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md)

The second world. The player has climbed out of the cave and is now navigating the castle walls, outer baileys (`maru`), gates (`mon`) and ramparts on the way up toward the keep (`tenshu`). Visually it is dominated by stone, wooden slats, stacked bricks and an open sky; mechanically it introduces water, falling traps, canon fire and the first multi-checkpoint levels.

## BGM

- **Levels 1–6:** `Bgm_World2LevelTheme` (`world2 level theme song.ogg`) — node under `Game_AudioManager/BGM/`. Not exposed as a typed `bgm_*` var on the AudioManager script; resolved at runtime by `Game_AudioManager.play_bgm_by_node_name(LevelData.get_level_bgm(scene_path))` (see [../../systems/autoloads.md#Game_AudioManager](../../systems/autoloads.md)).
- **Boss level:** `Bgm_World2LevelBossTheme` (`world2 boss theme song.ogg`) — played explicitly by `World2Level_Boss.gd` via `Game_AudioManager.play_bgm_world2_level_boss()`.

## Level list (from `LevelData.levelsArray`)

`LevelData.WORLD2` levels, in play order. Indexes are positions in the global `levelsArray`.

| Index | Display name | Scene | Doc |
|------:|--------------|-------|-----|
| 7 | "Hold your Hori" | `World2Level_Level1.tscn` | [level-1.md](level-1.md) |
| 8 | "Klimb that Kuruwa" | `World2Level_Level2.tscn` | [level-2.md](level-2.md) |
| 9 | "My My Maru" | `World2Level_Level3.tscn` | [level-3.md](level-3.md) |
| 10 | "Uh Oh Ote-mon" | `World2Level_Level4.tscn` | [level-4.md](level-4.md) |
| 11 | "Help! Help! Hori!" | `World2Level_Level5.tscn` | [level-5.md](level-5.md) |
| 12 | "Towards the Tenshu" | `World2Level_Level6.tscn` | [level-6.md](level-6.md) |
| 13 | "Stage2 Boss" | `World2Level_Boss.tscn` (via `BossintroCutScene.tscn`) | [boss-level.md](boss-level.md) |

The boss row in `LevelData` points `scene_path` at the World 2 boss-intro cutscene; that cutscene then changes scene to `boss_scene_path = res://src/levels/World2Levels/World2Level_Boss.tscn`. See [../../ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) and [../../ui/cutscenes/boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md).

## Tilesets used across the world

All six levels and the boss share the same visual-vs-collidable split (see [../tilemaps/overview.md](../tilemaps/overview.md)): a hidden `TileMapWorld` carries the actual collision while several themed visual TileMaps stack on top.

Common tilesets in every World 2 level:

- `world2-tileset.tres` — `TileMapTraps` (water, flame, spikes).
- `sky-tileset.tres` — `TileMapSky`.
- `roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `bricks_tileset.tres` — `TileMapBricks`.
- `wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `stone-ground-tileset.tres` — `TileMapWorldStone`.
- `stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

Per-level extras:

- `pylons-tileset.tres` — Level 3, Level 4 (`TileMapPylons`).
- `world2-props-tileset.tres` — Level 6 (`TileMapProps`).
- `cave-level/CaveLevelTileset.tres` — Level 6 also lays a `TileMapCaveLevel` cave layer for the final keep entry.

The Boss level reuses the same set (no pylon tileset — the boss uses `pylon.png` as free-standing `Sprite`s instead) and adds a custom `TileMapWallColumns` layer.

## Mechanics introduced

- **Water (`TileMapWater`)** — Level 5 only. Tagged in both `trap` and `water-trap` groups; kills on contact via the trap collision path.
- **Boat (`Boat.tscn`)** — Level 5 only. Player-driven raft across water sections. See [../../objects/interactive/boat.md](../../objects/interactive/boat.md).
- **WaterJumpYokai spawners** — fish that breach the water surface as moving hazards (Level 1, Level 5). See [../../objects/hazards/water-jump-yokai.md](../../objects/hazards/water-jump-yokai.md).
- **CloudPlatforms** stretched out as long traversal paths over water and gaps (Level 1, Level 5, Level 6). See [../../objects/platforms/cloud-platform.md](../../objects/platforms/cloud-platform.md).
- **Canon turrets** (`Canon.tscn` + `CanonBall.tscn`) — used widely from Level 2 onward as stationary throwers despite being implemented in the `test-objects/Guns/` folder. See [../../objects/test/guns.md](../../objects/test/guns.md).
- **FireBallSpinner** — the dominant World 2 hazard, present in every level from Level 2 onward. See [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md).
- **ClockSwitch** — appears from Level 3 onward, gating timing puzzles around FireBallSpinners. See [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md).
- **Multiple checkpoints per level** — Level 4 and Level 5 ship with 3 / 2 `CheckPoint` instances respectively (the cave levels mostly had at most one). See [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md).
- **CameraAdjustArea2D** — used from Level 3 onward to bias the camera down for vertical descents. See [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md).
- **WanyudoMini** — mini-boss flaming wheel enemies introduced in Level 6 as a preview of the boss. See [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md).

## Enemies appearing in World 2

| Enemy | First appears | Doc |
|-------|---------------|-----|
| Kappa | Level 1 | [../../enemies/path-follow/kappa.md](../../enemies/path-follow/kappa.md) |
| Hyakume | Level 2 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| Zugaikotsu | Level 3 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| TsurubeOtoshi | Level 4 | [../../enemies/jumpers/tsurube-otoshi.md](../../enemies/jumpers/tsurube-otoshi.md) |
| Shirime | Level 4 | [../../enemies/patrol/shirime.md](../../enemies/patrol/shirime.md) |
| FunaYurei | Level 5 | [../../enemies/path-follow/funa-yurei.md](../../enemies/path-follow/funa-yurei.md) |
| WanyudoMini | Level 6 | [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) |
| Wanyudo (boss) | Boss | [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) |

## Dependencies

- [../level-base.md](../level-base.md) — every World 2 scene inherits or attaches `LevelBase.gd`.
- [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md) — tileset definitions.
- [../../systems/autoloads.md](../../systems/autoloads.md) — `LevelData`, `Game_AudioManager`.
- [../../ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md), [../../ui/cutscenes/boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md) — World 2 boss bookends.

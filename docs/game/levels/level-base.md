# LevelBase

**Category:** Level / Base
**Script:** `src/levels/LevelBase.gd` (`class_name LevelBase`)
**Extends:** `Node2D`

Base scene/script that every level inherits or instantiates from. Owns player spawn, BGM, fades, screen shake, intro title, checkpoint coordination, key/door wiring, camera limits, completion routing, and death/restart flow.

## Purpose
Wires together the runtime systems each level needs so individual `LevelN.tscn` files only have to lay out tiles, place objects/enemies, set spawn position, and (sometimes) override behavior. The shipping levels almost always rely on the default LevelBase logic.

## Required scene-tree children
A LevelBase-derived `.tscn` MUST contain these nodes (by exact name) for the script to work:
- `PlayerSpawnPosition` — Node2D, player's normal spawn point.
- `TempSpawnPosition` — optional debug spawn (only honoured in non-`standalone` builds).
- `TileMapWorld` — the main collidable world TileMap (used for camera bounds).
- `TileMapTraps` — the hazard TileMap; added to the `trap` group at ready.
- `InteractiveProps/KamonKey` — optional, only if the level has a key.
- `InteractiveProps/Door` — optional level-exit door.
- `Props/DoorStart` — visual start door for the player.
- `EndTimer` — optional.
- `MobileControlsHUD` — required (added per level; provides level timer + on-screen controls).

## Preloaded scenes
- `src/UI/FadeScreen/FadeScreen.tscn` — instanced as a child for transitions.
- `src/objects/camera-effects/ScreenShake.tscn` — instanced, given the active camera path.
- `src/UI/Controls/LevelIntroTitle/LevelIntroTitle.tscn` — instanced on first load (not on reload) if `Settings.get_show_level_names_enabled()` and the level has a name in `LevelData`.
- `src/characters/player/Player.tscn` — instanced and placed at spawn point.

## Ready flow
1. Preloads `WorldSelect.tscn` (prevents HTML5 audio stutter on later transition).
2. Plays the level BGM via `Game_AudioManager.play_bgm_by_node_name(LevelData.get_level_bgm(scene_path))`.
3. Calls `Actions.use_normal_actions()` to clear any cutscene input state.
4. Initializes every checkpoint in the `checkpoint` group: calls `set_on(LevelData.level_checkpoint_reached)`, hides them if `Settings.level_checkpoints_enabled` (or `boss_level_checkpoints_enabled` for boss levels) is false, connects each one's `reached(id)` signal.
5. Calls `_spawn_player()` — chooses spawn from `TempSpawnPosition` (debug only) → most recent checkpoint → `PlayerSpawnPosition` → `DoorStart`. Sets `z_index = 10000` so the player is always in front.
6. Connects player signals: `start_die` → screen shake; `died` → reload; `collided` → trap detection.
7. Distributes the player reference to every enemy via `get_tree().call_group("enemy", "set_player", player)`.
8. Wires the key's `captured` and the door's `player_entered` signals if present.
9. Instances FadeScreen.
10. Adds the trap tilemap to the `trap` group.
11. Attaches the player's CameraManager-managed Camera2D to the level (`camera.current = true`).
12. `set_player_camera_limits()` — clamps the camera to the TileMapWorld's used rect (bottom limit is `bounds.end.y` exactly, so mobile buttons don't crop the player).
13. Instances ScreenShake and points it at the camera.
14. Calls `Projectiles.remove_all()` to clear leftover bullets from a previous attempt.
15. If the player already has the key (from a checkpoint reload), opens the door and hides the key.
16. On first load (not reload): resets the Stopwatch and LevelMetrics death counter.
17. On first load + names enabled: shows the LevelIntroTitle and waits for its `finished` signal before continuing.

## Level completion (`Door.player_entered` or end-area body_entered)
1. `Stopwatch.toggle_pause()` — stop the timer.
2. `Game_AudioManager.sfx_ui_level_clear.play()`.
3. `player.celebrate()` to enter the celebrate state.
4. `_progress_player_and_goto_next_level(true, 2.5)` after 2.5 s:
   - `Analytics.track_levels_completed()` and `track_event_level_completed(index, time)`.
   - `GameState.update_level_result(index, time, deaths)` — updates PB if faster.
   - Computes the time delta vs. PB, shows it via `hud.set_level_time_status("+/-Xs")`, and stashes it on `GameState.latest_level_time_status` / `latest_level_time_formatted` so the boss-clear cutscene can display it.
   - If time improved or was the first result, posts a new leaderboard entry via `Analytics.add_level_leaderboard_entry(...)`.
   - Bumps `GameState.progress_current_level(index + 1)`.
   - Calls `LevelData.goto_next_level()` to change the scene.

## Boss levels
Boss levels override `_on_EndArea_body_entered` to call `_handle_boss_level_complete()` instead of `_progress_player_and_goto_next_level()`. The boss-clear logic does not auto-advance — the boss-clear cutscene navigates onward itself.

## Death flow (`player.died` signal)
1. `Analytics.track_deaths()` / `LevelMetrics.increment_deaths()` / `track_event_level_attempted(...)`.
2. Wait 0.2 s.
3. `fadeScreen.reload_scene()` + `LevelData.reload_level()` (which preserves checkpoint state and applies the key-retention rule).

## Trap collision detection (`player.collided` signal)
- If the collider is a TileMap in the `trap` group, calls `player.die(tilemap.get_groups())`.
- This is how the trap tilemap kills the player. Note: `water-trap` group routing is set up but the `DieByWater` branch is commented out in `player_controller.gd`.

## Checkpoint dispatch
- On `_on_CheckPoint_reached(id)`: turns off ALL checkpoints in real time, turns the named one on, records via `LevelData.set_checkpoint_reached(id)`.
- Re-entering the level after death respawns at this checkpoint and may preserve the key (see [../systems/autoloads.md#GameState](../systems/autoloads.md)).

## Helper methods
- `calculate_tilemap_bounds(tilemap)` — uses `tilemap.get_used_rect()` × cell size + scale to get world-space bounds.
- `get_collision_tile_name(collision)` — backs out the collider tile from a `KinematicCollision2D` and returns the tile name from the TileSet (used for finer-grained collision identification — not active in shipping code).

## Helpers in `src/levels/` (referenced from this doc, not separate files)

### `LevelCamera.gd`
Programmatic Camera2D variant. Currently unused — the player's `CameraManager` provides the active camera. The `EXPERIMENTAL` block in `_ready()` shows the wired-but-disabled code.

### `LevelMetrics.gd`
Autoload. Tracks `deaths` for the current level. `reset_deaths()` is called when the level first loads, `increment_deaths()` on every `_on_Player_died`.

### `BossPhaseTransitionArea2D.gd`
Lives under `World2Levels/` and `World3Levels/`. An Area2D that drives boss phase transitions when the player enters — used by world 2/3 boss levels to push the boss from phase 1 to phase 2 at a specific arena location.

### `TutorialPanels.gd`
Lives under `CaveLevels/`. Drives the on-screen tutorial panels shown in early World 1 levels (jump, wall slide, etc.). Pairs with `HelpSign` placements.

## Embedded UI components (no separate doc — referenced here)

These UI overlays are added by LevelBase or by each level's `MobileControlsHUD`. They do not have their own doc files (see [conventions.md](../conventions.md)).

| Component | Path | Role |
|-----------|------|------|
| `MobileControlsHUD` | `src/UI/MobileControlsHUD.tscn` + `.gd` | Touch overlay with directional + jump + pause buttons; hosts the in-level `LevelTimer` and level time status display (`set_level_time_status`, `get_level_time_formatted`). |
| `LevelTimer` | `src/UI/LevelTimer/LevelTimer.tscn` + `.gd` (`class_name LevelTimer`) | Reads `Stopwatch` and renders the current elapsed time. Visible iff `Settings.show_level_timer_enabled`. |
| `LevelIntroTitle` | `src/UI/Controls/LevelIntroTitle/LevelIntroTitle.tscn` | Shown on first level load; displays the level name from `LevelData`; emits `finished` when its fade completes. |
| `FadeScreen` | `src/UI/FadeScreen/FadeScreen.tscn` + `.gd` (`class_name FadeScreen`) | Reusable fade overlay; `reload_scene()` triggers the reload after death. See [../systems/frameworks.md](../systems/frameworks.md). |
| `ScreenShake` | `src/objects/camera-effects/ScreenShake.tscn` + `.gd` | Applied on death (`0.05` length, power `8`, priority `200`). See [../objects/camera/screen-shake.md](../objects/camera/screen-shake.md). |

## Dependencies
- [../player/player.md](../player/player.md) — instanced and connected here.
- [../systems/autoloads.md](../systems/autoloads.md) — `LevelData`, `GameState`, `Settings`, `Stopwatch`, `LevelMetrics`, `Game_AudioManager`, `Actions`, `Analytics`, `Projectiles`, `Constants`.
- [../objects/interactive/checkpoint.md](../objects/interactive/checkpoint.md), [kamon-key.md](../objects/interactive/kamon-key.md), [../objects/doors/cave-door.md](../objects/doors/cave-door.md), [cave-sliding-door.md](../objects/doors/cave-sliding-door.md) — interactive props placed under `InteractiveProps/` and `Props/`.
- [../objects/camera/camera-manager.md](../objects/camera/camera-manager.md) — supplies the active camera.
- [tilemaps/overview.md](tilemaps/overview.md) — the TileMapWorld / TileMapTraps layer pattern.

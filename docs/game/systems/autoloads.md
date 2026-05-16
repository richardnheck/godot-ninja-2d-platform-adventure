# Autoload Singletons

Every autoload registered in `project.godot` `[autoload]`. Each is globally accessible by name. Order shown is the order they appear in `project.godot` (load order matters — `Env`, `Actions`, `Constants`, `LevelData` must be available before any scene tries to use them).

---

## Env

**Path:** `src/lib/env.gd`
**Type:** Node (script-only autoload)

Loads `env.cfg` (or `env.cfg.example` in dev). Provides keys for analytics endpoints and similar. Used by `Analytics` singleton.

---

## Actions

**Path:** `src/settings/Actions.gd`
**Type:** Node (script-only)

Input action name registry with a cutscene override.

Constants:
- `JUMP = "jump"`, `MOVE_LEFT = "move_left"`, `MOVE_RIGHT = "move_right"`
- `JUMP_CUTSCENE`, `MOVE_LEFT_CUTSCENE`, `MOVE_RIGHT_CUTSCENE` — defined in the project input map but unbound to any device; used by cutscenes to programmatically drive the player.

State:
- `cutscene_actions_enabled: bool = false`

Methods:
- `use_cutscene_actions()` / `use_normal_actions()` — flip the flag.
- `get_action_jump()` / `get_action_move_left()` / `get_action_move_right()` — return the active action name.

Used by every motion state in the player FSM via `Input.is_action_pressed(Actions.get_action_jump())` etc. The player controller injects `InputEventAction` with the cutscene names during cutscenes.

---

## Constants

**Path:** `src/settings/Constants.gd`
**Type:** Node (script-only)

Game-wide constants.

- `FLOOR_NORMAL = Vector2.UP`
- `SNAP_DIRECTION = Vector2.DOWN`, `SNAP_LENGTH = 16.0` (pixels)
- Groups: `GROUP_PLAYER = "player"`, `GROUP_KEY = "key"`, `GROUP_DOOR = "door"`, `GROUP_TRAP = "trap"`, `GROUP_WATER_TRAP = "water-trap"`, `GROUP_CHECKPOINT = "checkpoint"`, `GROUP_KILLABLE_ENEMY = "killable-enemy"`, `GROUP_BOSS = "boss"`
- `MASK_PLAYER = 0`
- Checkpoints: `NO_CHECKPOINT = ""`

---

## LevelData

**Path:** `src/settings/LevelData.gd`
**Type:** Node (script-only)
**Signals:** `key_status_changed`

The single source of truth for level metadata + the active progression cursor. Also handles scene transitions.

Constants:
- `WORLD1 = 1`, `WORLD2 = 2`, `WORLD3 = 3`, `GAME_END = 4`
- `LEVELS_PER_WORLD = 7`
- World level path prefixes (`res://src/levels/CaveLevels/World1Level_`, etc.)
- BGM keys: `CAVE_LEVEL_BGM = "Bgm_CaveLevelTheme"`, `WORLD2_LEVEL_BGM = "Bgm_World2LevelTheme"`, `WORLD3_LEVEL_BGM = "Bgm_World3LevelTheme"` — these are node names looked up under `Game_AudioManager/BGM/<key>` at runtime.

Data:
- `worldsArray` — for each world, the level-select scene path.
- `levelsArray` — ordered list of 22 entries (6 levels + 1 boss per world × 3 worlds + 1 game-end entry). Each entry has `world`, `name` (display), `scene_path`, `bgm`, and for boss rows: `is_boss`, `boss_clear_scene_path`, optional `boss_scene_path`.
- Boss rows point `scene_path` at the boss-INTRO cutscene, not the boss level itself — the cutscene navigates into the `boss_scene_path` when finished.

Runtime state:
- `current_level_index: int` — index into `levelsArray`.
- `level_checkpoint_reached: String`, `checkpoint_reached_with_key: bool`
- `has_key: bool` (setget that emits `key_status_changed`)
- `is_reload: bool` — set when `reload_level()` is called.

Key methods:
- `goto_level(levelIndex, changeScene = true)` — sets index, resets per-level flags, calls `get_tree().change_scene(level.scene_path)`.
- `goto_next_level()`, `goto_boss_level(world)`, `goto_boss_clear_cutscene(world)`.
- `reload_level()` — applies the key-retention rule: if the player picked up the key but had not yet hit a checkpoint with it, they lose the key on reload.
- `get_level_bgm(scene_path)`, `is_boss_level(scene_path)`, `get_level_name(scene_path)`, `get_levels_for_world(world)`, `get_current_world_level_select_scene()`.

---

## Global

**Path:** `src/UI/Global.tscn`
**Type:** Instanced scene (not a script-only autoload)

Tracks the previous scene for back-navigation. Per the plan this autoload is intentionally not documented in detail — relevant only to scene-navigation glue.

---

## Game_AudioManager

**Path:** `src/lib/AudioManager/AudioManager.tscn` + `AudioManager.gd`
**Type:** Instanced scene
**Signals:** `bgm_just_started(bgm_name)`

Singleton owning every `AudioStreamPlayer` in the game. SFX nodes are children of `$SFX/{Character|Collectibles|Environments|UI|Uncategorized}/`; BGM nodes are children of `$BGM/`. Each onready `sfx_*` / `bgm_*` var on the script points at one of those children, so gameplay code calls e.g. `Game_AudioManager.sfx_env_kasa_obake_jump.play()`.

Bus indices: `MST_BUS = 0`, `SFX_BUS = 1`, `BGM_BUS = 2`. Helpers: `toggle_sound_fx()`, `toggle_music()`, `is_music_muted()`, `set_sound_fx_volume(db)`, `set_music_volume(db)`.

### BGM nodes
| Variable | Node | Stream |
|----------|------|--------|
| `bgm_main_theme` | `Bgm_MainTheme` | main theme song (idea #2).ogg |
| `bgm_story_intro` | `Bgm_StoryIntro` | story intro theme.ogg |
| `bgm_story_outro` | `Bgm_StoryOutro` | story outro theme.ogg |
| `bgm_cave_level_theme` | `Bgm_CaveLevelTheme` | cave level theme song.ogg |
| `bgm_cave_level_boss_theme` | `Bgm_CaveLevelBossTheme` | cave boss theme.ogg |
| `bgm_cave_level_boss_intro` | `Bgm_CaveLevelBossIntro` | cave boss intro.ogg |
| `bgm_cave_level_boss_outro` | `Bgm_CaveLevelBossOutro` | cave boss outro.ogg |
| (none) | `Bgm_World2LevelTheme` | world2 level theme song.ogg |
| `bgm_world2_level_boss_theme` | `Bgm_World2LevelBossTheme` | world2 boss theme song.ogg |
| (none) | `Bgm_World3LevelTheme` | world3 level theme song.ogg |
| `bgm_world3_level_boss_theme` | `Bgm_World3LevelBossTheme` | world3 boss theme song.ogg |
| `bgm_world3_level_boss_outro` | `Bgm_World3BossOutro` | world3 boss outro.ogg |

BGM playback methods: `play_bgm_main_theme()`, `play_bgm_main_theme_skip_start()` (starts at 7.5s), `play_story_intro()`, `play_story_outro(fade_in = true)`, `play_cave_level_boss_intro()`, `play_cave_level_boss_outro()`, `play_bgm_cave_level_boss()`, `play_bgm_world2_level_boss()`, `play_bgm_world3_level_boss()`, `play_bgm_world3_level_boss_outro()`, `play_bgm_by_node_name(name)`. Lower-level: `play_bgm_from_player(player, offset = 0, fade_in = false)`, `play_bgm(stream, volume_db, offset, fade_in)`. Lifecycle: `stop_bgm()`, `dim_bgm()` (`PropertySetterPlayer.play("Dim")`), `undim_bgm()`, `fade_out_bgm(duration)`.

### SFX (full list)
Character: `sfx_character_player_land`, `sfx_character_player_die`, `sfx_character_player_jump`, `sfx_character_player_air_jump`, `sfx_character_player_wall_slide`.

Collectibles: `sfx_collectibles_key`, `sfx_collectibles_demon_seal`, `sfx_collectibles_place_demon_seal`.

Environments: `sfx_env_spikey_rock_thud`, `sfx_env_cave_mini_boss_slam`, `sfx_env_cave_boss_slam`, `sfx_env_crumbling_platform_crumble`, `sfx_env_falling_spike`, `sfx_env_candle_explosion`, `sfx_env_canon_ball_explosion`, `sfx_env_canon_shoot`, `sfx_env_crumbling_platform_explode`, `sfx_env_cloud_platform_explode`, `sfx_env_check_point`, `sfx_env_spring_boing`, `sfx_env_kasa_obake_jump`, `sfx_env_tofu_land`, `sfx_env_lantern_shoot`, `sfx_env_aoandon_lantern_shoot`, `sfx_env_lantern_shard_hit`, `sfx_env_electricity_pulse`, `sfx_env_shirime_snore`, `sfx_env_shirime_walk`, `sfx_env_fish_splash`, `sfx_env_hannya_scream`, `sfx_env_hannya_alert`, `sfx_env_mini_wanyudo_explosion`, `sfx_env_mini_wanyudo_spawn`, `sfx_env_trigger_spike_press`, `sfx_env_cave_sliding_door`, `sfx_env_altar_rumble`, `sfx_env_long_explosion_rumble`, `sfx_env_altar_light_beam_pulse`, `sfx_env_cave_boss_cutscene_slam`, `sfx_env_cave_boss_cutscene_crash`, `sfx_env_cave_boss_cutscene_fall`.

UI: `sfx_ui_level_clear`, `sfx_ui_pause`, `sfx_ui_game_start`, `sfx_ui_general_select`, `sfx_ui_basic_blip_select`, `sfx_ui_world_select` (aliased to Sfx_GameStart), `sfx_ui_confirm`.

Caveat: the player's death sound is `.duplicate()`'d in `player_controller._ready()` because the `VisibilityNotifier2D` fires off-screen and would otherwise kill the singleton-owned stream mid-playback.

---

## Settings

**Path:** `src/settings/Settings.gd`
**Type:** Node (script-only)
**Signals:** `controls_changed`

Per-session user preferences. NOT persisted to disk here — persistence lives in `GameState`.

Flags (all `bool`, with setget):
- `touch_screen_controls_visible` — default true if device has touchscreen + is HTML5 build.
- `cheat_mode` — unlocks all levels.
- `level_checkpoints_enabled`, `boss_level_checkpoints_enabled`
- `show_level_names_enabled`, `show_level_timer_enabled` (note: the `show_level_timer_enabled` setter is currently named `set_show_level_names_enabled` — TBD likely a copy-paste typo, treat as the timer toggle).

Device helpers: `is_html5_build()`, `has_touchscreen()`, `is_mobile()` (probes `OS.has_feature("mobile")` and, in HTML5, runs a JS regex against `navigator.userAgent` to catch iPadOS).

---

## GameState

**Path:** `src/settings/GameState.gd`
**Type:** Node (script-only)

Persistent save state. Save path: `user://castle-yokai-game.save` (binary `var2str` format).

State:
- `progress: Dictionary` — `current_level: int`, `has_watched_story_intro: bool`.
- `user: User` — `identifier`, `display_name` (inner class).
- `level_results: LevelResults` — array of `LevelResult` per playable level; each `LevelResult` stores best/previous/latest `completion_time`, `timestamp` (unix ms), `deaths`.
- `latest_level_time_formatted` / `latest_level_time_status` — transient, for boss-clear cutscene display.

Lifecycle:
- `_ready()` loads via `load_save()`; sets `LevelData.current_level_index` from progress.
- `save()` is called after `progress_current_level()`, `update_level_result()`, `set_has_watched_story_intro()`, `reset_progress()`.

Key methods:
- `progress_current_level(index)` — bumps the high-water mark if `index >` current.
- `update_level_result(index, completion_time, deaths)` — updates per-level result, tracks PB.
- `has_completed_game()` — true when current level index reaches the final entry.
- `cheat(value)` — swaps in/out a temp progress dict that pins level to the max.
- `reset_progress()` — wipe progress, story intro flag, and all level results.

Inner classes `User`, `LevelResults`, `LevelResult` each have `to_var()` / `from_dictionary()` for serialization.

---

## ArrayUtil

**Path:** `src/utility/ArrayUtil.gd` — generic array helpers. See [frameworks.md](frameworks.md).

## Ease

**Path:** `src/utility/Ease.gd` — easing function utilities used by RotatingPlatform, FireballSpinner, etc. See [frameworks.md](frameworks.md).

## Projectiles

**Path:** `src/objects/test-objects/Guns/Projectiles.tscn` (`Projectiles.gd`, extends `Node2D`) — pooled projectile container. Every bullet spawned by `Gun._shoot()` is parented under this autoload via `Projectiles.add_child(bullet)`. Used in shipping by the Cannon turret (see [../objects/hazards/cannon.md](../objects/hazards/cannon.md)) and the WaterJumpYokaiSpawner (see [../enemies/jumpers/water-jump-yokai.md](../enemies/jumpers/water-jump-yokai.md)). Exposes a single helper: `remove_all()` (iterates and `queue_free()`s every child) — called by [`LevelBase`](../levels/level-base.md) on level load to clear any stale projectiles.

---

## IntegerResolutionHandler

**Path:** `addons/integer_resolution_handler/integer_resolution_handler.gd`
**Type:** Third-party plugin autoload.

Handles pixel-perfect integer scaling of the viewport. Configured by `[display] window/integer_resolution_handler/base_height=180` in `project.godot`. See [frameworks.md](frameworks.md).

---

## MainScreenState

**Path:** `src/UI/MainScreen/MainScreenState.gd`
**Type:** Node (script-only)

State machine for the main menu (which sub-panel is showing, which button has focus, etc.). Used by `MainScreen.gd` to drive transitions between the play/settings/credits sub-screens.

---

## Analytics

**Path:** `src/lib/Analytics/analytics.gd`
**Type:** Node (script-only)

Talo analytics integration. Wraps the Talo SDK helpers in `src/lib/Analytics/Talo/*`. Reads endpoints from `Env`. Posts level completion times, deaths and leaderboard entries.

---

## LevelMetrics

**Path:** `src/levels/LevelMetrics.gd`
**Type:** Node (script-only)

Tracks per-level death count for the active session. Reset on level entry by `LevelBase`, incremented every time the player dies.

---

## Stopwatch

**Path:** `src/objects/stopwatch/Stopwatch.gd`
**Type:** Node (script-only, autoloaded — same script also used in-level)

Generic timer with checkpoints and pause/resume. Used as the level timer source.

Signals: `time_resetted`, `pause_state_changed`, `new_checkpoint`.

Methods: `add_checkpoint()`, `reset()`, `toggle_pause()`, `format_time(seconds, pattern)`.

Used by `LevelTimer` UI overlay (referenced from [../levels/level-base.md](../levels/level-base.md)) and by `GameState.update_level_result()` when a level ends.

---

## DebugLog

**Path:** `src/UI/Debug/DebugLog.gd`
**Type:** Node (script-only)

In-game logging overlay used by `GameState`, `Analytics`, and several screens via `DebugLog.log(message)`. The companion `src/UI/Debug/DebugConsole.tscn` is a CanvasLayer overlay that lists `DebugLog` entries during dev; it is NOT autoloaded but can be added to a scene to view logs at runtime.

---

## Load order (from `project.godot` `[autoload]`)
1. Env
2. Actions
3. Constants
4. LevelData
5. Global (scene)
6. Game_AudioManager (scene)
7. Settings
8. ArrayUtil
9. GameState
10. Ease
11. Projectiles (scene)
12. IntegerResolutionHandler
13. MainScreenState
14. Analytics
15. LevelMetrics
16. Stopwatch
17. DebugLog

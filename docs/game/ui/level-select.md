# LevelSelect (Cave / World 2 / World 3)

**Category:** UI / Screen
**Scenes:**
- `src/UI/LevelSelectScreens/CaveLevelSelect.tscn`
- `src/UI/LevelSelectScreens/World2LevelSelect.tscn`
- `src/UI/LevelSelectScreens/World3LevelSelect.tscn`

**Script:** `src/UI/LevelSelectScreens/LevelSelect.gd` (`class_name LevelSelect`) — shared by all three scenes.
**Extends:** `Control`

## Purpose
Per-world level picker. Each of the three world-select scenes attaches the same `LevelSelect.gd` and sets `this_world` (1/2/3) plus `intro_scene_path` (the cutscene file to play before the world starts). Builds the level grid at runtime from `LevelData.get_levels()` and locks levels the player has not yet unlocked.

## Assets
- Backgrounds and icons: `bg.png`, `bg-only.png`, `boss-icon.png`, `boss-icon-white.png`, `cutscene-icon.png`, `progress-icon.png`, `leaderboard-icon.png` (under `src/UI/LevelSelectScreens/`).
- Themes: `assets/themes/cave-level/`, `assets/themes/world2/`, `assets/themes/world3/` (one per world).
- BGM: `Game_AudioManager.play_bgm_main_theme_skip_start()`.
- SFX: `Game_AudioManager.sfx_ui_confirm.play()` on level/boss/intro/clear button presses.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `intro_scene_path` | `String` (FILE) | `""` | Path to that world's boss-intro cutscene; used by `_on_IntroButton_button_up()`. |
| `this_world` | `int` (1..3) | — | Which world this scene represents. |

## Behavior
- `_ready()` preloads `WorldSelect.tscn`, calls `_add_level_leaderboard_screen()` and `_add_progress_screen()` (both instanced at runtime, hidden, world-scoped), hides the loading indicator, and starts the main theme.
- Builds level buttons in a loop over `LevelData.get_levels()`: every entry with matching `world` and `is_boss == false` becomes a `Button.new()` whose text is its 1-based number. Buttons are disabled when `levelIndex > current_level` for the player's current world. Pressing one calls `_level_button_pressed(levelIndex)`.
- On HTML5, `_level_button_pressed` stops BGM, shows the loading indicator, waits 1 s, then fades into the scene (extra delay avoids the click-stutter when audio cuts mid-transition). On native, it goes straight to `_fade_goto_scene`.
- `_fade_goto_scene(levelIndex, show_loading_message)` calls `LevelData.goto_level(levelIndex, false)` to update state and then `fadeScreen.go_to_scene(scene_path, show_loading_message)` to transition.
- `_on_BossButton_button_up` → `LevelData.goto_boss_level(this_world, false)` then fade. Enabled only when `current_level >= boss_level_index`.
- `_on_BossClearCutsceneButton_button_up` → `LevelData.goto_boss_clear_cutscene(this_world, false)` then fade. Visible only when `current_level > boss_level_index` (post-boss).
- `_on_IntroButton_button_up` → fade to `intro_scene_path` (the boss intro cutscene).
- `_on_LeaderboardButton_button_up` / `_on_ProgressButton_button_up` toggle the instanced child screens on; closing them re-hides via `_on_level_leaderboard_closed` / `_on_progress_closed`.

## Signals & Methods
- No own signals.
- Notable methods: `_level_button_pressed(levelIndex)`, `_fade_goto_scene(levelIndex, show_loading_message)`, `_on_BossButton_button_up`, `_on_IntroButton_button_up`, `_on_BossClearCutsceneButton_button_up`.

## Embedded controls
- `LevelButtonsContainer` — populated at runtime with `LevelSelectButton`-styled `Button` instances.
- `BossButton`, `BossClearCutsceneButton`, `IntroButton`, `LeaderboardButton`, `ProgressButton`, `BackButton`.
- `LoadingIndicator` overlay (`%LoadingIndicator`).
- `FadeScreen` (for transitions).
- Instanced at runtime: `LevelLeaderboardScreen` and `ProgressScreen` (world-scoped).
- See `_flow.md` for the embedded-controls inventory.

## Dependencies
- Reached from: `WorldSelect`.
- Transitions to: level scenes via `LevelData.goto_level(...)` (see `../systems/autoloads.md` → LevelData), boss intro cutscene (`intro_scene_path`), boss clear cutscene, or back to `WorldSelect`.
- Autoloads: `GameState`, `LevelData`, `Game_AudioManager`, `Settings`.

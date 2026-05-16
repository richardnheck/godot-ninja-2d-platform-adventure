# CutSceneBase

**Category:** UI / Cutscene
**Scene:** `src/UI/CutScenes/CutSceneBase.tscn`
**Script:** `src/UI/CutScenes/CutSceneBase.gd` (`class_name CutSceneBase`)
**Extends:** `CanvasLayer`

## Purpose
Reusable base scene instanced into every narrative cutscene (story intro, boss intros, boss clears, game end, game credits, plus the Settings "Show Credits" hop). Owns the skip and continue buttons, the fade-screen transition, the screen-shake helper, and the level-timer overlay that flashes the previous level's stopwatch result at the start of the cutscene.

## Assets
- Embeds `src/UI/FadeScreen/FadeScreen.tscn` (instanced in `_ready` via `preload(...)`).
- Embeds `src/objects/camera-effects/ScreenShake.tscn` (instanced in `_ready`).
- `Control/SkipButton` (`src/UI/Controls/SkipButton/SkipButton.tscn`), `Control/ContinueButton` (`src/UI/Controls/ContinueButton/ContinueButton.tscn`), `Control/LevelTimer` (`src/UI/LevelTimer.tscn`), `Control/ClickRect` (`ColorRect` covering the screen for click-to-continue input).

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `skip_to_scene_path` | `String` (FILE) | `""` | Mandatory — the next scene to load when the player skips or the cutscene finishes naturally. `_get_configuration_warning()` flags this in the editor when blank. |

## Behavior
- `_ready()`:
  - Instances `FadeScreen` and `ScreenShake` as children.
  - Initialises the embedded `LevelTimer` from `GameState.latest_level_time_formatted` / `latest_level_time_status` so the previous level's time stays on screen for 3 s at the start of any post-level cutscene; after the 3 s yield, the timer is hidden and the `GameState` transient fields are cleared.
- `goto_next_scene(show_loading_message = false, source_scene_path = "", stop_bgm_on_html5 = true)`:
  - On HTML5 (when `stop_bgm_on_html5`), calls `Game_AudioManager.stop_bgm()`, waits 1 s, then `fadeScreen.go_to_scene(skip_to_scene_path, ...)`. The wait avoids audio-cut clicks during transition.
  - Otherwise, transitions immediately.
- `show_continue(visible)` / `is_continue_button_showing()` — toggle and query the continue button visibility.
- `show_skip(visible)` / `is_skip_button_showing()` — same for the skip button.
- `_on_SkipButton_pressed()` → `goto_next_scene(show_loading_message = is_html5_build)`.
- `_on_ContinueButton_button_up()` and `_on_ClickRect_gui_input(InputEventMouseButton left-press)` both call `do_continue()` which emits `on_continue`. Each consumer (story intro, boss intro, etc.) connects to `on_continue` and gates it on `is_continue_button_showing()` before progressing its dialog yield.

## Signals & Methods
- Signals: `on_continue` — emitted on continue-button press or click-rect tap.
- External methods: `goto_next_scene`, `show_continue`, `show_skip`, `is_continue_button_showing`, `is_skip_button_showing`, `do_continue`.

## Embedded controls
- `SkipButton`, `ContinueButton`, `LevelTimer`, `ClickRect`.
- Instanced at runtime: `FadeScreen`, `ScreenShake`.
- See `_flow.md` and `../../systems/frameworks.md`.

## Dependencies
- Instanced by: every cutscene scene in `src/UI/CutScenes/**`, plus `GameCreditsScene.tscn` and `Settings.tscn` (for the show-credits transition).
- Autoloads: `Game_AudioManager`, `GameState`, `Settings`.

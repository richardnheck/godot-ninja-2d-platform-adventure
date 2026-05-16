# WorldSelect

**Category:** UI / Screen
**Scene:** `src/UI/WorldSelectScreen/WorldSelect.tscn`
**Script:** `src/UI/WorldSelectScreen/WorldSelect.gd`
**Extends:** `Control`

## Purpose
Hub for picking one of the three worlds. Reached from `MainScreen`'s Play button (post-intro) and from cutscene exits. Disables higher-world buttons until the player has progressed far enough — cheat mode (via Settings) bypasses the gate by pinning `GameState.progress.current_level` to the max.

## Assets
- World button textures: `world1-buttons1..4.png`, `world2-buttons1..4.png`, `world3-buttons1..4.png` (normal/hover/pressed/locked states) under `src/UI/WorldSelectScreen/`.
- BGM: `Game_AudioManager.play_bgm_main_theme_skip_start()` (main theme @ 7.5 s offset).
- SFX: `Game_AudioManager.sfx_ui_world_select.play()` on any world-button click (aliased to `Sfx_GameStart` — see `../systems/autoloads.md`).

## Behavior
- `_ready()` preloads `MainScreen.tscn` (HTML5 audio-stutter workaround) and starts the main theme.
- Reads `GameState.progress["current_level"]` and resolves the player's farthest-reached world via `LevelData.get_world(current_level)`.
- World 1 button is always enabled; World 2 is disabled if `current_world < LevelData.WORLD2`; World 3 is disabled if `current_world < LevelData.WORLD3`.
- `_on_World1Button_button_up` → `change_scene("res://src/UI/LevelSelectScreens/CaveLevelSelect.tscn")` (note: World 1 uses `button_up`, the others use `pressed`).
- `_on_World2Button_pressed` / `_on_World3Button_pressed` change scene to the matching `World2LevelSelect.tscn` / `World3LevelSelect.tscn`. Both also `print_debug` the choice.
- Every choice routes through `_play_world_button_click_sound()` first.

## Signals & Methods
- No own signals.
- Methods: `_on_World1Button_button_up()`, `_on_World2Button_pressed()`, `_on_World3Button_pressed()`, `_play_world_button_click_sound()`.

## Embedded controls
- `World1Button`, `World2Button`, `World3Button` — three `Button` controls referenced via unique-name accessors (`%World1Button` etc.). They use the per-world button textures above.
- A `BackButton`/`SettingsButton` may also be present in the scene — TBD, not referenced by the script.
- See `_flow.md` for the embedded-controls inventory.

## Dependencies
- Reached from: `MainScreen` (after story intro) and from any boss-clear cutscene that lands here (e.g. World 2 boss clear in `cutscenes/boss-clear-cutscenes.md`).
- Transitions to: `CaveLevelSelect.tscn` / `World2LevelSelect.tscn` / `World3LevelSelect.tscn` (all documented in `level-select.md`).
- Autoloads: `GameState`, `LevelData`, `Game_AudioManager`, `Settings`.

# Settings

**Category:** UI / Screen
**Scene:** `src/UI/Settings/Settings.tscn`
**Script:** `src/UI/Settings/Settings.gd`
**Extends:** `Control`

## Purpose
Modal settings panel embedded in `MainScreen` (toggled via visibility). Tabbed UI exposing volume sliders, gameplay toggles (checkpoints / level-name display / level-timer display / touchscreen-controls visibility), display options (resolution / window mode — desktop only), and an Extras tab with a hidden 5-click cheat unlock and a "Show Credits" link.

## Assets
- Settings sprites: `setting-frame.png`, `settings-buttons.png`, `option-button-radio.png`, `option-button-arrow.png`, `controls.png`, `gamepad-controls.png`, `slider-grabber1.png`, `slider-grabber2.png` (under `src/UI/Settings/`).
- Theme: `assets/themes/settings/` (TBD path).
- SFX: `Game_AudioManager.sfx_ui_basic_blip_select` (close, show-credits, test-sound-fx); `Game_AudioManager.sfx_collectibles_demon_seal` (cheat-mode toggle).

## Behavior
- `_ready()` removes the Display tab when running HTML5 (web embed dictates size), then calls `_add_resolutions()` and `_add_window_types()` to populate the OptionButtons.
- `_on_Settings_visibility_changed()` → `_initialize()` syncs UI state from the `Settings` autoload every time the panel is shown: each `OnOffButton.set_on(Settings.get_*())`, plus selected resolution / window type from `OS.window_size` / `OS.window_fullscreen` / `OS.window_borderless`.
- Toggle signals call back into the `Settings` autoload (`set_level_checkpoints_enabled`, `set_boss_level_checkpoints_enabled`, `set_show_level_names_enabled`, `set_show_level_timer_enabled`).
- `_on_ResolutionOptionButton_item_selected` updates `OS.window_size` and recenters; `_on_WindowTypeOptionButton_item_selected` switches fullscreen / borderless / windowed and disables the resolution picker when fullscreen.
- `_on_CheatButton_pressed` increments `cheat_count` — at 5 presses it flips `Settings.cheat_mode` and calls `GameState.cheat(...)` (which pins or restores progress).
- `_on_ShowCreditsButton_pressed` sets `cut_scene_base.skip_to_scene_path = "res://src/UI/GameCreditsScreen/GameCreditsScene.tscn"` then calls `goto_next_scene()` so the credits scene knows the return path via `Global.get_previous_scene()`.
- `_on_CloseButton_pressed` emits `on_closed`; `_on_TabContainer_tab_changed` re-emits the tab index as `on_tab_changed`.
- The `AnimatedTextureRect` cycles player animations on click (`_change_player_animation`) — cosmetic preview only.

## Signals & Methods
- Signals: `on_closed`, `on_tab_changed(tab_index)`.
- External methods: `set_current_tab(tab_index)`.

## Embedded controls
- Volume sliders: `MusicVolumeSlider` (`MusicHSlider`), `SoundFxVolumeSlider` (`SoundFxHSlider`). Each has its own `.tscn` + `.gd` in `src/UI/Settings/`.
- Toggles: `LevelCheckpointsOnOffButton`, `BossLevelCheckpointsOnOffButton`, `ShowLevelNamesOnOffButton`, `ShowLevelTimerOnOffButton` (all `OnOffButton`); `TouchScreenControlsOnOffButton` (mobile only).
- OptionButtons: `ResolutionOptionButton`, `WindowTypeOptionButton`.
- `TabContainer` (Display tab removed on HTML5), `CloseButton`, hidden `CheatButton`, `ShowCreditsButton`, `TestSoundFxButton`, `AnimatedTextureRect`.
- `CutSceneBase` (used solely for the show-credits scene transition).
- See `_flow.md` for the embedded-controls inventory.

## Dependencies
- Embedded in: `MainScreen` (and reachable from the world-2/3 in-level pause overlays — TBD).
- Transitions to: `GameCreditsScene` (Extras → Show Credits).
- Autoloads: `Settings`, `GameState`, `Game_AudioManager`.

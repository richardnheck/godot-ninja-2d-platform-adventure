# MainScreen

**Category:** UI / Screen
**Scene:** `src/UI/MainScreen/MainScreen.tscn`
**Script:** `src/UI/MainScreen/MainScreen.gd`
**Extends:** `CanvasLayer`

## Purpose
Main hub menu — reached from `SplashScreen` after the studio logo. Hosts the Play button (which either jumps into `WorldSelect` or into the story intro on a fresh save), Settings, Quit, and the side-tab entries for Leaderboard / Progress / User / Debug. The Settings, Leaderboard, Progress, and User screens are instanced *as children* and toggled by visibility instead of full scene changes.

## Assets
- Title art and bg: `src/UI/MainScreen/title-screen-bg.png`, `title-screen-text.png`, and the per-button `title-screen-*-button1/2/3.png` triplets.
- Theme: `assets/themes/main/main_theme.tres`.
- SFX: `Game_AudioManager.sfx_ui_basic_blip_select` (every side-tab button); `Sfx_GameStart` is played directly by `MainPlayButton` via its `sound` property.
- BGM: `Game_AudioManager.play_bgm_main_theme_skip_start()` (starts the main theme at 7.5 s offset on every entry to the screen).

## Behavior
- `_ready()` hides all child overlays (Settings, Leaderboard, Progress, User, DebugConsole, DebugButton, OverlayColorRect), hides Quit on HTML5 builds, and restores Settings visibility + active tab from `MainScreenState` (so back-navigation lands the user on the same sub-panel).
- The play button's `next_scene_path` is set conditionally: `WorldSelect.tscn` if the story intro has been watched, otherwise `StoryIntroScreen/StoryIntro.tscn`.
- A `TitleTween` perpetually bobs the `%TitleScreenText` sprite up and down 8 px (`_start_tween` + `_on_TitleTween_tween_completed`).
- Side-tab button handlers play `sfx_ui_basic_blip_select` and toggle the matching child overlay's `visible`. Each overlay emits `on_closed` to flip itself back off.
- `_on_QuitButton_pressed()` posts `MainLoop.NOTIFICATION_WM_QUIT_REQUEST`.
- The hidden DebugButton is only revealed when `Settings.cheat_mode` is true (re-evaluated after Settings closes).

## Signals & Methods
- No own signals.
- Connection slots (all in the `.tscn`): `_on_SettingsButton_pressed`, `_on_QuitButton_pressed`, `_on_LeaderboardButton_pressed`, `_on_ProgressButton_pressed`, `_on_UserButton_pressed`, `_on_DebugButton_pressed`, plus the matching `_on_*_on_closed` handlers and `_on_Settings_on_tab_changed(tab_index)`.

## Embedded controls
- `MainPlayButton`, `SettingsButton`, `QuitButton` (in the VBoxContainer).
- `LeaderboardButton`, `ProgressButton`, `UserButton`, `DebugButton` (in ButtonControls).
- `OverlayColorRect` dimming layer behind modals.
- Instanced child screens (toggled, not navigated): `Settings`, `GameLeaderboardScreen`, `ProgressScreen`, `UserScreen`, `DebugConsole`.
- `FadeScreen`, `TextAnimationPlayer`, `TitleTween`.
- See `_flow.md` for the embedded-controls inventory.

## Dependencies
- Transitions to: `WorldSelect.tscn` or `StoryIntroScreen/StoryIntro.tscn` (via `MainPlayButton.next_scene_path`).
- Autoloads: `Game_AudioManager`, `MainScreenState`, `GameState`, `LevelData`, `Settings`.
- Sub-screens embedded as children: see `settings.md`, `progress-screen.md`, `user-screen.md`, `leaderboard.md`.

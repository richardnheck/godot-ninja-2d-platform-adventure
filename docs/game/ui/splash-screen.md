# SplashScreen

**Category:** UI / Screen
**Scene:** `src/UI/SplashScreen/SplashScreen.tscn`
**Script:** `src/UI/SplashScreen/SplashScreen.gd`
**Extends:** `CanvasLayer`

## Purpose
The project's `run/main_scene` (see `project.godot`). Shows the Parabol Ink studio logo for two seconds, then fades into the main menu. Acts as the game's first frame.

## Assets
- Logo texture: `src/UI/SplashScreen/splash-screen-logo.png` (also `parabol-ink-logo*.png` variants in the same folder).
- Fonts: `assets/fonts/kongtext.tres`, `assets/fonts/m5x7.tres` (for the hidden `DebugLabel` that prints `OS.get_name()`).
- BGM: `Game_AudioManager.play_bgm_main_theme()` is started before the scene change.

## Behavior
- `_ready()` sets the hidden debug label to `OS.get_name()`, preloads `MainScreen.tscn` (HTML5 audio-stutter workaround), and calls `fade_screen.fade_in_current_scene()`.
- A `Timer` autostarts with `wait_time = 2.0`, `one_shot = true`. When it fires, `_on_Timer_timeout()` starts the main menu BGM and tells `FadeScreen` to navigate to `res://src/UI/MainScreen/MainScreen.tscn`.
- The scene has no buttons — it is timer-driven only.

## Signals & Methods
- No own signals.
- Methods: `_ready()`, `_on_Timer_timeout()` (connected via the scene's `[connection]` block).

## Embedded controls
- `FadeScreen` — instanced as a child for the fade-in / scene-change transition. See `_flow.md` and `../systems/frameworks.md`.

## Dependencies
- Transitions to: `MainScreen` (always; the story-intro detour is triggered later, from MainScreen's play button — see `main-screen.md`).
- Autoloads used: `Game_AudioManager` (BGM kickoff).
- TBD — `Sfx_GameStart` is actually played by `MainPlayButton` on `MainScreen.tscn` (via the button's `sound` property), not by SplashScreen itself.

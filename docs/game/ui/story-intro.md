# StoryIntro

**Category:** UI / Screen
**Scene:** `src/UI/CutScenes/StoryIntroScreen/StoryIntro.tscn`
**Script:** `src/UI/CutScenes/StoryIntroScreen/StoryIntro.gd`
**Extends:** `Node`

## Purpose
Opening narrative shown the first time the player presses Play on `MainScreen` (gated by `GameState.get_has_watched_story_intro()`). Plays through three dialog boxes while the player character walks across a tree-and-bushes background, then hands off to the next scene via `CutSceneBase`.

## Assets
- Background art: `src/UI/CutScenes/StoryIntroScreen/background.png`, `treetrunk.png`, `front-tree-leaves-sheet_158x95.png`, `bush-sheet_100x50.png`.
- Player animations: `src/UI/CutScenes/player_animations.tres` (shared cutscene player frames).
- Tilesets: `assets/art/tilesets/cave-level/cave-tileset.png` + `cave-props-tileset.png`.
- Dialog box sprite: `src/UI/CutScenes/big-dialogbox.png`.
- BGM: `Game_AudioManager.play_story_intro()` (`Bgm_StoryIntro`).
- Font: `assets/fonts/m5x7.tres`.

## Behavior
- `_ready()` plays the BGM, switches input to `Actions.use_cutscene_actions()` so the cutscene driver controls the player, hides the continue button, hides all three dialog boxes, then after a 0.25s timer plays the `walk-in` animation on `AnimationPlayer`.
- Crucially, `_ready()` also calls `GameState.set_has_watched_story_intro(true)` immediately — so the flag flips even if the player skips. This guarantees the intro never replays.
- `start_dialog()` (called from the AnimationPlayer track when walk-in finishes) shows dialog 1/2/3 in sequence, awaiting the `continue_sig` between each via `yield(self, "continue_sig")`. After dialog 3 it calls `start_walk_out()` which plays the `walk-out` animation; the AnimationPlayer's final keyframe calls `_goto_next_scene()` which delegates to `CutSceneBase.goto_next_scene()`.
- `jump()` is an AnimationPlayer hook for an in-walk hop.

## Signals & Methods
- Signals: `continue_sig` — internal, emitted by `_on_continue()` when `CutSceneBase` emits `on_continue` and the continue button is visible.
- Methods called from animations: `start_dialog()`, `start_walk_out()`, `jump()`, `_goto_next_scene()`.

## Embedded controls
- `CutSceneBase` — owns the skip/continue buttons, fade-screen, and scene transition wiring. See `cutscenes/cutscene-base.md`.
- Three `DialogBox*` sprites with child `Label` nodes (inline scene content, not standalone controls).
- The companion `StoryIntroScreen/SkipButton.gd` and `Signals.gd` are local helpers; the main wiring goes through `CutSceneBase`.

## Dependencies
- Reached from: `MainScreen` (only when `GameState.get_has_watched_story_intro()` is false).
- Transitions to: target set in `CutSceneBase.skip_to_scene_path` — TBD, set in scene inspector; based on `_flow.md` this is `WorldSelect.tscn`.
- Autoloads: `Game_AudioManager`, `Actions`, `GameState`.
- The same `.tscn` also serves as the cutscene-flavoured doc — see `cutscenes/story-intro-cutscene.md`.

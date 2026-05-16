# GameCreditsScene

**Category:** UI / Screen
**Scene:** `src/UI/GameCreditsScreen/GameCreditsScene.tscn`
**Script:** `src/UI/GameCreditsScreen/GameCreditsScene.gd` (`class_name GameCreditsScene`)
**Extends:** `Node`

## Purpose
Scrolling end-credits scene. Reached after `GameEndCutScene` finishes (game completion path) or from Settings → Extras → Show Credits. The back button's destination is set dynamically based on how the player arrived.

## Assets
- TBD — scene-specific text and any background sprites in `src/UI/GameCreditsScreen/`. The `AnimationPlayer` drives the scroll.
- BGM: `Game_AudioManager.play_story_outro(false)` (`Bgm_StoryOutro`) — `fade_in = false` because the music may already be playing when arriving directly from `GameEndCutScene`.

## Behavior
- `_ready()` starts the story-outro BGM, inspects `Global.get_previous_scene()`:
  - If the previous scene contains `"GameEndCutScene"` or is empty (fallback), `back_button.next_scene_path` is set to `res://src/UI/MainScreen/MainScreen.tscn` — so finishing the game lands the player back home.
  - Otherwise (e.g. opened from Settings), the back button returns to the previous scene path verbatim.
- Hides the continue button (`show_continue_button(false)`), plays the `RESET` animation on `AnimationPlayer`. The credit scroll itself runs as a follow-up track — TBD which animation name plays the scroll proper (likely the default one referenced in the `.tscn`'s `[connection]` block).
- `_goto_next_scene()` forwards to `CutSceneBase.goto_next_scene()`.
- `_on_continue()` re-emits the cutscene continue signal — present for parity with other narrative scenes but not used here since the continue button stays hidden.

## Signals & Methods
- No own signals (`continue_sig` is referenced but not declared at file scope — TBD whether emitted via `CutSceneBase`).
- Methods: `_goto_next_scene()`, `show_continue_button(show)`, `_on_continue()`.

## Embedded controls
- `CutSceneBase` (skip button, fade screen, transition wiring).
- `BackButton` — the only navigation control; its `next_scene_path` is overridden at runtime.
- `AnimationPlayer` driving the scroll.
- See `_flow.md`.

## Dependencies
- Reached from: `GameEndCutScene` (game-completion path) and `Settings` (Extras → Show Credits).
- Transitions to: `MainScreen` or the prior screen, per the back-button destination resolved in `_ready()`.
- Autoloads: `Game_AudioManager`, `Global` (prev-scene tracker).

# GameEndCutScene

**Category:** UI / Cutscene
**Scene:** `src/UI/CutScenes/GameEndCutscene/GameEndCutScene.tscn`
**Script:** `src/UI/CutScenes/GameEndCutscene/GameEndCutScene.gd` (`class_name GameEndCutScene`)
**Extends:** `Control`

## Purpose
Final game-ending narrative shown after the World 3 boss-clear cutscene. Plays a two-part animation (`first-scene` → `last-scene`) over the daimyo castle backdrop, walks the player through four dialog boxes, then runs the `the-end` animation and transitions into `GameCreditsScene`. Triggers `Bgm_StoryOutro` and continues it into the credits.

## Assets
- Sprites: `background.png`, `background-no-castle-glow.png`, `DaimyoSceneBackground.png`, `the-end-sprite.png`, and the `CastleBackgroundSprites/` folder (under `src/UI/CutScenes/GameEndCutscene/`).
- BGM: `Game_AudioManager.play_story_outro(false)` (no fade-in — already audible when the cutscene starts).
- SFX: A duplicated copy of `Game_AudioManager.sfx_env_altar_light_beam_pulse` is added as a child (volume `-15 dB`) and triggered as a per-keyframe sound via `_play_light_pulse_sfx()`. The long-rumble effect `sfx_env_long_explosion_rumble` is duplicated per-call at `-9 dB` in `_play_rumble_sfx()`.

## Behavior
- `_ready()`:
  - Builds the dimmed light-pulse SFX (`sfx_env_altar_light_beam_pulse.duplicate()` at `-15 dB`, added as a child).
  - Hides the continue button, plays `RESET`, then chains `first-scene` → (await `animation_finished`) → `last-scene`.
  - Calls `Game_AudioManager.play_story_outro(false)` once the `last-scene` animation kicks off.
  - Connects `cut_scene_base.on_continue` to `_on_continue` for dialog advancement.
- `_start_dialog()` (called from an AnimationPlayer track during `last-scene`):
  - Sequentially shows `DialogBox1` through `DialogBox4`, calling `show_continue_button(true)` and `yield(self, "continue_sig")` between each.
  - After dialog 4, hides continue + skip buttons (so the player cannot interrupt the finale), plays `the-end`, then on animation finish calls `_goto_next_scene()`.
- `_goto_next_scene()` calls `CutSceneBase.goto_next_scene(show_loading_message = false, source_scene_path = "", stop_bgm_on_html5 = false)` — BGM is intentionally not stopped on HTML5 because the credits scene continues the same `Bgm_StoryOutro` track.

## Signals & Methods
- Signal: `continue_sig` — local, advances the dialog yields.
- Methods: `_start_dialog()`, `_goto_next_scene()`, `_on_continue()`, `show_continue_button(show)`, `_play_rumble_sfx()`, `_play_light_pulse_sfx()`.

## Embedded controls
- `CutSceneBase` (skip / continue / fade / click-rect / level-timer — note the level timer briefly displays the player's final boss-level time at scene start).
- `AnimationPlayer`, four `DialogBox*` controls (`%DialogBox1..4`).
- `the-end-sprite` and the castle composite as visual layers.
- See `_flow.md`.

## Dependencies
- Reached from: `World3BossClearCutScenePart2` (final cutscene of the World 3 boss-clear arc) — see `boss-clear-cutscenes.md`.
- Transitions to: `GameCreditsScene` (set as `skip_to_scene_path` in the editor — confirmed by `GameCreditsScene._ready()` keying off `"GameEndCutScene" in previous_scene` to know it should return home).
- Autoloads: `Game_AudioManager`, `GameState` (via `CutSceneBase`).

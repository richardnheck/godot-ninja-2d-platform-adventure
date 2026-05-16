# Boss Intro Cutscenes (Worlds 1 / 2 / 3)

**Category:** UI / Cutscene
**Scenes:**
- `src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn` — `class_name World1BossIntroCutScene` (extends `Control`)
- `src/UI/CutScenes/World2/BossintroCutScene.tscn` — `class_name World2BossIntroCutScene` (extends `Node`)
- `src/UI/CutScenes/World3/BossintroCutScene.tscn` — `class_name World3BossIntroCutScene` (extends `Node`)

**Scripts:** matching `BossintroCutScene.gd` next to each scene.

## Purpose
Pre-boss narrative cutscene per world. The player walks into the arena, two/three dialog boxes display, the boss "wakes up" (or forms / reveals, depending on world), and the cutscene exits into the actual boss level via `CutSceneBase.goto_next_scene()` whose `skip_to_scene_path` is set to that world's boss scene. The world's level-select scenes set their `intro_scene_path` export to one of these `.tscn` files (see `../level-select.md`).

## Assets
- Shared dialog-box sprites under `src/UI/CutScenes/` (`big-dialogbox.png`, etc.).
- BGM: all three call `Game_AudioManager.play_cave_level_boss_intro()` (the same `Bgm_CaveLevelBossIntro` stream is reused across worlds — TBD whether intentional or copy-paste).
- SFX: `Game_AudioManager.sfx_env_cave_boss_cutscene_slam.play()` on the boss's ground slam, with screen shake `(duration=2, magnitude=4 or 2, frequency=100)`.

## Behavior (common)
- `_ready()` plays the boss-intro BGM, connects `cut_scene_base.on_continue` to `_on_continue`, sets `screen_shake.set_camera_node("Camera2D")`, hides the continue button and the dialog boxes, then calls `_walk_in()` which plays `AnimationPlayer.play("walk-in")`.
- `_start_dialog()` (called from a `walk-in` animation keyframe) shows `DialogBox1` → `DialogBox2` with `yield(self, "continue_sig")` between each, then plays the boss "awake" animation and calls `_walk_out()` (which plays the `walk-out` animation). `_goto_next_scene()` is called from the end-of-`walk-out` keyframe and forwards to `CutSceneBase.goto_next_scene()`.
- `_shake_screen()` is an AnimationPlayer hook that stops the BGM and plays the slam SFX before triggering `screen_shake.screen_shake(...)`.
- `_on_continue()` only re-emits `continue_sig` while the continue button is visible.

## Per-world specifics
**World 1 (`World1BossIntroCutScene`, extends `Control`):**
- Boss is `$Boss/AnimatedSprite` — animation switches to `awake` after dialog 2.
- Slam shake: `screen_shake(2,4,100)`.

**World 2 (`World2BossIntroCutScene`, extends `Node`):**
- Boss has two `AnimatedSprite`s: `$Boss/AnimatedSprite` and `$Boss/FlashAnimatedSprite` (a flash effect played during the reveal).
- 8 Wanyudo flame sprites under `$Boss/Flames/Flame1..8` start hidden; `_reveal_flames()` reveals them one at a time on a 0.1 s cadence.
- `_reveal_boss()` runs the flame reveal, plays the flash AnimatedSprite to completion, then plays `appear` on the main boss sprite.
- Slam shake: `screen_shake(2,2,100)` (smaller magnitude than W1).

**World 3 (`World3BossIntroCutScene`, extends `Node`):**
- No standalone boss `AnimatedSprite` reference in the script — the boss is composed in the scene (likely via `BossForCutscene.tscn` from `src/UI/CutScenes/World3/`) and "forms" as a follow-up animation: `_walk_out()` `yield`s on `walk-out` finishing, then plays `boss-forming`.
- Plays the `RESET` animation in `_ready()` before kicking off `walk-in`.

## Supporting components
- `BossRigidBody.gd` — a near-empty `RigidBody2D` subclass (`_ready`, `_integrate_forces`, `_draw` stubs). Attached to the in-cutscene boss bodies in each `.tscn` so they can be physics-driven by the boss-clear cutscenes. Identical script copies exist in `CaveLevel/`, `World2/`, and `World3/`.
- `CutSceneLantern` (`src/UI/CutScenes/World3/Lantern.gd`, `extends AnimatedSprite`) — World-3-specific animated lantern. On `_ready()` it stores `init_position`, creates a `SceneTreeTween` set to loop with a sine-eased 1.5 s up-3 / down-3 Y oscillation (initially stopped). Exposes `start_oscillating()` / `stop_oscillating()` for AnimationPlayer hooks. Also implements a `trauma`-based screen-shake-style position jitter (`max_offset`, `decay`, `trauma_power`) via `set_trauma(value)` / `add_trauma(amount)`.

## Signals & Methods
- Signal (each): `continue_sig`.
- Methods (each): `_walk_in()`, `_start_dialog()`, `_walk_out()`, `_goto_next_scene()`, `_shake_screen()`, `_on_continue()`, `show_continue_button(show)`. World 2 adds `_hide_flames()`, `_reveal_flames()`, `_reveal_boss()`.

## Embedded controls
- `CutSceneBase` (skip, continue, fade, click-rect, level-timer overlay).
- `MainControl/DialogBox1..3` (DialogBox3 declared but TBD whether used — W1/W2 use only 1 and 2).
- `AnimationPlayer`, `ScreenShake`, `Camera2D`, `Boss` composite, and (W3) `Lantern` instances.
- See `_flow.md` for the embedded-controls inventory.

## Dependencies
- Reached from: each world's `LevelSelect` (when the player presses the boss row, the matching boss-intro cutscene runs first as configured in `LevelData.levelsArray` — see `../../systems/autoloads.md`), or directly from the world's intro button via `LevelSelect.intro_scene_path`.
- Transitions to: the world's boss level scene (set as `CutSceneBase.skip_to_scene_path` in the editor — TBD per scene).
- Autoloads: `Game_AudioManager`, `Actions` (TBD — not used in these scripts but the player walk-in animations likely drive cutscene-action input via `CutSceneBase`).

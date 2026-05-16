# StoryIntro (Cutscene)

**Category:** UI / Cutscene
**Scene:** `src/UI/CutScenes/StoryIntroScreen/StoryIntro.tscn`
**Script:** `src/UI/CutScenes/StoryIntroScreen/StoryIntro.gd`
**Extends:** `Node`

## Purpose
Cutscene-flavoured doc for the same `StoryIntro.tscn` covered as a screen in `../story-intro.md`. Functions as the opening narrative the very first time a save is played: the ninja player walks across a tree-and-bushes scene, three dialog boxes display in sequence, and the player walks out before transitioning into the world-select / first level. No separate cutscene-only file exists — the cutscene IS the entry screen.

## Assets
- Same as `../story-intro.md`. Notably: `src/UI/CutScenes/player_animations.tres` for the walking player, dialog box sprites from `src/UI/CutScenes/big-dialogbox.png`, and the tilesets `assets/art/tilesets/cave-level/cave-tileset.png` + `cave-props-tileset.png`.
- BGM: `Game_AudioManager.play_story_intro()` → `Bgm_StoryIntro`.

## Behavior
Cutscene flow (driven from the `AnimationPlayer` and the `continue_sig`/`on_continue` handshake):
1. `_ready()` calls `Game_AudioManager.play_story_intro()` and `Actions.use_cutscene_actions()`, hides the continue button, hides all three dialog boxes, then waits 0.25 s before playing `walk-in`.
2. `_ready()` also unconditionally sets `GameState.set_has_watched_story_intro(true)` — so even if the player exits early, the intro will never replay.
3. AnimationPlayer's `walk-in` track calls `start_dialog()` at its end, which shows dialog 1 → 2 → 3 with `yield(self, "continue_sig")` between each.
4. After dialog 3, `start_walk_out()` plays the `walk-out` animation. Inside the animation, `_goto_next_scene()` is called and forwards to `CutSceneBase.goto_next_scene()`.
5. `jump()` is an AnimationPlayer hook used to bounce the player mid-walk.

## Signals & Methods
- Signal: `continue_sig` — internal, advances the dialog sequence.
- Methods: `start_dialog()`, `start_walk_out()`, `jump()`, `_goto_next_scene()`, `_on_continue()`.

## Embedded controls
- `CutSceneBase` (skip + continue + fade + click-rect; see `cutscene-base.md`).
- `AnimationPlayer`, `Camera2D`, `TileMapWorld`, `Background`, `Props/Tree`, `PlayerForCutscene` (`AnimatedSprite` in the `player` group).
- `Control/DialogBox1..3` — three sprite-with-label dialog blocks.
- Local helpers: `SkipButton.gd` and `Signals.gd` in the same folder — TBD whether attached in the `.tscn` or vestigial.

## Dependencies
- Reached from: `MainScreen` (first play only — see `../main-screen.md`).
- Transitions to: `CutSceneBase.skip_to_scene_path` (set in the inspector; expected to be `WorldSelect.tscn` per `../_flow.md`).
- Autoloads: `Game_AudioManager`, `Actions`, `GameState`.
- See also `../story-intro.md` for the screen-flavoured version of this same file.

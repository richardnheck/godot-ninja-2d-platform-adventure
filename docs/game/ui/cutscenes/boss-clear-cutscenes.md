# Boss Clear Cutscenes

Post-victory narrative scenes played after each world's boss is defeated. All three worlds share the same general structure (CutSceneBase + AnimationPlayer-driven sequence + dialog boxes + ScreenShake + boss outro BGM) but the choreography differs per world.

Each is its own scene. World 3 is split into two parts (a player-driven Part 1 then an animation-driven Part 2) because of its longer narrative.

---

## World 1 — Cave Boss Clear

**Scene:** `src/UI/CutScenes/CaveLevel/BossClearCutScene.tscn`
**Script:** `src/UI/CutScenes/CaveLevel/BossClearCutScene.gd`
**Extends:** `Node`

### Children expected
`CutSceneBase` (with `%PlayerForCutscene` unique-name child), `Boss` (RigidBody2D), `AnimationPlayer`, `TextAnimationPlayer`, `ScreenShake`, `StageClearText`, `Tween`, `FadeScreen`, `%DemonSeal`.

### Flow
1. `_ready()` stops BGM, hides Continue, switches to cutscene input via `Actions.use_cutscene_actions()`, hides Stage Clear text, plays the `walk_in` animation.
2. Animation track triggers `play_bgm()` → `Game_AudioManager.play_cave_level_boss_outro()`.
3. `do_boss_walk_in()` → plays `boss_walk_in`.
4. `do_boss_jump()` — calls `move_boss_stop`, applies `Vector2(45, -200)` impulse to the RigidBody2D boss, waits 4 s, frees the boss, plays `sfx_env_cave_boss_cutscene_crash`, screen-shakes (`2, 4, 100`), waits 2 s, then `do_grab_talisman()`.
5. `do_grab_talisman()` and subsequent tracks play out the cleanup — picking up the DemonSeal (unique-named `%DemonSeal`), placing it, fading to the next scene.
6. `_physics_process` applies `linear_velocity = (90, 0)` to the boss while `_move_boss_right` is true (driven by animation tracks).

### BGM
`bgm_cave_level_boss_outro` (`cave boss outro.ogg`) via `play_cave_level_boss_outro()`.

### SFX
`sfx_env_cave_boss_cutscene_crash`, `sfx_env_cave_boss_cutscene_slam`, `sfx_env_cave_boss_cutscene_fall` (triggered from animation tracks).

---

## World 2 — Boss Clear

**Scene:** `src/UI/CutScenes/World2/BossClearCutScene.tscn`
**Script:** `src/UI/CutScenes/World2/BossClearCutScene.gd`

Follows the same pattern as World 1: `CutSceneBase`, an animated boss/player choreography, DemonSeal handoff, and final fade to the next world's level select. Plays the World 2 boss outro BGM. TBD — read the script in full for the exact animation track names and DemonSeal placement timing.

---

## World 3 — Boss Clear (two parts)

### Part 1
**Scene:** `src/UI/CutScenes/World3/BossClearCutScenePart1.tscn`
**Script:** `src/UI/CutScenes/World3/BossClearCutScenePart1.gd` (`class_name World3BossClearCutScenePart1`)
**Extends:** `Node`

Dialog-driven setup before the final boss is defeated.

Children: `CutSceneBase`, `MainControl/DialogBox{1,2,3}`, `AnimationPlayer`, `ScreenShake`.

Custom signal: `continue_sig` — emitted when the player presses Continue between dialog boxes.

Flow:
1. `_ready()` plays `RESET` track, switches BGM to `bgm_world3_level_boss_outro` (`Game_AudioManager.play_bgm_world3_level_boss_outro()`), hides Continue, plays `walk-in`.
2. After walk-in completes (animation track), shows `dialog1`, shows Continue. Awaits `continue_sig`.
3. Hides `dialog1`, calls `do_grab_talisman()` → plays `grab_talisman` animation → awaits `animation_finished`.
4. `_start_dialog2()` shows `dialog2`, awaits `continue_sig`, then `do_enter_boss()` (animation that frames the final encounter / hands off to Part 2).

### Part 2
**Scene:** `src/UI/CutScenes/World3/BossClearCutScenePart2.tscn`
**Script:** `src/UI/CutScenes/World3/BossClearCutScenePart2.gd` (`class_name World3BossClearCutScenePart2`)
**Extends:** `Node`

Plays after the final boss fight clears. Concludes the world 3 storyline and transitions to the Game End cutscene. Same anatomy as Part 1 but mostly animation-driven (player has nothing more to confirm). TBD — confirm precise hand-off scene path (likely `GameEndCutScene.tscn`).

---

## Shared characteristics

- **Base class:** every script wraps a `$CutSceneBase` child (see [cutscene-base.md](cutscene-base.md)) which owns the Skip and Continue buttons. The wrapping scripts call `cut_scene_base.show_continue(bool)` to toggle the Continue button per phase.
- **Input:** all switch to cutscene input via `Actions.use_cutscene_actions()`. Player movement during cutscenes is driven by `InputEventAction` injection through `player.move_right()` / `move_left()` / `jump()` / `talk()` / `celebrate()` (see [../../player/player.md](../../player/player.md)).
- **BGM:** `Game_AudioManager.stop_bgm()` first; then world-appropriate outro track.
- **Screen shake:** each scene has its own `ScreenShake` instance pointed at the cutscene camera.
- **Time-elapsed display:** `GameState.latest_level_time_status` and `latest_level_time_formatted` are populated by `LevelBase._progress_player_and_goto_next_level` so the cutscene can display "+0:01.23" or similar at start.
- **DemonSeal handoff:** each world's clear cutscene shows the player obtaining or placing a coloured DemonSeal (Blue for W1, Green for W2, Red for W3 — TBD verify by reading scene `.tscn` files). See [cutscene-items.md](cutscene-items.md).

## Dependencies
- [cutscene-base.md](cutscene-base.md)
- [cutscene-items.md](cutscene-items.md) — DemonSeal placement.
- [../../objects/camera/screen-shake.md](../../objects/camera/screen-shake.md)
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Actions`, `Game_AudioManager`, `GameState`, `LevelData`.
- Hand off to the next world's level-select scene or to [game-end-cutscene.md](game-end-cutscene.md).

# Player

**Category:** Character / Player
**Scene:** `src/characters/player/Player.tscn`
**Controller script:** `src/characters/player/player_controller.gd` (`class_name Player`)
**State machine script:** `src/characters/player/player_state_machine.gd` (extends `src/utility/state_machine/state_machine.gd`)
**Extends:** `KinematicBody2D`

## Purpose
The single playable character — a 2D platformer ninja with ground/air movement, wall slide, wall jump, optional double jump (air-jump), death by collision or off-screen, and cutscene-controlled actions. All movement runs through a stack-based finite-state machine.

## Assets
- Sprite atlas: `src/characters/player/sprites/player.png` (idle 4f@10fps, run 6f@15fps, jump_up 1f, jump_down 1f, slide 2f@5fps, die 8f@15fps, celebrate 31f@15fps, talk 4f@5fps)
- Death visuals: `src/characters/player/sprites/death-effect.png`, `death-bubble.png`
- SFX (via `Game_AudioManager`): `sfx_character_player_die` (duplicated onto the player to avoid premature destruction), `sfx_character_player_jump`, `sfx_character_player_land`, `sfx_character_player_air_jump`
- Effect scenes: `effects/jump/JumpEffect.tscn`, `effects/air-jump/AirJumpEffect.tscn`, `effects/landing-dust/LandingDust.tscn` (see [effects.md](effects.md))

## Physics

| Param | Value | Where |
|------|------:|-------|
| Gravity | +15 px/frame on `velocity.y` | `motion.gd::apply_gravity()` |
| Floor normal | `Vector2.UP` | `move_and_slide()` arg |
| Max slope | π/4 rad (45°) | `move_and_slide()` arg |
| Horizontal speed (ground/air) | `125` px | `motion.gd::horizontal_speed` |
| Jump power | `340` | `Jump.jump_power` |
| Air-jump power | `280` | `AirJump.jump_power` |
| Wall jump power | `295` up, `155` horizontal | `WallJump` exports |
| Coyote time | `0.15` s | `groundedRememberTime` |
| Jump buffer | `0.2` s | `jumpPressedRememberTime` |
| Wall slide gravity | `+3 px/frame` while sliding | `WallSlide.wall_slide_gravity` |
| Wall clamp delay | `0.2` s | `WallClampTimer` |
| Wall-jump cooldown | `0.3` s | `WallJumpCoolDownTimer` |

Wall detection uses four `RayCast2D` nodes: `LeftWallRaycast1/2`, `RightWallRaycast1/2` on collision mask 2.

## Signals
- `direction_changed(new_direction)` — emitted from `set_look_direction()`; AnimatedSprite flip handled in `motion.update_look_direction()`.
- `collided(collision)` — emitted per slide-collision inside `motion.move()`.
- `start_die`, `died` — death sequence boundary signals.
- `screen_exited` — `VisibilityNotifier2D.screen_exited` triggers off-screen death.

## Controller methods (`player_controller.gd`)

- `die(groups = [])` — sets `dead`, disables input/physics via `set_dead()`, plays the duplicated `sfx_die`, transitions to `die` state. (DieByWater branch is commented out — see TBD below.)
- `celebrate()` / `talk()` / `move()` — transition the FSM into the named state (used by cutscenes and level-clear logic).
- `spring(spring_impulse: Vector2)` — pushes the FSM into `jump` and forwards the impulse so the Jump state can add it to base jump velocity (used by springs, bouncy platforms).
- `reset_applied_velocity()` — zeros the X component of the current state's velocity, used to clear conveyor-belt momentum.
- `do_landing()` / `on_jump()` / `on_wall_jump()` / `on_air_jump()` / `on_wall_land()` — play SFX and instance the corresponding effect scene as a sibling of the player.
- Cutscene helpers `move_right()` / `move_left()` / `move_stop()` / `jump()` — synthesise `InputEventAction` events for the `*_cutscene` action names (see `Actions` singleton). The FSM consumes those events the same as real input.

## State machine

The player's FSM extends a generic utility FSM (`src/utility/state_machine/state_machine.gd`) which is used ONLY by the player. The base FSM provides:
- `states_map: Dictionary` of name → state node
- `states_stack: Array` — top is current
- `_change_state(name)` — pops if name is `"previous"`, otherwise replaces top
- Delegates `_input` and `_physics_process` to current state
- `active` setget that wraps `set_process_input` / `set_physics_process`
- Emits `state_changed(current_state)` on every transition

`player_state_machine.gd` adds:
- Player-specific `states_map` (10 states; see below)
- `jumpPressedRemember` carried across states for buffered-jump timing
- Custom `_change_state(state_name, spring_impulse)` that:
  - Refuses to leave `Die` / `DieByWater` (death is terminal)
  - Pushes `jump` onto the stack instead of replacing (so the previous state can resume on land — coyote/buffer behaviour)
  - Forwards `spring_impulse` to `Jump.initialize()`
  - Passes `Jump.jumpPressedRemember` into `Move` / `Idle` / `AirJump` when transitioning, preserving the buffer
- Routes `_input` to `current_state.handle_input(event)`

### State map

| Name | Node | Script | Role |
|------|------|--------|------|
| `idle` | `$Idle` | `states/motion/on_ground/idle.gd` | Grounded, no input. Plays `idle`. Detects move/jump. |
| `move` | `$Move` | `states/motion/on_ground/move.gd` | Grounded, horizontal input. Plays `run` on floor, `jump_down` in air. Spawns movement dust (`ParticlesMove`). Detects landing → `do_landing()`. Detects wall slide / wall jump. |
| `jump` | `$Jump` | `states/motion/in_air/jump.gd` | First/spring jump. Applies `jump_power + spring_impulse` on enter. Variable height: `velocity.y *= 0.5` if jump released while ascending. Plays `jump_up` / `jump_down` by velocity. Detects double-jump press (only when triggered by a real player jump, not a spring). |
| `air_jump` | `$AirJump` | `states/motion/in_air/air_jump.gd` | Double jump with lower power. Plays jump SFX/effect on enter. |
| `wall_slide` | `$WallSlide` | `states/motion/on_wall/wall_slide.gd` | Wall cling: jump held + falling + wall contact. Reduced gravity (`+3`). After the `WallClampTimer` (0.2 s) the player begins sliding. Releasing jump or moving away from the wall exits to `move`. |
| `wall_jump` | `$WallJump` | `states/motion/on_wall/wall_jump.gd` | Explosive off-wall push: `295` up, `155` horizontal away from wall. Spawns a jump effect at `±6 px` offset rotated 90° toward the wall. |
| `die` | `$Die` | `states/die.gd` | Death sequence: disable collision, set dead, play `death-bubble-appear`, wait 0.6 s, emit `died`. State is locked (cannot exit). |
| `die_by_water` | `$DieByWater` | (water-death variant; routing path currently commented out in controller) | Locked terminal state. |
| `celebrate` | `$Celebrate` | `states/celebrate.gd` | Level-clear animation. Disables physics. Plays `celebrate`. |
| `talk` | `$Talk` | `states/talk.gd` | NPC/cutscene talk. Disables physics. Plays `talk`. |

### Motion base (`states/motion/motion.gd`)

Inherited by every motion state. Provides:
- `handle_input(event)` — captures jump press into `jumpPressedRemember`.
- `get_input_direction()` — analog L/R via `Input.get_action_strength(Actions.get_action_move_left/right())`.
- `update_look_direction()` — sets `look_direction` and `AnimatedSprite.flip_h`.
- `apply_gravity()` — `velocity.y += 15`.
- `move(vel)` — wraps `move_and_slide(vel, UP, true, 4, PI/4, false)` and emits `collided` per slide.
- Wall detection: `next_to_left_wall()`, `next_to_right_wall()` (RayCast2D pairs).
- Transition helpers: `detect_and_transition_to_wall_slide`, `detect_and_transition_to_wall_jump`, `detect_and_transition_to_jump`, `detect_and_transition_to_air_jump`, `detect_and_transition_to_ground`.
- `detect_jump(delta)` — coyote/buffer implementation: decays `jumpPressedRemember` and `groundedRemember`, succeeds when both windows are simultaneously open.

### Wall-grab behaviour
`wall_slide.sliding_mode_new = true`:
- Jump held + against wall → cling indefinitely.
- Jump released and no L/R held toward the wall → exit to `move`.
- Press away from wall while still holding jump → transition to `wall_jump`.

## Player input

Read via the `Actions` singleton, which switches between real and cutscene action names:
- `Actions.get_action_jump()` — `jump` or `jump_cutscene`.
- `Actions.get_action_move_left()` / `get_action_move_right()` — same pattern.

See `project.godot` `[input]` section for the physical bindings (arrows / WASD / gamepad face buttons / mouse-left for `shoot` (test only)).

## Shared character base (only used by the player)

These commons scripts are legacy-shared base classes; in practice the player is their only real consumer. Documented here rather than in a separate folder.

### `src/characters/commons/Character.gd` (`class_name Character`, extends `KinematicBody2D`)
- Generic FSM scaffolding: `_initialize_state(initial_state = "Idle")` populates `states_map` from `$States` children, connects `finished` signals to `_change_state`, disables every `DamageZone` child.
- Push-down logic in `_change_state`: `"GettingHit"` is pushed, `"Previous"` pops; anything else replaces the top.
- Generic character condition flags: `is_alive`, `can_attack`, `is_invincible`, `gravity_enable`, `can_double_jump`, etc.
- `_on_Animation_finished(name)` forwards to `current_state._on_Animation_finished(name, self)`.

### `src/characters/Character2.gd` (`class_name Character2`, extends `KinematicBody2D`)
A second variant of the same scaffolding using slightly different flags (`controlled_jump`, `controllable_movement`, `acceleration`, smooth `speed`). Marked legacy — same FSM pattern.

### `src/characters/commons/DamageZone.gd` (`class_name DamageZone`, extends `Area2D`)
- Reusable attack hitbox child of a character state.
- Exports `amount` (default 20), `MASK` (default 2), `KNOCKBACK_FORCE` (default `(5, 0)`).
- `make_damage(body)` computes knockback direction from positions and applies it to `body.knockback_force`.
- Enabled/disabled by an AnimationPlayer track during an attack animation. Disabled by default at character init.

### `src/characters/commons/states/state.gd` (`class_name State`, extends `Node`)
Abstract state interface used by `Character` and `Character2`. Stubs: `enter(host)`, `exit(host)`, `handle_input(host, event)`, `update(host, delta)`, `_on_Animation_finished(name, host)`, `play_sound(host, stream)`. `_ready()` disables process + input by default; the parent FSM toggles them.

### `src/characters/commons/states/motion/motion.gd` (`class_name Motion`)
- `get_input_direction()` — returns a `Vector2` of analog L/R input.
- `update_look_direction(host, direction, scale_multiplier = 1)` — sprite flip via host scale.
- `move(host, direction, speed, acceleration)` — `lerp`-smoothed horizontal motion.

These commons states are NOT what the player's stack-FSM uses — the player has its own state classes under `src/characters/player/states/**`. The commons folder is here for the porting agent to be aware of but the Player port can ignore most of it.

## Scene node names (referenced by scripts)

`Player.tscn` root nodes that scripts assume exist:
`StateMachine`, `AnimatedSprite`, `CollisionShape2D`, `LeftWallRaycast1/2`, `RightWallRaycast1/2`, `OldCamera2D`, `CameraManager` (unique-name `%CameraManager`), `AnimationPlayer`, `VisibilityNotifier2D`, `WallJumpCoolDownTimer`, `WallClampTimer`, `ParticlesMove`, `DeathBubble`, `DeathEffect`, `StateNameDisplayer`.

## Notes / TBD
- `take_damage(attacker, amount, effect)` is a stub — health system isn't wired.
- DieByWater path is set up in the FSM but the controller's `die()` branch on `Constants.GROUP_WATER_TRAP` is commented out. Effective behaviour: water hazards call `die()` and use the normal `die` state.
- `on_wall_slide_start/end` are stubs; the wall-slide SFX line is commented out.
- `Health.gd` / `Stagger` exist as references in commented-out code but are not active for the player.

## Dependencies
- [effects.md](effects.md) — three spawned visual effects.
- [systems/autoloads.md](../systems/autoloads.md) — `Actions`, `Game_AudioManager`, `Constants`.
- [objects/camera/camera-manager.md](../objects/camera/camera-manager.md) — `%CameraManager` instance child.

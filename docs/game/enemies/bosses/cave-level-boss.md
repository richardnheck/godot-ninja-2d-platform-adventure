# CaveLevelBoss

**Category:** Enemy / Boss
**Scene:** `src/characters/enemies/CaveLevelBoss/CaveLevelBoss.tscn`
**Cutscene variant:** `src/characters/enemies/CaveLevelBoss/CaveLevelBossForCutScenes.tscn`
**Script:** `src/characters/enemies/CaveLevelBoss/CaveLevelBoss.gd`
**Extends:** `KinematicBody2D` (does NOT extend `PathFollowEnemyBase` — this boss uses a manual state machine + `move_and_slide`, unlike the World 1/2 bosses)

## Purpose
The World 3 / cave boss: a large oni that hops the arena, slams the ground producing horizontal `SlamBlast` shockwaves, and during slam-phases drops arrays of stalactite spikes onto the player from the ceiling.

## Assets
- Spritesheet: `CaveLevelBosSpriteSheet.png` (referenced via `cave_level_boss_spritesheet.tres`). Two animations: `look-right`, `look-left`.
- SpriteFrames resource: `cave_level_boss_spritesheet.tres`
- Slam shockwave sprites: `slam-blast1.png`, `slam-blast2.png` (2-frame loop at 10 fps inside `SlamBlast.tscn`)
- Aseprite sources: `CaveLevelBoss.aseprite`, `CaveLevelBoss#2.aseprite`
- SFX (via `Game_AudioManager`): `sfx_env_cave_boss_slam` (every floor/ceiling impact and run-and-jump landing). Cutscene-only SFX `sfx_env_cave_boss_cutscene_slam`, `sfx_env_cave_boss_cutscene_crash`, `sfx_env_cave_boss_cutscene_fall` are used by the intro/clear cutscenes, not the live boss.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `gravity` | int | `10` | Y velocity added per physics frame while airborne in `STATE_RUN_AND_JUMP` and `STATE_UP_DOWN_SLAM` MODE_RUN |
| `jump_power` | int | `200` | Upward impulse in `STATE_RUN_AND_JUMP` |

Internal (non-exported) tunables:

| Name | Default | Notes |
|------|---------|-------|
| `speed` | `55` | Horizontal speed in run / up-down |
| `velocity` | `Vector2(40, 0)` | Initial velocity |
| `vertical_speed` | `200` | Y speed in `STATE_UP_DOWN` |
| `speed_updown_slam` | `10` | Horizontal speed in `STATE_UP_DOWN_SLAM` (MODE_SLAM) |
| `vertical_speed_updown_slam` | `350` | Y speed in `STATE_UP_DOWN_SLAM` (MODE_SLAM) |
| `RunAndJumpTimer.wait_time` | `3.0` s | Cooldown between jumps in `STATE_RUN_AND_JUMP` |
| `SlamRunTimer.wait_time` | `2.0` s | Duration of MODE_RUN within `STATE_UP_DOWN_SLAM` |
| `TouchFloorCoolOffTimer.wait_time` | `0.1` s | Debounces floor-touch slam counting |
| `ChangeDirectionCoolOffTimer.wait_time` | `2.0` s | Min interval between direction flips |

## Behavior

Manual state machine using a `current_state` string. Transitions use `set_state()` which stores `previous_state` and flips `state_changed`; the active state checks `_just_entered_state()` once for one-time setup.

### State map

| State | Active behaviour |
|-------|------------------|
| `STATE_RUN_AND_JUMP` (`"run_and_jump"`) | Default starting state after a 1.5 s initial delay. Runs horizontally toward the player; when `do_jump` is true (set on entry and again by `RunAndJumpTimer.timeout` every 3 s) applies `velocity.y = -jump_power`, restarts the timer, sets `landing = true`. Gravity is added each frame. On landing (`is_on_floor() && landing`): plays `sfx_env_cave_boss_slam`, shakes the screen, spawns one `SlamBlast` in the facing direction, emits `state_cycle_finished("run_and_jump")` for the boss level to react to (e.g. trigger a phase change). |
| `STATE_UP_DOWN` (`"updown"`) | Bounces between floor and ceiling at `vertical_speed = 200`, drifting horizontally at `speed = 55`. Direction.y flips on `is_on_floor()` or `is_on_ceiling()`. |
| `STATE_UP_DOWN_SLAM` (`"updown_slam"`) | Two sub-modes (`slam_mode`): <br>• `MODE_SLAM` (entry default): very slow horizontal drift (`speed_updown_slam = 10`) with fast vertical slamming (`vertical_speed_updown_slam = 350`). On every floor/ceiling impact: flip Y direction, play slam SFX, shake screen. On floor impact, start `TouchFloorCoolOffTimer` (0.1 s); each timeout increments `slam_count`. At `slam_count == 1` it spawns a `BossFallingSpikeArray` from the ceiling; at `slam_count == 3` it flips to `MODE_RUN` and starts `SlamRunTimer`. <br>• `MODE_RUN`: gravity-driven, horizontal velocity `100 * direction`. After `SlamRunTimer` (2 s) → `slam_count = 0`, back to `MODE_SLAM`. |
| `STATE_RUN` (`"run"`) | Pure horizontal `move_and_slide` at `speed * direction`. Not entered by the current `_ready()` flow but kept as a usable state. |
| `STATE_JUMP` (`"jump"`) | Defined as a constant but no match arm — TBD: reserved for a state the boss level may set externally. |

### Facing / direction
`_update_direction()` runs every frame. The boss looks at the player and sets `direction = ±1`, switching the `look-right` / `look-left` animation. On any change `can_change_direction` is locked out for `ChangeDirectionCoolOffTimer` (2 s) to prevent jitter when the player jumps directly overhead.

### Lifecycle
- `_ready()`: caches `global_position` as `ground_global_position`, calls `set_state(STATE_RUN_AND_JUMP)`, yields 1.5 s, sets `do_jump = true`, starts `RunAndJumpTimer`. Boss is active immediately after the delay.
- The boss level transitions the boss between `RUN_AND_JUMP`, `UP_DOWN`, and `UP_DOWN_SLAM` in response to its own state-machine — typically by listening to `state_cycle_finished` and calling `set_state()`.

### Spawned effects
- `_spawn_slam_blast()` — instances a `SlamBlast` at the boss's `global_position`, then sets its `direction` to match the boss facing (`scale.x = ±1` to flip the sprite).
- `_spawn_falling_spikes_array()` — instances `BossFallingSpikeArray.tscn`, computes `distance_to_player` from the boss, places the array at `(boss.global_position.x ± distance_to_player, ceiling_position.global_position.y)` (i.e. centred above the player on the ceiling Position2D supplied by the boss level via `set_ceiling_position`), connects `finished` → `_on_falling_spikes_finished` (which re-emits `state_cycle_finished` if still in `STATE_UP_DOWN_SLAM`).

### Screen shake
`_shake_screen()` calls `get_parent().get_node("ScreenShake").screen_shake(0.5, 2, 100)` — the boss level is expected to embed a `ScreenShake` node as a sibling.

## Player interaction
- Body contact via the boss's `Area2D` (`_on_body_entered`) calls `player.die()`.
- Each `SlamBlast` shockwave kills the player on touch (own `_on_body_entered`).
- Each `FallingSpike` in a dropped array kills the player on its `HitZone` (see the falling-spike object).
- The boss has no HP and cannot be killed by the player — the boss level ends the fight via a checkpoint / boss-clear cutscene. Recent changes added a second checkpoint to make the fight easier (see `CHANGELOG`).

## Signals
- `state_cycle_finished(state_name)` — emitted on `STATE_RUN_AND_JUMP` landings and (via `_on_falling_spikes_finished`) when an `UP_DOWN_SLAM` spike array finishes. The boss level listens to drive its own state machine (advancing phases, triggering cutscenes, etc.).

## Public API
- `set_player(player_ref)` — caches the player reference used by `_update_direction`.
- `set_ceiling_position(pos)` — caches the `Position2D` used as Y for spawned falling-spike arrays.
- `set_state(state)` — external state transition (boss level calls this).
- `set_sprite_animation(name)` — direct animation override.

## Scene structure (key nodes)
`CaveLevelBoss` (KinematicBody2D, layer 16, mask 32) → `AnimatedSprite` (offset `(-32, -75)`, default `look-right`, `centered = false`), `CollisionShape2D` (RectangleShape2D extents `(14.84, 15.32)`, body collision), `Area2D` (player-kill hitbox with a larger RectangleShape2D extents `(32, 33.78)` offset up by 34 px), and the timers `CoolOffTimer`, `InitialDelayTimer`, `RunAndJumpTimer`, `SlamRunTimer`, `TouchFloorCoolOffTimer`, `ChangeDirectionCoolOffTimer`.

---

### Inline projectile: SlamBlast
**Scene:** `src/characters/enemies/CaveLevelBoss/SlamBlast.tscn`
**Script:** `src/characters/enemies/CaveLevelBoss/SlamBlast.gd` (`class_name SlamBlast`, extends `Area2D`)

- Sprite: `slam-blast1.png` + `slam-blast2.png` as a 2-frame `SpriteFrames` looping at 10 fps.
- Scene `scale = (1, 2)` to stretch vertically; `CollisionShape2D` is a `RectangleShape2D` extents `(16, 6)` offset to `(24, -6)`.
- Internal `velocity = 300`, `direction = 1`.
- `_physics_process`: `position.x += velocity * direction * delta` — pure linear horizontal motion.
- `set_direction(dir)`: caches direction and flips `scale.x` (`+1` or `-1`) so the sprite faces travel direction. Called by the boss right after instancing.
- `_on_body_entered`: if body is in `GROUP_PLAYER` → `body.die()`.
- No lifetime / no auto-cleanup script-side — the blast persists until off-screen (TBD: relies on the boss level being a finite arena, or on cleanup not yet implemented).

### Inline spawner array: BossFallingSpikeArray
**Scene:** `src/characters/enemies/CaveLevelBoss/BossFallingSpikeArray.tscn`
**Script:** `src/characters/enemies/CaveLevelBoss/BossFallingSpikeArray.gd` (extends `Node2D`)

- Four `FallingSpike` instances spaced at x = `-93.21, -37.21, 26.79, 90.79` along a horizontal line (the boss positions the whole array so its centre sits above the player on the ceiling).
- Each spike uses `BossFallingSpike.png` (the boss-skin variant of the normal `FallingSpike` sprite) and `collision_mask = 97`.
- `WidthMeasurement` `RectangleShape2D` half-extents `(97.77, 4.17)` exposed via `get_width()`.
- `init_delay` export delays the trigger after instancing.
- `trigger()` iterates every node in the `falling_spike` group, calls `falling_spike.trigger()` on each, yields 0.3 s between, then emits `finished`. The group lookup is global so it triggers EVERY active falling spike in the scene, not just the array's children — TBD: this is significant because the boss level also has level-geometry FallingSpikes; in practice the boss arena either has no other spikes or this is the intended behaviour.
- The boss-spawned array calls `connect("finished", boss, "_on_falling_spikes_finished")`, which lets the boss re-emit `state_cycle_finished` when all spikes have dropped.

### Spike object: FallingSpike (referenced, not owned)
**Scene/Script:** `src/objects/falling-spike/FallingSpike.tscn` / `.gd`
**Extends:** `KinematicBody2D`

Used both as level geometry and as the contents of `BossFallingSpikeArray`. Full doc lives in [objects/falling-spike.md](../../objects/falling-spike.md) (TBD — path inferred). Summary:
- Internal `gravity = 20` (per-frame Y impulse once triggered).
- `trigger()` reparents an attached `FireYokai` decoration off the spike, plays the `shake` AnimationPlayer track, plays `sfx_env_falling_spike`, sets `triggered = true`.
- Falls until `vel.y == 0`, then plays `sfx_env_crumbling_platform_explode`, plays the `explode` animation, and `queue_free`s.
- `TriggerZone` triggers on player proximity (level geometry); `HitZone` kills the player on contact.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Constants`.
- [objects/falling-spike.md](../../objects/falling-spike.md) — the `FallingSpike` body used by `BossFallingSpikeArray`.
- World 3 boss level scene (TBD path) — owner that calls `set_player`, `set_ceiling_position`, `set_state`, and embeds the `ScreenShake` node the boss expects as its parent's child.
- [ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) / [boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md) — bracket the fight. The cutscene variant `CaveLevelBossForCutScenes.tscn` is the inert puppet used in those cutscenes.
- [enemies/jumpers/cave-level-mini-boss.md](../jumpers/cave-level-mini-boss.md) — the mini-boss (a jumper, see consolidation rules) appears earlier in the same world and shares aesthetic.

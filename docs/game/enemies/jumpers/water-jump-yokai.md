# WaterJumpYokai

**Category:** Object / Hazard
**Scene:** `src/objects/water-jump-yokai/WaterJumpYokai.tscn` (the fish projectile), `WaterJumpYokaiSpawner.tscn` (the spawner)
**Script:** `src/objects/water-jump-yokai/WaterJumpYokai.gd` (fish); spawner reuses `src/objects/test-objects/Guns/Gun.gd`
**Extends:** `RigidBody2D` (fish)

## Purpose
A fish-yokai that leaps out of the water along an arc and kills the player on contact. The `WaterJumpYokaiSpawner` is a generic gun-style emitter placed at the water surface that periodically fires fish straight upward. The fish travels as a `RigidBody2D` under high gravity, spawns a `WaterSplash` on entering/leaving water, and self-cleans after 4 s, after re-entering water on the way down, or when leaving the screen.

## Assets
- Sprite sheet: `water-jump-yokai.png` (7-frame loop @ 15 fps)
- Static-block decoration in the scene tree: `water-jump-yokai-base.png` (TBD — not referenced from the script; presumably a level-decoration sprite used elsewhere)
- Embedded scene: `src/objects/water-splash/WaterSplash.tscn` (preloaded as `splash_scene`)
- SFX: `Game_AudioManager.sfx_env_fish_splash` (duplicated onto the fish so it persists through `queue_free`)

## Exported properties

### WaterJumpYokai (the fish projectile)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `max_impulse` | float | 2000.0 | Upper cap — declared but **not used** in current code. TBD. |

Internal: `gravity_scale = 5` (overridden to 5 in `_ready`, scene default 5.97), `direction = Vector2.RIGHT`, `impulse = 1000`. The `direction` and `impulse` are setget properties — setting `impulse` immediately calls `apply_central_impulse(direction * value)`.

### WaterJumpYokaiSpawner (`Gun.gd` instance)
Scene overrides on `src/objects/test-objects/Guns/Gun.gd` (`class_name Gun`, extends `Node2D`):
- `bullet_scene` = `WaterJumpYokai.tscn`
- `shoot_rate = 3.0` — seconds between spawns (`ShootTimer.wait_time`).
- `mode = 3` (`TIMED` — fires on `ShootTimer.timeout`).
- `max_charge_time = 0.0`
- `direction = Vector2(0, -1)` (straight up).

The `Gun` base script provides a timer-driven shoot loop: on `_ready()` (since `requires_target = false`) it calls `_initialize()`, which in TIMED mode arms `ShootTimer` with `wait_time = shoot_rate`. On every `ShootTimer.timeout` it instances `bullet_scene` under the [`Projectiles` autoload](../../systems/autoloads.md), sets the bullet's `direction`, `impulse`, and (if defined) `charge`, places it at `ShootPosition.global_position`, and calls `bullet.fire(target)` if available. See [../../objects/hazards/cannon.md](../../objects/hazards/cannon.md) for a fuller breakdown of the `Gun` script — Cannon is the only other shipping consumer.

A `VisibilityEnabler2D` (`process_parent = true`, `physics_process_parent = true`) pauses the spawner when off-screen.

## Behavior
- Spawner emits a fish upward on each `ShootTimer.timeout`.
- Fish: gravity pulls it back; once `linear_velocity.y > 50`, `falling = true` and the sprite is rotated 180° to face downward.
- Fish has an internal `Area2D` (collision layer 4, mask 4) used to detect water — on `body_entered` it plays the splash SFX, instances `WaterSplash` at its current position, and if `linear_velocity.y > 0` (falling back into water) calls `queue_free`.
- 4-second `Timer` (autostart, one-shot) — `queue_free` on timeout (failsafe).
- `VisibilityNotifier2D.screen_exited` — `queue_free`.
- Root body's own `body_entered` — if player, `body.die()` (RigidBody2D contact monitoring is enabled, 1 contact reported).

## Player interaction
Body contact with the fish kills the player.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- [decoration/decorations.md](../decoration/decorations.md) — `WaterSplash` is documented there.
- [../../objects/hazards/cannon.md](../../objects/hazards/cannon.md) — the `Gun` script that powers the spawner is also documented there (Cannon is the other shipping consumer).
- Player — `die()` receiver.

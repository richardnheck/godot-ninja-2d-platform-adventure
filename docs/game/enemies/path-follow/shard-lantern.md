# ShardLantern

**Category:** Enemy / PathFollow (with projectile)
**Scene:** `src/characters/enemies/path-follow-enemy/shard-lantern/ShardLantern.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/shard-lantern/ShardLantern.gd` (`tool`, `class_name ShardLantern`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A floating lantern that periodically shoots a 3-shard spread of `Shard` projectiles in a configurable direction. Can be stationary or slide along a vertical/horizontal short path.

## Assets
- Sprite: `ShardLanternSheet.png` (2-frame default loop at 5 fps, 32x40).
- SFX: `Game_AudioManager.sfx_env_lantern_shoot` (duplicated onto the lantern in `_ready()`).
- Projectile: see inline `Shard` below.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `orientation` | enum `Orientation` | `VERTICAL_TOP_DOWN` | `STATIONARY`, `VERTICAL_BOTTOM_UP`, `VERTICAL_TOP_DOWN`, `HORIZONTAL_LEFT_RIGHT`, `HORIZONTAL_RIGHT_LEFT`. Note: the enum has a duplicate value (`HORIZONTAL_LEFT_RIGHT = 3` and `HORIZONTAL_RIGHT_LEFT = 3`) — TBD bug, the H_RIGHT_LEFT branch is unreachable as written. |
| `path_length` | int | `100` | Curve length when not stationary. |
| `shoot_direction` | enum `ShootDirection` | `RIGHT` | `UP` / `DOWN` / `LEFT` / `RIGHT` — base direction for the spread. |
| `spread` | int | `45` | Degrees between centre and each side shard. |
| `bullet_scene` | PackedScene | `Shard.tscn` | Projectile scene to instance. |
| `shoot_rate` | float | `2` | Seconds between shoot timer firings. |
| `delay_time` | float | `0.00` | If > 0, delay before the first shot via `DelayTimer`. |
| `mode` | enum `MODE` | `TIMED` | Only `TIMED` is defined. |

## Behavior
- Overrides base defaults: `speed = 30`, `TRANS_SINE`, `PING_PONG`, no oscillation. Builds a straight `Curve2D` matching orientation; `STATIONARY` calls `stop_following_path()`.
- `_initialize_gun()` schedules either an immediate shot (after a 1-frame yield) or a `DelayTimer.start()` if `delay_time > 0`. `ShootTimer.wait_time = shoot_rate`.
- `_shoot()` plays `sfx_shoot` and instances 3 `Shard`s at `Area2D/ShootPosition`: one at `direction.rotated(+spread/2)`, one at `direction`, one at `direction.rotated(-spread/2)`. Each is added to the `Projectiles` autoload/node (TBD: `Projectiles` is an autoload-like global; see systems).
- `ShootTimer.timeout` → `_shoot()` again if `mode == TIMED`. (The body's path-follow motion is NOT paused while shooting — the commented-out pause/yield code is disabled.)

## Player interaction
Standard base body-touch death plus shard-on-player death.

## Signals
None.

### Inline projectile: Shard
**Scene:** `.../shard-lantern/shard/Shard.tscn`
**Script:** `.../Shard.gd` (`class_name Shard`)
**Extends:** `Area2D` (in `falling_spike` group, layer 4 / mask 3)

- Exports `speed = 150`. Setter `set_direction(new_direction)` updates `rotation = new_direction.angle()`.
- `_physics_process`: while not exploding, `global_position += speed * delta * direction.normalized()`.
- `HitZone` (Area2D) `body_entered`: if player → `body.die()` then `_explode()`.
- Self `body_entered`: if collider is `TileMap` → `_explode()`.
- `_explode()` plays `Game_AudioManager.sfx_env_lantern_shard_hit` (duplicated), hides the main AnimatedSprite, plays `explode` on `ExplosionAnimatedSprite` (5 frames @ 10 fps from `ShardExplosionSheet.png`), then `queue_free()`.
- `VisibilityNotifier2D.screen_exited` → `queue_free()`.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- `Projectiles` parent node (TBD — referenced as a global; likely a level autoload/group).
- `Game_AudioManager.sfx_env_lantern_shoot`, `sfx_env_lantern_shard_hit`.

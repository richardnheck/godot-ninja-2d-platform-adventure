# PathFollowEnemyBase

**Category:** Enemy / PathFollow (shared base)
**Scene:** `src/characters/enemies/path-follow-enemy/PathFollowEnemyBase.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/PathFollowEnemyBase.gd` (`class_name PathFollowEnemyBase`)
**Extends:** `Node2D`

## Purpose
Shared base scene/script for every enemy under `path-follow/`. Provides a `Path2D` + `PathFollow2D` + `Tween` rig that moves an `Area2D` (with `AnimatedSprite` + `CollisionShape2D` child) along a curve, with optional vertical sine-oscillation overlay. Activated/paused by a `VisibilityNotifier2D` so off-screen enemies do not run.

## Assets
- None directly. Subclasses supply their own `SpriteFrames` on `Area2D/AnimatedSprite` and their own `Curve2D` on `Path2D`.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `speed` | float | `32` | Pixels/sec along the baked curve length. |
| `tween_transition_type` | enum `TransitionType` | `TRANS_SINE` | Maps to `Tween.TRANS_*` constants (LINEAR/SINE/QUINT/QUART/QUAD/EXPO/ELASTIC/CUBIC/CIRC/BOUNCE/BACK). |
| `follow_path_type` | enum `FollowPathType` | `PING_PONG` | `PING_PONG` (reverse + flip sprite), `CONTINUOUS` (loop), `ONCE` (stop at end). |
| `offset` | float (0–1) | `0` | Start position along path. `1` starts from the other end with `flip_h = true`. |
| `delay` | float | `0` | Seconds to wait before first tween starts (after first becoming visible). |
| `oscillation_amplitude` | float | `0` | Vertical cosine wobble amplitude added to `position.y`. |
| `oscillation_frequency` | float | `0` | Angular frequency of the cosine wobble. |

## Behavior
- `_ready()` records `initial_position_y`, hooks `tween.tween_completed`, leaves the sprite paused. Movement is NOT started yet.
- `VisibilityNotifier2D.screen_entered` → first time: `_initialise()` (waits `delay`, then `call_deferred("_start_tween")`); subsequent times: resume sprite + tween.
- `VisibilityNotifier2D.screen_exited` → pauses sprite + tween, unless the notifier has been `queue_free()`d (Wanyudo/AoAndon disable this).
- `_start_tween()` computes `time = curve_length / speed` and interpolates `path_follow_2d.unit_offset` from `tween_values[0]` to `tween_values[1]`. On first start, `offset` shifts the start and `time` is shortened accordingly; `offset == 1` inverts `tween_values` and sets `flip_h = true`.
- `_on_tween_completed`: for `PING_PONG` invert values + flip `flip_h`; for `CONTINUOUS` restart from start; for `ONCE` call `stop_following_path()`.
- `_process` adds vertical oscillation `position.y = initial_position_y + amplitude * cos(time_passed * frequency)` while `following_path` is true.
- A `RemoteTransform2D` child of `PathFollow2D` drives the `Area2D` position (so the visible sprite tracks the curve).

## Public API used by subclasses / level scripts
- `stop_following_path()`, `start_following_path(start_offset)`, `pause_following_path()`, `unpause_following_path()`.
- Subclasses build a `Curve2D` in their own `_ready()` and call `self.path2d.set_curve(curve)` after overriding `speed`/`tween_transition_type`/`follow_path_type`/oscillation.

## Player interaction
`Area2D.body_entered` → if body is in `Constants.GROUP_PLAYER`, calls `body.die()`.

## Signals
None emitted. Internal: listens to `Tween.tween_completed`, `VisibilityNotifier2D.screen_entered/exited`, `Area2D.body_entered`.

## Dependencies
- `Constants.GROUP_PLAYER` (autoload, see [systems/autoloads.md](../../systems/autoloads.md)).
- Player [player.md](../../player/player.md) for the `die()` contract.
- `Area2D` collision layer = 8 (enemy hit zone).

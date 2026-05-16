# FireBallSpinner

**Category:** Object / Hazard
**Scene:** `src/objects/fireball-spinner/FireBallSpinner.tscn`
**Script:** `src/objects/fireball-spinner/FireBallSpinner.gd`  (`tool` script — runs in the editor for live preview)
**Extends:** `Node2D`

## Purpose
A configurable "burny whirler": one or more chains of fireballs spin in a continuous circle around a central pivot, or swing back and forth through an arc with smooth ease-in-out. Inspired by LevelHead's Burny Whirler. Each fireball kills the player on contact. Listens to a `ClockSwitch` channel to be turned on/off at runtime.

## Assets
- Centre base sprite: `FireSpinnerBase.png`
- Embedded scene: `src/objects/fireball-spinner/FireBall.tscn` (preloaded; instanced into `$Pivot` programmatically — see inline section)
- Editor `Label` `ReceivingChannelLabel` shows the channel number when set (editor only)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `rotation_style` | enum `SPIN`/`SWING` | `SWING` (1) | Continuous spin vs. back-and-forth arc. |
| `start_direction` | int -180..180 step 45 | 0 | Starting angle in degrees (0 = right; positive = clockwise). |
| `spin_speed` | int -180..180 step 10 | 90 | Degrees/second for SPIN. |
| `swing_degrees` | int 45/90/135 | 90 | Half-arc of swing (degrees either side of `start_direction`). |
| `swing_speed` | int -100..100 step 10 | 90 | Degrees/second for SWING; sign sets initial rotation direction. |
| `swing_time_offset` | float 0..30 step 0.1 | 0 | Phase offset — delays/advances where in the cycle the swing begins. |
| `length` | int 1..5 | 3 | Number of fireballs in a chain (clamped to `MAX_FIREBALLS = 5`). |
| `gap` | bool | false | If true, every second fireball in the chain is hidden (creates passable gaps). |
| `chains` | int 1..4 | 1 | Number of equally-spaced chains rotating around the centre. |
| `animate_in_editor` | bool | true | Drives the editor preview animation. |
| `show_editor_guides` | bool | false | Show the orange/blue editor guide circles in-game. |
| `receiving_channel` | int 0..1000 | 0 | If >0, connects to all `switch`-group nodes whose `sending_channel` matches; `_on_Switch_switched(active)` calls `show_fireball(active)` on every fireball. |

Internal: `fireball_spacing = 18 px`, `start_rotation_threshold = 30°` (boundary tip-rotate region).

## Behavior
- `_ready` (non-editor): `reset()` instances the fireballs and, if `receiving_channel > 0`, hooks the matching switch.
- `_process(delta)`:
  - SPIN: `actual_rotation_degrees += spin_speed * delta`; `pivot.rotation_degrees = start_direction + actual_rotation_degrees`.
  - SWING: uses an `easeInOutSine` to smoothly traverse from `swing_ease_start_angle` to `swing_ease_target_angle`. At ease completion (output==1) the swing flips direction; `swing_time_offset` shifts the starting phase via `calculate_adjustments_caused_by_swing_ease_time_offset()`.
  - When the swing enters the threshold region near a boundary, each fireball is individually rotated using `_easeInOutCirc` so the visual tip flips before reversing.
- A `VisibilityEnabler2D` (`process_parent = true`) pauses the whole spinner when off-screen.

## Player interaction
Fireball contact (per `FireBall.Area2D`) calls `body.die()`. The base sprite has no collision.

## Signals
None emitted. Receives `switch.switched(active)` when a `receiving_channel` is set.

## Inline child — FireBall (`src/objects/fireball-spinner/FireBall.gd`, `class_name FireBall`, extends `Node2D`)

The spinning hazard instance. Sprite sheet `FireBallSpriteSheet.png` (2-frame loop @ 10 fps). Area2D with a 7.46-radius capsule, collision layer 4. Pauses with the spinner via a child `VisibilityEnabler2D`.

API used by `FireBallSpinner`:
- `set_showing(value:bool)` / `show_fireball(value:bool)` — toggles `visible` and defers `collision_shape.disabled`.
- `remember_current_rotation()` — caches `rotation_degrees` for incremental rotate.
- `adjust_rotation(degrees)` — sets `rotation_degrees = _current_rotation_degrees + degrees`.
- `_on_body_entered(body)` — `body.die()` if player.

Not used standalone — instantiated only by `FireBallSpinner` (and `RotatingPlatform` reuses the same pattern with its own `Platform`).

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- [interactive/clock-switch.md](../interactive/clock-switch.md) — provider of the `switched` signal when `receiving_channel` is set.
- `src/utility/Once.gd` — internal once-trigger helper for threshold edge detection.
- Player — `die()` receiver.

# RotatingPlatform

**Category:** Object / Platform
**Scene:** `src/objects/rotating-platform/RotatingPlatform.tscn`
**Script:** `src/objects/rotating-platform/RotatingPlatform.gd` (`class_name RotatingPlatform`, `tool` script for editor preview)
**Extends:** `Node2D`

## Purpose
A platform version of the FireBall spinner: spins or swings one to four chains of solid platforms around a central pivot, with each platform counter-rotated so it stays horizontal as it orbits. The player rides the platforms. Supports a `ClockSwitch` `receiving_channel` to enable/disable the chain at runtime.

## Assets
- Centre base sprite: `src/objects/fireball-spinner/FireSpinnerBase.png` (hidden — only the platforms are visible at runtime). A dedicated `RotatingPlatformBase.png` exists in the folder but isn't wired into the scene. TBD.
- Embedded scene: `src/objects/rotating-platform/Platform.tscn` (preloaded; instanced into `$Pivot`)
- Editor `Label` `ReceivingChannelLabel` shows the channel when set.

## Exported properties
Mirrors `FireBallSpinner` exports (see [hazards/fireball-spinner.md](../hazards/fireball-spinner.md) for full semantics):

| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `rotation_style` | enum `SPIN`/`SWING` | `SWING` (scene overrides to `SPIN`) | |
| `start_direction` | int -180..180 step 45 | 0 | |
| `spin_speed` | int -180..180 step 5 | 90 | |
| `swing_degrees` | int 45..135 step 45 | 90 | |
| `swing_speed` | int -100..100 step 5 | 90 | |
| `swing_time_offset` | float 0..30 step 0.1 | 0 | |
| `length` | int 1..5 | 3 | Pivot-arm length. Only the **outermost** platform is spawned (one per chain at index `length - 1`). |
| `chains` | int 1..4 | 1 (scene: 2) | |
| `animate_in_editor` | bool | true | |
| `show_editor_guides` | bool | false | |
| `receiving_channel` | int 0..1000 | 0 | Listens to a `ClockSwitch.sending_channel`. |

Internal: `platform_spacing = 16` (used as the per-index distance from pivot — final radius is `length * platform_spacing`). `start_rotation_threshold = 30°`.

## Behavior
- `_init_platforms` removes existing children of `$Pivot` and adds one `Platform.tscn` per chain at radius `length * 16`, equally spaced.
- Each spawned platform's `rotation_degrees = -start_direction`.
- `_physics_process(delta)` (note: physics, not `_process` — differs from `FireBallSpinner`):
  - SPIN: rotates `pivot.rotation_degrees`, then calls `_rotate_platforms(-pivot.rotation_degrees)` to keep platforms horizontal.
  - SWING: uses `_easeInOutSine` to traverse between boundary angles, flips at ease-output 1.
- `_on_Switch_switched(active)` calls `show_fireball` on each platform — TBD: `Platform.gd` does not define a `show_fireball` method (only `show_platform`), so receiving-channel toggling appears broken. Verify before relying on the channel hookup.
- `VisibilityEnabler2D` (`process_parent = true`) pauses when off-screen.

## Player interaction
The player can stand on the platforms (`KinematicBody2D`, collision layer 8). Platform `_on_body_entered` has a `body.die()` call but it is **commented out**, so the platforms are not hazardous.

## Signals
None emitted. Receives `switch.switched(active)` if `receiving_channel > 0`.

## Inline child — Platform (`src/objects/rotating-platform/Platform.gd`, `class_name Platform`, extends `KinematicBody2D`)

A 32×16 wooden plank, sprite `assets/art/tilesets/cave-level/cave-wood-platform-horizontal.png`, collision layer 8. Mirrors the FireBall API:
- `set_showing(value:bool)` / `show_platform(value:bool)` — toggles `visible` and defers `collision_shape.disabled`.
- `remember_current_rotation()` — caches current `rotation_degrees`.
- `adjust_rotation(degrees)` — `rotation_degrees = _current_rotation_degrees + degrees`.
- `_on_body_entered(body)` — `die()` is commented out (non-hazardous).

Only consumer is `RotatingPlatform`. Distinct from `src/objects/platform-belt/Platform.gd` (`class_name PlatformForBelt`).

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- [interactive/clock-switch.md](../interactive/clock-switch.md) — provider of the `switched` signal.
- `src/utility/Once.gd` — once-trigger helper for threshold edge detection.

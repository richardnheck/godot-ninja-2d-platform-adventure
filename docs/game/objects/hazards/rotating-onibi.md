# RotatingOnibi

**Category:** Object / Hazard
**Scene:** `src/objects/rotating-onibi/RotatingOnibi.tscn`
**Script:** `src/objects/rotating-onibi/RotatingOnibi.gd` (`class_name RotatingOnibi`, `tool` script for editor preview)
**Extends:** `Node2D`

## Purpose
Spins one to four upright "onibi" flame yokai in a circle around a centre pivot. A simpler relative of `FireBallSpinner`: SPIN-only, fixed radius (50 px), no swing/length/gap/channel features. Each rotating onibi kills the player on contact.

## Assets
- Centre base sprite: `OnibiBase.png` (hidden at runtime — only visible in the editor)
- Embedded scene: `src/objects/rotating-onibi/Onibi.tscn` (preloaded; instanced into `$Pivot`)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `start_direction` | int -180..180 step 45 | 0 | Starting angle (0 = right; positive = clockwise). |
| `spin_speed` | int -180..180 step 10 | 90 | Degrees per second. |
| `chains` | int 1..4 | 1 | Number of onibi spaced equally around the pivot. |
| `animate_in_editor` | bool | true | Drives the editor preview. |
| `show_editor_guides` | bool | false | Show the orange/white guide circles at runtime. |

Internal: `radius = 50`, `object_size = 16`.

## Behavior
- `_ready` (non-editor): hides the base sprite, calls `reset()`.
- `reset()` clears `$Pivot` children and adds one `Onibi` per chain at `(radius,0).rotated(start_angle)`.
- `_process(delta)`:
  - `actual_rotation_degrees += spin_speed * delta`.
  - `pivot.rotation_degrees = start_direction + actual_rotation_degrees`.
  - `_rotate_objects(-pivot.rotation_degrees)` — each onibi counter-rotates so the flame always stays vertically upright as it orbits.
- A `VisibilityEnabler2D` (`process_parent = true`) pauses the spinner when off-screen.

## Player interaction
Onibi Area2D contact calls `body.die()`. The base has no collision (and is invisible at runtime).

## Signals
None emitted. (Unlike `FireBallSpinner`, this scene has no `receiving_channel`.)

## Inline child — Onibi (`src/objects/rotating-onibi/Onibi.gd`, `class_name Onibi`, extends `Node2D`)

The orbiting flame ghost. Sprite sheet `OnibiFireSheet.png` (8-frame loop @ 8 fps, 32×48). `Area2D` (collision layer 4) with a `ConvexPolygonShape2D` flame outline.

API used by `RotatingOnibi`:
- `set_showing(value:bool)` / `show_object(value:bool)` — toggles `visible` and defers `collision_shape.disabled`.
- `adjust_rotation(degrees)` — `rotation_degrees = _current_rotation_degrees + degrees`. (`_current_rotation_degrees` is initialised to 0 and never re-cached, so the onibi just inherits the negated pivot angle every frame, keeping it upright.)
- `_on_body_entered(body)` — `body.die()` if player.

Not used standalone — only instanced by `RotatingOnibi`. The sprite sheet `OnibiSheet.png.import` is present in the folder but the active sheet is `OnibiFireSheet.png`.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- `src/utility/Once.gd` — imported but unused by this spinner (legacy from the FireBallSpinner template).
- Player — `die()` receiver.

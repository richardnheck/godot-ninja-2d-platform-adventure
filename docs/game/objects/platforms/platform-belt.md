# PlatformBelt

**Category:** Object / Platform
**Scene:** `src/objects/platform-belt/PlatformBelt.tscn`
**Script:** `src/objects/platform-belt/PlatformBelt.gd` (`tool` script)
**Extends:** `Node2D`

## Purpose
A vertical assembly-line that continuously spawns platforms moving up or down through a tall belt region. Platforms enter the region on one side, travel at a fixed speed, and are freed when they exit. The player rides individual platforms across the region. Often used to make a constantly-moving wall of platforms across a tall shaft.

## Assets
- No own sprite — purely a spawner.
- Embedded scene: `src/objects/platform-belt/Platform.tscn` (preloaded; see inline section)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `distance_between_platforms` | float | 100 | Pixels between consecutive platforms. Drives both the pre-population spacing and the spawn timer (`spawn_timer.wait_time = distance / speed`). |
| `platform_speed` | float | 50 | Pixels/second platforms travel (scene default 10). |
| `platform_direction` | Vector2 | `DOWN` | Either `Vector2.DOWN` or `Vector2.UP` (only these two are handled). |
| `position_offset` | int | 0 | Offset (in pixels) from the spawn edge of the belt region (scene default 100). |

The belt region itself is `$BeltRegionArea2D/CollisionShape2D` (defaults to 50×423 in the scene).

## Behavior
- `_ready` yields one frame, then:
  - Computes `region_length = extents.y * 2` and `number_of_platforms = region_length / distance_between_platforms`.
  - Pre-spawns that many platforms equally spaced through the region — from the top if direction is DOWN, from the bottom if UP.
  - Starts `SpawnTimer` with `wait_time = distance_between_platforms / platform_speed`.
- `SpawnTimer.timeout` — spawns one platform at the entry edge (skipped in editor):
  - DOWN → spawn at `(0, position_offset)`.
  - UP → spawn at `(0, region_length - position_offset)`.
- `_spawn_platform(pos)`:
  - Instances `Platform.tscn`, parents it to `get_parent()` (sibling of the belt, not a child — so the player isn't affected by belt-level transforms).
  - Calls `platform.set_direction(platform_direction)` and `platform.set_speed(platform_speed)`.
- `BeltRegionArea2D.body_exited` — if the leaving body is a `PlatformForBelt`, `queue_free` it.

## Player interaction
The player rides individual `PlatformForBelt` instances as standard kinematic platforms. The belt root itself has no collision and never harms the player.

## Signals
None emitted.

## Inline child — Platform (`src/objects/platform-belt/Platform.gd`, `class_name PlatformForBelt`, extends `RigidBody2D`)

A 32×16 horizontal wooden plank, sprite `assets/art/tilesets/cave-level/cave-wood-platform-horizontal.png`. Scene: `RigidBody2D` with `mode = 3` (kinematic), `gravity_scale = 0`, collision layer 8.

Exports:
- `speed` (float, default 1) — setter is a plain assignment.
- `direction` (Vector2, default `DOWN`) — setter adjusts the `CollisionShape2D` extents and Y position to compensate for the player's stand-on offset:
  - DOWN: `extents.y = 7.5`, `position.y = 0.5`.
  - UP: `position.y = -0.25`. (Source comment marks this as a hack — "WTF" — needed to keep the player visually on top.)

`_physics_process(delta)`: `position += direction * speed * delta` (rigid-body-as-kinematic; the commented-out alternative used `move_and_slide_with_snap`).

Only consumer is `PlatformBelt`. Not used standalone.

## Dependencies
- Player — rides the platforms (no special method calls).

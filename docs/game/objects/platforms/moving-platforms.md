# Moving Platforms

**Category:** Object / Platform
**Scenes:**
- `src/objects/MovingPlatformBase.tscn` — the template
- `src/objects/MovingPlatformVertical.tscn` — vertical variant (uses `vertical_path.tres`)
- `src/objects/MovingPlatformCave1H.tscn` — short horizontal cave variant (inherits Base)
- `src/objects/MovingPlatformCave2H.tscn` — long horizontal cave variant (inherits Base, 32×16 collision)

**Script:** none on the platforms themselves. `src/objects/moving-platform-draw-track.gd` is an optional helper for editor preview.
**Extends:** `Node2D` (root); the platform body is `KinematicBody2D` (Base / Cave variants) or `StaticBody2D` (Vertical variant).

## Purpose
A family of straight-line platforms that ping-pong along a `Path2D`, driven entirely by an `AnimationPlayer` that animates `PathFollow2D.unit_offset`. No script is needed — the variants only differ in the platform sprite, the track sprite, the collision shape, and (for the Vertical variant) the path resource. Track length is editable per-instance by editing the `Path2D.curve`.

## Variants
| Scene | Body | Sprite | Track sprite | Notes |
|-------|------|--------|--------------|-------|
| `MovingPlatformBase.tscn` | `KinematicBody2D` (layer 8, `motion/sync_to_physics = true`) | none (must be set per-instance) | none | The template. 16×16 collision. |
| `MovingPlatformVertical.tscn` | `StaticBody2D` (layer 2) | `cave-wood-platform-horizontal.png` (scaled `(0.5, 2.5)`) | `cave-platform-track-64.png` rotated 90° | Stands vertically. Used with `vertical_path.tres` (a fixed two-point curve, ~319 px tall). |
| `MovingPlatformCave1H.tscn` | inherits Base (kinematic) | `cave-wood-platform-vertical.png` | `cave-platform-track-48.png` rotated -90° | Short horizontal cave platform. |
| `MovingPlatformCave2H.tscn` | inherits Base (kinematic) | `cave-wood-platform-horizontal.png` | `cave-platform-track-64.png` | Long horizontal cave platform; 32×16 collision. |

## Assets
- Platform sprites: `assets/art/tilesets/cave-level/cave-wood-platform-horizontal.png`, `cave-wood-platform-vertical.png`
- Track sprites: `assets/art/tilesets/cave-level/cave-platform-track-48.png`, `cave-platform-track-64.png`
- Resource: `src/objects/vertical_path.tres` — `Curve2D` with two points spanning `(0,0)` to `(0,-319)` for the Vertical variant.

## Scene structure (common to all four)
```
MovingPlatform*
├─ VisibilityEnabler2D       process_parent + physics_process_parent
├─ Path2D
│  ├─ PathFollow2D            rotate=false, loop=false, offset≈1.05
│  │  └─ RemoteTransform2D    remote_path = ../../../KinematicBody2D
│  └─ TrackSprite             show_behind_parent=true
├─ KinematicBody2D            collision_layer=8 (or StaticBody2D layer=2 for Vertical)
│  ├─ CollisionShape2D
│  └─ Sprite
└─ AnimationPlayer            autoplay=PingPongPathFollow, playback_speed=0.5
```

The `PingPongPathFollow` animation is a 2-second loop interpolating `Path2D/PathFollow2D:unit_offset` from `0.0` to `0.99` (a linear ramp). Combined with `playback_speed = 0.5` it effectively becomes a 4-second cycle. To get the "ping-pong" feel, each instance is expected to author its own playback (TBD — the keyframe values 0→0.99 are not a true ping-pong by themselves; verify if instances override the animation). The path direction is followed in one direction.

The `RemoteTransform2D` under `PathFollow2D` drives the platform body's transform so the body follows the path without being a child of the path (so its collisions resolve naturally). `motion/sync_to_physics = true` on the kinematic body ensures the player rides smoothly.

## Exported properties
None on the platforms themselves. Per-instance setup involves:
- Editing the `Path2D.curve` to define the route.
- (Vertical only) assigning `vertical_path.tres` to the curve.
- Setting the `Sprite.texture` and `CollisionShape2D` where the Base template requires it.

## Behavior
- `AnimationPlayer` continuously drives `PathFollow2D.unit_offset` 0→0.99, which moves the `RemoteTransform2D`, which in turn moves the `KinematicBody2D`/`StaticBody2D`. The player riding it is pushed via Godot's standard moving-platform handling (kinematic bodies with `sync_to_physics`).
- `VisibilityEnabler2D` pauses both process and physics-process on the parent when off-screen.

## Player interaction
The platforms are non-hazardous solid surfaces. The player stands on and rides them. No script logic.

## Signals
None emitted.

## Editor helper — `moving-platform-draw-track.gd`

A small `Node2D` helper script (not attached to the moving-platform scenes by default). When attached to a node with a `$Path2D` child whose curve has exactly two points, `_draw` renders a slate-gray line between the two points offset by `platform_offset` (default `(16, 0)`). Purpose: visualise non-standard tracks in the editor for level designers. Has no runtime effect on the platforms.

Exports:
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `platform_offset` | Vector2 | `(16, 0)` | Offset applied to both endpoints of the drawn line. |

## Dependencies
- Player — rides via `sync_to_physics`. No method calls.

# Boat

**Category:** Object / Interactive
**Scene:** `src/objects/boat/Boat.tscn` (instances `src/objects/MovingPlatformBase.tscn`)
**Script:** `src/objects/boat/Boat.gd`
**Extends:** `Node2D` (the root replaces the `MovingPlatformBase` Node2D root)

## Purpose
A ridable boat for World 2 water levels. The player steps on, the boat starts following a pre-authored AnimationPlayer path (configured per level), and ferries them across.

## Assets
- Sprite: `src/objects/boat/boat.png`
- SFX: none (motion is silent).

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `boat_speed` | float (0.01..1, step 0.01) | 0.0 | Sets `AnimationPlayer.playback_speed`. Per-level tuning. `0.0` would freeze motion — production levels set a small positive value. |

## Scene composition
Inherits from `MovingPlatformBase` (KinematicBody2D on collision layer 10 — players stand on it). Boat-specific child nodes added:
- `KinematicBody2D/Sprite` — the boat texture (z_index 4, large `RectangleShape2D` collision for the deck).
- `KinematicBody2D/LightSourceForSeeingBoat` — `Area2D` above the boat. TBD — likely a light/visibility helper for cave levels.
- `KinematicBody2D/StartArea2D` — top-deck trigger that arms the motion when the player lands on it.
- `KinematicBody2D/LeftStaticBody2D`, `RightStaticBody2D` — short vertical static walls on the bow/stern so the player cannot run off the sides.
- `AnimationPlayer` with a `PingPongPathFollow` animation (authored per level scene — animates `KinematicBody2D:position` back and forth).
- `VisibilityEnabler2D` configured NOT to pause the AnimationPlayer (so the boat keeps moving off-screen) — `pause_animations = false`, `process_parent = false`, `physics_process_parent = false`.

## Behavior
- `_ready()` writes `boat_speed` into `AnimationPlayer.playback_speed`.
- `_on_StartArea2D_body_entered(body)` — if the body is in `Constants.GROUP_PLAYER`, plays the `PingPongPathFollow` animation.
- Once started the boat does not stop. Motion is purely driven by the AnimationPlayer keyframes.

## Player interaction
Step onto the deck (lands inside `StartArea2D`) → boat starts its keyframed path. Side walls keep the player on. The player rides as a passenger on the KinematicBody2D.

## Signals
None.

## Dependencies
- [objects/platforms/moving-platforms.md](../platforms/moving-platforms.md) — `MovingPlatformBase.tscn` parent scene.
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.

## Notes / TBD
- `LightSourceForSeeingBoat` is unused by the script. TBD — appears to be referenced via group/level lighting setup; verify when porting World 2 cave levels.

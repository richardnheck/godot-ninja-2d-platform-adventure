# FallingPlatform

**Category:** Object / Platform
**Scene:** `src/objects/falling-platforms/FallingPlatform.tscn`
**Script:** `src/objects/falling-platforms/FallingPlatform.gd`
**Extends:** `RigidBody2D`

## Purpose
A 16×16 platform that hangs in mid-air until the player steps on it, then begins falling under physics after a brief shake. Once it has fallen off-screen it removes itself. Differs from `CrumblingPlatform` in that it stays solid — the player can ride it down.

## Assets
- Sprite: `FallingPlatform.png`
- Shake animation: 0.2 s sprite-offset track on a slowed-down `AnimationPlayer` (`playback_speed = 0.5`)
- No SFX

## Exported properties
None.

Scene-level overrides on the RigidBody2D: `collision_layer = 8`, `gravity_scale = 2.0`.

## Behavior
1. `_ready`: `mode = RigidBody2D.MODE_STATIC` — the platform stays put while idle (rigid body acts as a static collider).
2. Player enters `TriggerArea2D` (a thin 2×7 strip above the platform, collision layer 8, `monitorable = false`):
   - Play `shake` on the `AnimationPlayer`.
   - Yield 0.1 s.
   - `set_deferred("mode", RigidBody2D.MODE_RIGID)` — gravity now applies.
3. `_isFalling()` returns `mode == MODE_RIGID`.
4. `VisibilityNotifier2D.screen_exited` — if `_isFalling()`, `queue_free`.

## Player interaction
The player can stand on the platform indefinitely while it is static. Once triggered the platform drops away under standard rigid-body physics — the player rides it until they jump off or it crashes. The player is not harmed by the platform.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- Player — no `die()` call.

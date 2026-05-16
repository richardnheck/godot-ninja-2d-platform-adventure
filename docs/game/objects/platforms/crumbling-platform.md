# CrumblingPlatform

**Category:** Object / Platform
**Scene:** `src/objects/crumbling-platform/CrumblingPlatform.tscn`
**Script:** `src/objects/crumbling-platform/CrumblingPlatform.gd`
**Extends:** `KinematicBody2D`

## Purpose
A single-tile platform that crumbles permanently when the player steps on it. Unlike `CloudPlatform`, it does not respawn — once triggered it shakes, explodes, and `queue_free`s itself. There is also an inner `HitZone` that kills the player on contact, but the trigger zone is on the top so normal use is "step → fall through".

## Assets
- Platform sprite: `CrumblingPlatform.png`
- Explosion frames: `assets/art/sprites/enemy-death/enemy-death-{1..6}.png` (shared with `FallingSpike`; 6-frame `explode` @ 20 fps)
- SFX: `Game_AudioManager.sfx_env_crumbling_platform_crumble` (shake), `Game_AudioManager.sfx_env_crumbling_platform_explode` (impact)
- Shake animation: 0.2 s sprite-offset track

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | 50 | Declared but unused (no `_physics_process` body). TBD. |

## Behavior
1. Idle — solid kinematic body, collision layer 2, 16×15 `CollisionShape2D`.
2. Player enters `TriggerZone` (14×1 strip above the platform) → `trigger_crumble()`:
   - Play `sfx_env_crumbling_platform_crumble`.
   - Play `shake` on the `AnimationPlayer`; `yield` for `animation_finished`.
   - Stop the crumble SFX; set `triggered = true`.
   - Play `sfx_env_crumbling_platform_explode`.
   - Play `AnimatedSpriteExplosion.explode`; `yield` for its `animation_finished`.
   - `queue_free`.

Note: the solid `CollisionShape2D` is not explicitly disabled during the explosion, so it remains a standable surface until `queue_free`. There is no respawn.

## Player interaction
- Step on top → `TriggerZone` arms the destruction; the platform stays solid through the shake.
- `HitZone.body_entered` — `body.die()` if player. TBD — the `HitZone` Area2D is referenced in the script but **not present in the current scene file**, so this code path is dead in the shipping configuration.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- Player — `die()` receiver (only via the dead `HitZone` path).

# CloudPlatform

**Category:** Object / Platform
**Scene:** `src/objects/cloud-platform/CloudPlatform.tscn`
**Script:** `src/objects/cloud-platform/CloudPlatform.gd` (`class_name CloudPlatform`)
**Extends:** `KinematicBody2D`

## Purpose
A single-tile cloud the player can briefly stand on. Stepping on it makes it shake for 0.7 s, explode in a puff, vanish, and respawn 2 s later — but only when the player has cleared its area. Designed for skill-jumps where players must time multiple steps.

## Assets
- Cloud sprite: `CloudPlatform.png`
- Explosion sprite sheet: `CloudPlatformSheet.png` (7-frame `explode` @ 13 fps)
- SFX: `Game_AudioManager.sfx_env_cloud_platform_explode`
- Shake animation: 0.2 s `AnimationPlayer` track on the sprite offset

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | 50 | Declared but **not used** in the active code — `_physics_process` is empty. TBD (legacy?). |

## Behavior
1. Idle — solid kinematic body on collision layer 2 with a 16×16 `CollisionShape2D` (collision shape node is hidden but enabled).
2. Player enters `TriggerZone` (16×16 area above the cloud) → if `visible`:
   - Play `shake` on the `AnimationPlayer`.
   - Yield 0.7 s.
   - Play `sfx_env_cloud_platform_explode`, hide the cloud sprite, show and play `AnimatedSpriteExplosion.explode`.
   - Yield 0.25 s.
   - `_show_cloud(false)` — hides root + sprite and defers `CollisionShape2D.disabled = true`.
   - Play `AnimatedSpriteExplosion.idle` (empty frames).
   - Start `RespawnTimer` (2 s).
3. `RespawnTimer.timeout` → `_respawn_when_clear_of_player()`:
   - If `player_in_cloud_area` is false → `_show_cloud(true)` (yields 0.3 s after show to stop the AnimationPlayer).
   - Else → start `RespawnBackOffTimer` (0.5 s) and try again on its timeout.
4. `CloudArea2D` tracks player overlap via `body_entered` / `body_exited`, maintaining `player_in_cloud_area`.

## Player interaction
Player can stand on the cloud; touching the trigger zone arms the disappearing sequence. The player is not harmed by the cloud — they fall when it vanishes.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- Player — does not call `die()`.

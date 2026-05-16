# Hannya

**Category:** Enemy / Patrol (trigger-and-charge)
**Scene:** `src/characters/enemies/hannya/Hannya.tscn`
**Script:** `src/characters/enemies/hannya/Hannya.gd` (`tool`, `class_name Hannya`)
**Extends:** `KinematicBody2D`

## Purpose
A floating demon-mask that hangs in the air pulsing with a hover animation. When the player enters a long horizontal trigger zone in front of it, it briefly recoils (telegraph), then screams and surges across the screen at very high speed. Despawns once it leaves the visible screen.

## Assets
- Sprite atlas: `HannyaSheet.png` (32x32 frames). SpriteFrames: `default` (4f @ 6 fps, looping) and `attack` (3f @ 8 fps).
- AnimationPlayer `hover` track: tweens `AnimatedSprite.self_modulate` between white and a salmon-red over 0.5 s (autoplays, loops).
- SFX: `Game_AudioManager.sfx_env_hannya_alert` (on trigger / telegraph start), `sfx_env_hannya_scream` (on charge start). Both duplicated onto the Hannya.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `direction` | enum `Direction` (setget) | `RIGHT` | `LEFT (-1)` or `RIGHT (1)`. Sets `scale.x = -direction` on ready (so the sheet draws facing the chosen direction). |

Constants in script:
| Constant | Value | Notes |
|----------|------:|-------|
| `telegraph_time` | `0.20 s` | Telegraph tween duration. |
| `telegraph_distance` | `10` px | Recoil distance backward before the surge. |
| `speed` | `390` px/s | Charge speed. |

## Behavior
- `_ready()` duplicates the two SFX onto self and sets initial facing.
- `TriggerArea2D` (long rect, ~144×24 px, offset to the front) `body_entered`: if player and not yet triggered, play alert SFX and start `TelegraphTween` interpolating `position` backwards by `telegraph_distance` over `telegraph_time` (`TRANS_QUAD` `EASE_IN_OUT`).
- `TelegraphTween.tween_completed`: set `triggered = true`, play scream SFX, switch animation to `attack`.
- `_physics_process` (only effective when triggered): `velocity.x = direction * speed`; `move_and_slide(velocity, Vector2())`.
- `VisibilityNotifier2D.screen_exited` after triggered: `queue_free()`.
- Body collision is `disabled = true` (kinematic body doesn't push tiles); player damage comes from a child `Area2D` inside the body's `CollisionShape2D` node.

## Player interaction
`CollisionShape2D/Area2D.body_entered` → `body.die()`. (Both during hover and during charge.)

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_hannya_alert`, `sfx_env_hannya_scream`.

# TsurubeOtoshi

**Category:** Enemy / Jumper
**Scene:** `src/characters/enemies/tsurube-otoshi/TsurubeOtoshi.tscn`
**Script:** `src/characters/enemies/tsurube-otoshi/TsurubeOtoshi.gd`
**Extends:** `KinematicBody2D` (layer 4 / mask 2)

## Purpose
A small hopping head yokai. Hops sideways like KasaObake but with stronger gravity, a higher jump, and a heavy slam SFX on landing. No screen shake.

## Assets
- Sprite atlas: `tsurube-otoshi-Sheet.png` (32x34 frames). SpriteFrames: `ground` (3-frame loop @ 5 fps), `jump` (2-frame loop @ 5 fps).
- Landing dust: `src/characters/player/effects/landing-dust/LandingDust.tscn` (parent, scale `(2, 1.5)`).
- SFX: `Game_AudioManager.sfx_env_cave_mini_boss_slam` (duplicated — shared with Daruma).

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | `500` | Multiplied by `delta` per frame. |
| `jump_power` | int | `230` | Initial `-velocity.y`. |
| `horizontal_jump_velocity` | int | `40` | Horizontal speed during the airborne phase. |
| `horizontal_direction` | int (-1..1) | `1` | Facing/movement direction. |
| `current_state` | enum `State` | `JUMP` | Only `JUMP` is defined. |

## Behavior
- `_ready()`: cache raycast distances, init direction, after 1.5-s delay set `do_jump = true` and start `JumpTimer` (2 s).
- `_physics_process` (JUMP):
  - If `do_jump`: `velocity = (h_direction * h_jump_velocity, -jump_power)`, switch sprite to `jump`, start `JumpTimer`, `landing = true`.
  - `move_and_slide(...)` then `velocity.y += gravity * delta`.
  - On floor: switch sprite to `ground`; turnaround check (`!RayCastFloor.is_colliding() or RayCastWall.is_colliding()`) → `_change_direction()` gated by 2-s `CoolOffTimer`. If `landing`, call `_on_land()`.
- `_on_land()`: zero `velocity.x`, play `slam_sound`, instance LandingDust on parent at scale `(2, 1.5)`. (No flash, no screen shake.)
- `_init_character_direction` flips `flip_h` after a 0.4-s delay on direction change.
- `JumpTimer.timeout` → `do_jump = true` (no anim swap or buffer — fires immediately on next physics frame).

## Player interaction
`Area2D.body_entered` (16x16 box over the head) → `body.die()`.

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_cave_mini_boss_slam`.
- LandingDust: [player/effects.md](../../player/effects.md).

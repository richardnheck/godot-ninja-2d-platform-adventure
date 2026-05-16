# KasaObake

**Category:** Enemy / Jumper
**Scene:** `src/characters/enemies/kasa-obake/KasaObake.tscn`
**Script:** `src/characters/enemies/kasa-obake/KasaObake.gd` (`class_name KasaObake`)
**Extends:** `KinematicBody2D` (layer 4 / mask 2)

## Purpose
A one-eyed umbrella yokai that hops sideways across platforms. Differs from Daruma in that it actually translates horizontally during the hop and uses delta-scaled gravity, so jumps describe a proper parabolic arc.

## Assets
- Sprite atlas: `kasa-obake-Sheet.png` (32x52 frames). SpriteFrames: `ground` (1f), `fall` (1f, looping), `jump` (4f @ 8 fps), `land` (2f @ 5 fps loop).
- Landing dust: `src/characters/player/effects/landing-dust/LandingDust.tscn` (parent, scale `(1, 0.75)`).
- SFX: `Game_AudioManager.sfx_env_kasa_obake_jump` (duplicated).

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | `500` | Multiplied by `delta` per frame (proper acceleration). |
| `jump_power` | int | `180` | Initial `-velocity.y`. |
| `horizontal_jump_velocity` | int | `50` | Horizontal speed during the airborne phase. |
| `horizontal_direction` | int (-1..1) | `1` | Facing/movement direction. |
| `current_state` | enum `State` | `JUMP` | Only `JUMP` is defined. |

## Behavior
- `_ready()`: cache raycast distances, init direction, after 1-s delay call `_jump()` (which plays the jump anim then sets `do_jump = true` 0.3 s later).
- `_physics_process` (JUMP):
  - If `do_jump`: play `sfx_jump`, set `velocity = (h_direction * h_jump_velocity, -jump_power)`, start `JumpTimer`, `landing = true`.
  - `move_and_slide(velocity, UP, false, 4, PI/4, false)`, then `velocity.y += gravity * delta`.
  - If `velocity.y > 20` while `landing`, switch sprite to `fall`.
  - On floor: turnaround check (`!RayCastFloor.is_colliding() or RayCastWall.is_colliding()` → `_change_direction()` gated by 2-s `CoolOffTimer`). If `landing`, call `_on_land()`.
- `_on_land()`: zero `velocity.x`, switch sprite to `land`, instance LandingDust on parent. (Loops `land` until next jump — see TBD below.)
- `_init_character_direction` flips `flip_h` after a 0.4-s delay so the sprite turns mid-land rather than mid-flight.
- No `screen_shake` call (the helper exists but is not invoked on land).
- `JumpTimer.timeout` → `_jump()`.

## Player interaction
`Area2D.body_entered` (umbrella-shaped capsule + collision polygon over the eye/spike) → `body.die()`.

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_kasa_obake_jump`.
- LandingDust: [player/effects.md](../../player/effects.md).
- TBD — the `land` animation loops indefinitely until the next jump; the `JumpTimer` is started on `do_jump`, so `_on_JumpTimer_timeout` re-triggers `_jump()` automatically. Confirmed working but the chain (`land → jump`) is implicit.

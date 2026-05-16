# Daruma

**Category:** Enemy / Jumper
**Scene:** `src/characters/enemies/daruma/Daruma.tscn`
**Script:** `src/characters/enemies/daruma/Daruma.gd` (`class_name Daruma`)
**Extends:** `KinematicBody2D` (in `enemy` group, layer 4 / mask 2)

## Purpose
A heavy bouncing daruma doll that hops in place, faces the player, and slams the ground on landing — screen-shake plus dust plus a slam SFX. Turns around when a floor-edge or wall raycast condition is met.

## Assets
- Sprite atlas: `daruma-Sheet.png` (48x48 frames). SpriteFrames: `ground` (1f), `jump` (6f @ 8 fps), `land` (4f @ 10 fps).
- Landing dust: `src/characters/player/effects/landing-dust/LandingDust.tscn` (instanced on parent at scale `(2, 1.5)`).
- SFX: `Game_AudioManager.sfx_env_cave_mini_boss_slam` (duplicated onto the daruma).

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | `7` | Per-frame `velocity.y +=` after `move_and_slide` (constant, not delta-scaled). |
| `jump_power` | int | `200` | Initial `-velocity.y` on jump. |
| `horizontal_jump_velocity` | int | `0` | Horizontal speed during the airborne phase (0 = hops in place). |
| `horizontal_direction` | int (-1..1) | `1` | Facing/movement direction. |
| `wait_time` | float (0..5) | `0.5` | Delay before the first jump. |
| `current_state` | enum `State` | `JUMP` | Only `JUMP` is defined. |

## Behavior
- Plain stack-less state machine. `_ready()`: caches raycast distances, calls `_init_character_direction()`, after `wait_time` sets `do_jump = true` and starts `JumpTimer` (2 s).
- `_physics_process` (JUMP state):
  - If `do_jump`: set `velocity = (h_direction * h_jump_velocity, -jump_power)`, restart `JumpTimer`, set `landing = true`, switch sprite to `jump`.
  - Apply `move_and_slide(velocity, UP, false, 4, PI/4, false)`, then `velocity.y += gravity` (constant, not delta-scaled).
  - On floor: if `RayCastFloor` no longer hits ground or `RayCastWall` hits a wall, call `_change_direction()` (gated by 2-s `CoolOffTimer`). If `landing`, call `_on_land()`.
- `_on_land()`: zero `velocity.x`, screen-shake `(0.5, 2, 100)`, play `slam_sound`, switch to `land` sprite, instance LandingDust on parent, wait for `land` anim to finish, switch sprite back to `ground`.
- `_process`: `sprite_main.flip_h = player.global_position < self.global_position` (faces player). `player` is supplied via `set_player(ref)` by the level.
- `JumpTimer.timeout` → switch sprite to `jump`, wait 0.3 s, then `do_jump = true` again.

## Player interaction
`Area2D.body_entered` (top hitbox capsule) → `body.die()` for player. Daruma takes no damage.

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_cave_mini_boss_slam` (re-used).
- LandingDust effect: [player/effects.md](../../player/effects.md).
- Parent-scene `ScreenShake` node (optional — guarded by `has_node`).

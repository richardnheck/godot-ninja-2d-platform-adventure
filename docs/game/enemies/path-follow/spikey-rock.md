# SpikeyRock

**Category:** Object / Hazard
**Scene:** `src/objects/spikey-rock/SpikeyRock.tscn`
**Script:** `src/objects/spikey-rock/SpikeyRock.gd`
**Extends:** `KinematicBody2D`

## Purpose
A bouncing rock with spikes on two opposite sides that perpetually slams between two walls or between floor and ceiling. Kills the player on contact with whichever spiked side faces the impact. The rock body itself is a solid `KinematicBody2D` the player can stand on between bounces (collision layer 4, mask 3).

## Assets
- Sprites: `SpikeyRock.png` (up/down spikes default), `SpikeyRockUpDownBlink.png` (blink frame), `SpikeyRockLeftRight.png`, `SpikeyRockLeftRightBlink.png`
- SFX: `Game_AudioManager.sfx_env_spikey_rock_thud` — duplicated onto the node so multiple thuds can overlap

Two `AnimatedSprite` children (`SpriteUpDown`, `SpriteLeftRight`) share the same `default` (idle) and `blink` animations; the script enables only one based on orientation.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `start_direction` | int | 1 | Initial direction sign. +1 moves down (or right). -1 the opposite. |
| `up_down` | bool | true | If true the rock bounces vertically (up/down spikes). If false it bounces horizontally (left/right spikes). |

## Behavior
- `_ready`: randomises seed, picks sprite based on `up_down`, schedules `BlinkTimer` to start after a random 0–3 s delay (so multiple rocks don't blink in sync). BlinkTimer wait is 3 s thereafter.
- `_physics_process`:
  - Up/down mode: `vel.y += 8 * direction`, `move_and_slide(vel, UP)`, on `is_on_floor()` or `is_on_ceiling()` play thud and flip `direction`.
  - Left/right mode: `vel.x += 8 * direction`, `move_and_slide(vel, UP)`, on `is_on_wall()` play thud and flip `direction`.
- `BlinkTimer.timeout` → play `blink` on the active sprite. On `animation_finished` → revert to `default`.

Gravity per frame is +8 in `direction`, so velocity grows quadratically between impacts — the rock accelerates into each bounce.

## Player interaction
Two Area2Ds — `TopSpikesArea` and `BottomSpikesArea` — cover the two spiked edges (8.5×0.7 strips). Either's `body_entered` calls `handle_body_entered(body)` which calls `body.die()` if player. The solid `CollisionShape2D` in the middle is a stand-on surface.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- Player — `die()` receiver.

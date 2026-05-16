# Fly (test enemy)

**Category:** Enemy / Patrol (test scene)
**Scene:** `src/characters/enemies/test-enemies/fly/Fly.tscn`
**Script:** `src/characters/enemies/test-enemies/fly/Fly.gd`
**Extends:** `KinematicBody2D` (layer 4 / mask 2)

## Purpose
A simple test-only flying enemy that buzzes sideways while bobbing on a cosine wave. Used to prototype the patrol pattern — not used in shipping levels.

## Assets
- Two static frames: `flyFly1.png`, `flyFly2.png`. SpriteFrames: 2-frame `default` loop @ 5 fps.
- No SFX.

## Exported properties
None.

| Constant | Value | Notes |
|----------|------:|-------|
| `SPEED` | `50` | Horizontal speed. |
| `vert_speed` | `100` | Cos-wave vertical amplitude scale. |
| `amp` | `1/15.0` | Wave x-frequency (radians/px). |
| `counter_threshold` | `500` | Frames before forced direction flip. |

## Behavior
- `_physics_process`:
  - `velocity.y = cos(position.x * amp) * vert_speed * direction` — vertical bob synced to horizontal position so the path looks like a sine wave through space.
  - `velocity.x = SPEED * direction`.
  - `AnimatedSprite.flip_h = (direction == 1)`.
  - If `can_check && is_on_wall()` or `counter > counter_threshold`: invert `direction`, reset `counter`, start `Timer` (0.5 s) to debounce further wall checks.
  - `counter += 1`. `move_and_slide(velocity)` (no floor normal — flying).
- `Timer.timeout` → `can_check = true`.

## Player interaction
`Area2D.body_entered`: if body in `"player"` group → `body.die()`. (Uses the literal string, not `Constants.GROUP_PLAYER`.)

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- TBD — uses raw `"player"` group string instead of `Constants.GROUP_PLAYER`; works because `GROUP_PLAYER == "player"` but is inconsistent with the rest of the codebase.

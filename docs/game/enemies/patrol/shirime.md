# Shirime

**Category:** Enemy / Patrol (trigger-and-chase)
**Scene:** `src/characters/enemies/shirime/Shirime.tscn`
**Script:** `src/characters/enemies/shirime/Shirime.gd` (`class_name Shirime`)
**Extends:** `KinematicBody2D` (in `enemy` group, layer 16 / mask 2)

## Purpose
A sleeping bottom-eye yokai. Idle (asleep, snoring) until the player walks into a tall vertical detection area above it, then wakes up and patrols horizontally toward the player. Returns to sleep when the player leaves.

## Assets
- Sprite atlas: `ShirimeSpriteSheet.png` (32x32 frames). SpriteFrames:
  - `asleep` (3f @ 4 fps, looping)
  - `awake` (1f)
  - `look-left` (3f @ 10 fps)
  - `look-right` (3f @ 10 fps)
- SFX: `Game_AudioManager.sfx_env_shirime_snore` and `sfx_env_shirime_walk` (both duplicated, loop themselves on `finished` while in matching state).

## Exported properties
None — all motion params are constants in script.

| Constant | Value | Notes |
|----------|------:|-------|
| `speed` | `80` | Horizontal pursuit speed. |
| `velocity` initial | `(40, 0)` | Overwritten in physics loop. |
| `ChangeDirectionCoolOffTimer.wait_time` | `0.3 s` | Min interval between direction flips. |

## Behavior
- States (string-tagged): `STATE_IDLE` ("idle") and `STATE_RUN` ("run").
- IDLE: animation `asleep`; snore SFX loops on `finished`.
- RUN: `_update_direction()` decides direction by comparing player x to self x. Direction changes are gated by `ChangeDirectionCoolOffTimer` (0.3 s). On direction change, set animation to `look-left` / `look-right` and `move_and_slide(Vector2(speed * direction, 0), UP, false, 4, PI/4, false)`.
- `DetectionArea2D.body_entered` (tall ~168×104 px rect above the head): set state → RUN, stop snore, play walk SFX.
- `DetectionArea2D.body_exited`: set state → IDLE, stop walk, play snore.

## Player interaction
`Area2D.body_entered` (body collision box) → `body.die()`.

## Signals
- `state_cycle_finished` — declared but not emitted anywhere in the script. TBD — likely an unused stub.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_shirime_snore`, `sfx_env_shirime_walk`.

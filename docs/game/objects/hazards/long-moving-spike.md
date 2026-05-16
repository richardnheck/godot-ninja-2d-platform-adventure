# LongMovingSpike

**Category:** Object / Hazard
**Scene:** `src/objects/long-moving-spike/LongMovingSpike.tscn`
**Script:** `src/objects/long-moving-spike/LongMovingSpike.gd` (`class_name LongMovingSpike`)
**Extends:** `Node2D`

## Purpose
A wall-mounted spike with a long telescoping blade that extends out 46 px and retracts in an endless cycle, killing the player on contact with either the blade or the handle while extended.

## Assets
- Sprites: `LongMovingSpikeBase.png` (the wall block), `LongSpikeBlade.png`, `LongSpikeHandle.png`
- SFX: `src/objects/moving-bamboo-spike/bamboo-spike.wav` (re-used; played by a local `AudioStreamPlayer2D`, max distance 120, attenuation 2.2974)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `initial_delay` | float | 0 | Seconds before the first cycle starts. If 0, starts immediately. |

Internal: `time_extend = 1.5 s`, `time_retract = 1.0 s`, `delay = 0.3 s` between cycles, tween range `(0,0) ↔ (0,-46)`. TBD — the `time_extend`/`time_retract` ternary in `_start_tween()` looks inverted (`time_extend if not spike_moving_out else time_retract`), but that's how the source is.

## Behavior
- On `_ready` the handle Area2D's `monitoring` is disabled. If `initial_delay > 0`, `InitialDelayTimer` starts; otherwise `_start_tween()` runs immediately.
- `_start_tween()` interpolates `MovingPart.position` from the current `tween_values[0]` to `tween_values[1]` using `TRANS_QUINT / EASE_IN`.
- On `tween_completed`:
  - If extended (`spike_moving_out`) — play SFX.
  - If retracted — `yield(create_timer(delay), "timeout")` before next.
  - Invert `tween_values`, flip `spike_moving_out`, start the next tween.
- `_on_Tween_tween_step`: when `MovingPart.position.y >= -16`, hide the `SpriteHandle` and disable `HandleArea2D.monitoring`; otherwise show and enable. This avoids needing more than one tile of wall behind the spike base.
- `BaseStaticBody2D` (8×8 block) is a solid wall surface so the player can stand on it.

## Player interaction
On `body_entered` of either `MovingPart/HandleArea2D` or `MovingPart/BladeArea2D`, if the body is in `Constants.GROUP_PLAYER`, calls `body.die()`.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- Player — `die()` receiver.

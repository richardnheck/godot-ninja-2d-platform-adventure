# MovingBambooSpike

**Category:** Object / Hazard
**Scene:** `src/objects/moving-bamboo-spike/MovingBambooSpike.tscn`
**Script:** `src/objects/moving-bamboo-spike/MovingBambooSpike.gd`
**Extends:** `Area2D`

## Purpose
A short bamboo-tip spike that emerges from a base block and retracts on a continuous loop. Smaller and simpler than `LongMovingSpike` — the whole hazard is a single Area2D with no separate "block" StaticBody (the base `SpriteBlock` is purely visual).

## Assets
- Sprites: `MovingBambooSpikeBase.png` (visual block), `MovingBambooSpike.png` (the spike tip)
- SFX: `bamboo-spike.wav` (local `AudioStreamPlayer2D`, max distance 120, attenuation 2.2974)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `initial_delay` | float | 0 | Seconds before the first extension. |

Internal: tween range `(0,8) ↔ (0,-6)` over 1.5 s with `TRANS_QUINT / EASE_IN`.

## Behavior
- On `_ready`: if `initial_delay > 0`, start `InitialDelayTimer`; otherwise call `_start_tween()`.
- `_start_tween()` tweens `CollisionShape2D.position` between `tween_values[0]` and `tween_values[1]`. The spike sprite is a child of the CollisionShape2D, so it follows.
- On `tween_completed`:
  - If `spike_moving_out` (just finished extending) — play SFX.
  - Invert `tween_values`, flip `spike_moving_out`, restart.

Note: there is no idle dwell — the spike immediately reverses at each end.

## Player interaction
The root is itself an `Area2D`. On its own `body_entered`, if the body is in `Constants.GROUP_PLAYER`, calls `body.die()`. Because the CollisionShape2D and its sprite are both child of the Area2D, the spike kills the player throughout its extension cycle whenever the player's hitbox overlaps. (No `tween_step` gating like the long variant.)

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- Player — `die()` receiver.

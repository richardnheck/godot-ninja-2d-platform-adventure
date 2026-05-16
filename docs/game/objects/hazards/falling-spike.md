# FallingSpike

**Category:** Object / Hazard
**Scene:** `src/objects/falling-spike/FallingSpike.tscn`
**Script:** `src/objects/falling-spike/FallingSpike.gd`
**Extends:** `KinematicBody2D`

## Purpose
A ceiling-mounted spike that detects the player walking under it, shakes briefly, then drops under gravity and shatters on impact with the floor. A `FireYokai` ghost (see inline section below) sits above the spike at idle and flies off when the trap triggers.

## Assets
- Spike sprite: `FallingSpike.png`
- Death-effect frames: `assets/art/sprites/enemy-death/enemy-death-{1..6}.png` (used for the `explode` animation @ 20 fps)
- SFX: `Game_AudioManager.sfx_env_falling_spike` (drop), `Game_AudioManager.sfx_env_crumbling_platform_explode` (impact)
- Embedded: `src/objects/fire-yokai/FireYokai.tscn` (preloaded; instanced in the scene at `position (0,-11)`)

## Exported properties
None. Internal constants only: `gravity = 20`, shake animation length 0.2 s.

## Behavior
1. Idle — spike collision active; `FireYokai` floats above as a child.
2. Player enters `TriggerZone` (8×38 column below the spike) → `trigger()`:
   - Re-parents `FireYokai` to the current scene root (so it doesn't move with the spike), positions it at `(x, y-11)`, and calls `fire_yokai.trigger()` to make it fly off.
   - Plays the `AnimationPlayer` `shake` animation.
   - Plays `sfx_env_falling_spike` and sets `triggered = true`.
3. `_physics_process`: while triggered, `vel.y += 20` per frame and `move_and_slide(vel)`.
4. When `vel.y == 0` (landed): stops the drop SFX, plays the explode SFX, plays the `explode` animation, then `queue_free()`.

Collision layer 4, mask 3.

## Player interaction
- `TriggerZone.body_entered` — arms the trap and starts the shake (no damage yet).
- `HitZone.body_entered` (8×38 column of the spike body) — calls `body.die()` if player.

## Signals
None emitted.

## Inline child — FireYokai (`src/objects/fire-yokai/FireYokai.gd`, `class_name FireYokai`, extends `AnimatedSprite`)

A semi-transparent flame ghost (modulate alpha 0.62, 2-frame loop @ 5 fps). Sprite sheet `FireYokaiSpriteSheet.png`. Owns a `Tween` (playback speed 0.5).

- `trigger()` — tweens its `position.y` upwards by 100 px over 0.5 s with `TRANS_BACK / EASE_IN`.
- On `Tween.tween_completed` — `queue_free()`.

Only consumer is `FallingSpike` (instanced in the scene, re-parented and triggered on activation). Not a hazard on its own — no Area2D, purely decorative.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- Player — `die()` receiver.

# Nekekubi

**Category:** Enemy / Chaser (trigger-and-charge player location)
**Scene:** `src/characters/enemies/nekekubi/Nekekubi.tscn`
**Script:** `src/characters/enemies/nekekubi/Nekekubi.gd` (`class_name Nekekubi`)
**Extends:** `Node2D`

## Purpose
A "flying head" female yokai. The body sits still on the floor; when the player enters a wide circular detection range, the detached head (`Head` KinematicBody2D) tweens out to the player's position, then tweens back. While the player remains in range a `ChaseTimer` cooldown queues the next attack cycle.

## Assets
- Body sprite: `nekekubi-body.png` (single-frame `default` at 5 fps).
- Head atlas: `nekekubi-headsheet.png` (32x32 frames). SpriteFrames: `idle` (1f, non-looping), `active` (1f, looping) — visually distinct head states.
- No SFX.

## Exported properties
None.

| Constant | Value | Notes |
|----------|------:|-------|
| `speed` | `100` | Pixels/sec for the head tween. |
| `ChaseTimer.wait_time` | `0.5 s` | Delay between detection and next chase swing. |
| `PlayerDetectionArea2D` radius | `~144 px` | Circle around the body. |

## Behavior
- `_ready()`: yield 0.5 s so the player exists, then `_find_player()` via `"player"` group. Connect `tween.tween_completed`.
- `_on_PlayerDetectionArea2D_body_entered`: switch head sprite to `active`; if head is currently on body (`position == (0,0)`), start `ChaseTimer`.
- `ChaseTimer.timeout` → `_chase_player()`: `is_head_chasing = true`, `_start_tween()`.
- `_start_tween()`:
  - First call latches `tween_values = [local self origin, local position of (player.global_position + (16, 16))]`.
  - Tween duration = `distance / speed`, eased `TRANS_QUAD` `EASE_IN_OUT`.
- `_on_tween_completed`:
  - If chasing (just reached the player): invert tween_values, restart (head returns home).
  - Otherwise (returned to body): reset `tween_values` to `[Vector2.ZERO, Vector2.ZERO]`. If player still in range, restart `ChaseTimer`; else switch head back to `idle`.
- `_on_PlayerDetectionArea2D_body_exited`: `is_player_in_range = false`, stop `ChaseTimer`, switch head to `idle` if home.

## Player interaction
- `Body/Area2D.body_entered` → `body.die()` (touching the body kills).
- `Head/Area2D.body_entered` → `body.die()` (the flying head also kills).

## Signals
None.

## Dependencies
- [player.md](../../player/player.md).
- TBD: the Head is a `KinematicBody2D` with `collision_layer = 0 / mask = 0`, so it doesn't collide with terrain — it teleports through walls on the tween. Intentional (it's a floating ghost head).

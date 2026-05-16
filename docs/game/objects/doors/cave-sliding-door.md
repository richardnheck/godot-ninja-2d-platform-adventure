# CaveLevelSlidingDoor

**Category:** Object / Door
**Scene:** `src/objects/cave-level-sliding-door/CaveLevelSlidingDoor.tscn`
**Script:** `src/objects/cave-level-sliding-door/CaveLevelSlidingDoor.gd` (`class_name LevelSlidingDoor`)
**Extends:** `Node2D`

## Purpose
A vertical sliding gate that physically blocks the player until the level's key is captured. Distinct from the level-end `Door` — this is a mid-level barrier that opens once and stays open. Used as the locked exit corridor in most World 2 and World 3 levels.

## Assets
- Sprite: `src/objects/cave-level-sliding-door/door.png` (uncentered, offset y=-96 — slides up out of frame when opening).
- SFX: `Game_AudioManager.sfx_env_cave_sliding_door` (looping while sliding; stopped on animation_finished).

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `is_locked` | bool | true | When true, walking into the door does nothing. When false, the next contact plays the `open` animation. |

## Scene composition
- `AnimationPlayer` with one animation `open` (1 second): tweens `MovingDoor:position` from `(0,0)` to `(0,-50)`.
- `MovingDoor` (`StaticBody2D`, collision layer 8) — the actual physics blocker plus the sprite, plus a `CollisionShape2D` (`RectangleShape2D` 8 x 48).
- `MovingDoor/Area2D` (collision layer `2147483656`) — trigger zone next to the door; detects the player approaching to start the open animation.

## Behavior
- Internal `opened` flag (separate from `is_locked`) is set true after the first successful open so the animation can't replay.
- `open()` — sets `is_locked = false`. Called by `LevelBase` after the key is captured.
- `close()` — sets `is_locked = true`. Available but not used in shipping levels.
- `_on_Area2D_body_entered(body)`:
  - If the body is in `Constants.GROUP_PLAYER` AND `!is_locked` AND `!opened`:
    - `opened = true`.
    - `animation_player.play("open")`.
    - `sfx_env_cave_sliding_door.play()`.
- `_on_AnimationPlayer_animation_finished(name)` stops the SFX.
- The `StaticBody2D` itself does NOT teleport — it tweens via the AnimationPlayer track on `position`, so collision shifts with the sprite.

## Player interaction
- Locked: door is a solid wall (StaticBody2D blocks horizontal movement). Walking into the trigger does nothing.
- Unlocked (after key pickup): walking into the trigger plays the slide-open animation, the StaticBody2D moves up, and the player can walk through.

## Signals
None.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Constants.GROUP_PLAYER`.
- [objects/interactive/kamon-key.md](../interactive/kamon-key.md) — `LevelBase._on_Key_captured` calls `door.open()` on this scene.
- [levels/level-base.md](../../levels/level-base.md) — owns the key→door wiring.

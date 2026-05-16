# CreepyCrawly

**Category:** Enemy / PathFollow (basic stationary)
**Scene:** `src/characters/enemies/creepy-crawly/CreepyCrawly.tscn`
**Script:** (none — uses [`SimpleEnemy.gd`](simple-enemy.md) via the inherited scene)
**Extends:** `SimpleEnemy.tscn` (inherits `KinematicBody2D` + `SimpleEnemy.gd`)

## Purpose
Stationary ground bug. A scene-only variant of [SimpleEnemy](simple-enemy.md) that swaps in the creepy-crawly sprite frames and a flatter capsule collision shape. Used as low-threat scenery filler.

## Assets
- SpriteFrames resource: `src/characters/enemies/creepy-crawly/creepy_crawly_sprite_frames.tres` (loaded onto `Pivot/AnimatedSprite`).
- Sprite atlas: `src/characters/enemies/creepy-crawly/creepy-crawly.png`.
- No SFX.

## Exported properties
Inherited from [SimpleEnemy](simple-enemy.md). Scene leaves defaults: `look_at_player_enabled = true`, `can_move = true`, `velocity = (0,0)`, `affected_by_gravity = false`.

## Behavior
- See [simple-enemy.md](simple-enemy.md) for the full base behavior (random animation start delay, look-at-player, optional gravity/move, visibility pause/resume).
- Scene overrides:
  - `Pivot/AnimatedSprite.position = (0, -8)` and uses the creepy-crawly frames.
  - `Pivot/Area2D` collision uses a flat 6.23 × 1.68 capsule at `(0, -7.5)` (`collision_layer = 8`).
  - Root `CollisionShape2D` hidden / moved to `(0, -1)`.
- Because `velocity` defaults to zero and gravity is off, it stays put and only animates.

## Player interaction
Standard SimpleEnemy: `Pivot/Area2D.body_entered` → `body.die()`.

## Signals
None.

## Dependencies
- [simple-enemy.md](simple-enemy.md).
- [player.md](../../player/player.md).
- TBD — no explicit `.gd` script on this scene; if a porter needs custom behavior they'd attach one. As shipped, all logic lives in `SimpleEnemy.gd`.

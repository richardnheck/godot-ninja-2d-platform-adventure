# SimpleEnemy

**Category:** Enemy / PathFollow (basic stationary base)
**Scene:** `src/characters/enemies/SimpleEnemy.tscn`
**Script:** `src/characters/enemies/SimpleEnemy.gd` (`class_name SimpleEnemy`)
**Extends:** `KinematicBody2D`

## Purpose
Minimal "stand still, animate, kill on touch" enemy base. Used directly by CreepyCrawly and inherited by OneEyedSpikey. Optionally faces the player and can fall under gravity.

## Assets
- No bundled sprite — `SimpleEnemy.tscn` defaults to the OneEyedSpikey sheet (`src/characters/enemies/one-eyed-spikey/one-eyed-spikey.png`, 7-frame AnimatedSprite at 5 fps); subclasses override `Pivot/AnimatedSprite.frames`.
- No SFX.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `look_at_player_enabled` | bool | `true` | Flip `AnimatedSprite.flip_h` toward player every `_process`. |
| `can_move` | bool | `true` | If false, no `move_and_slide`. |
| `velocity` | Vector2 | `(0,0)` | Constant velocity applied each frame. |
| `affected_by_gravity` | bool | `false` | If true, adds `gravity` to `velocity.y`. |
| `gravity` | int | `15` | Per-frame y acceleration when gravity enabled. |

## Behavior
- `_ready()` connects `Pivot/Area2D.body_entered`, waits `rand_range(0, 2)` seconds before starting the animation (de-syncs multiple instances), grabs the player via `get_tree().get_nodes_in_group("player")[0]`.
- `_process` → `_look_at_player()` flips horizontally based on player x.
- `_physics_process` → if `can_move`: optionally apply gravity, then `move_and_slide(velocity, UP, false, 4, PI/4, false)` and emit `collided` on `owner` per slide-collision (matches the Player's collision signal).
- `VisibilityNotifier2D.screen_entered/exited` resume/pause `tween` and animation.

## Player interaction
`Pivot/Area2D.body_entered`: if body is in `Constants.GROUP_PLAYER`, calls `body.die()`.

## Signals
None emitted directly. Emits `collided(collision)` on `owner` (typically the owning scene root) — currently unused outside Player.

## Dependencies
- `Constants.GROUP_PLAYER`, [player.md](../../player/player.md).
- Subclasses: [one-eyed-spikey.md](one-eyed-spikey.md), [creepy-crawly.md](creepy-crawly.md).
- Collision: KinematicBody2D layer 8 / mask 2.

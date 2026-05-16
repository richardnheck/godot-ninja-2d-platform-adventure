# OneEyedSpikey

**Category:** Enemy / PathFollow (basic stationary)
**Scene:** `src/characters/enemies/one-eyed-spikey/OneEyedSpikey.tscn`
**Script:** `src/characters/enemies/one-eyed-spikey/one_eyed_spikey.gd` (`class_name OneEyedSpikey`)
**Extends:** `SimpleEnemy` (see [simple-enemy.md](simple-enemy.md))

## Purpose
A floating one-eyed spike-ball that hovers between two points on a 2-second sine tween, either vertically or horizontally. Uses `SimpleEnemy` as its base but adds its own hover-tween instead of relying on `move_and_slide`.

## Assets
- Sprite: `one-eyed-spikey.png` (the same default sheet used by `SimpleEnemy.tscn`).
- No SFX.

## Exported properties (in addition to inherited SimpleEnemy)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `float_offset` | int | `50` | Hover distance (px) between the two tween endpoints. |
| `direction` | enum `Direction` | `UP_DOWN` | `UP_DOWN` (vertical hover) or `LEFT_RIGHT` (horizontal hover). |

Inherited from SimpleEnemy: `look_at_player_enabled`, `can_move`, `velocity`, `affected_by_gravity`, `gravity`.

## Behavior
- `_ready()` connects `tween.tween_completed` and immediately calls `_start_tween()` (does NOT chain SimpleEnemy's `_ready`, but the parent scene's `Pivot/Area2D` and visibility hooks still wire up).
- `_start_tween()`:
  - First call: latches endpoints to `[global_position, global_position ± float_offset]` along the chosen axis.
  - Tweens `self.position` between the two endpoints over `2 s`, `TRANS_QUAD` + `EASE_IN_OUT`.
- `_on_tween_completed` inverts `tween_values` and restarts (perpetual ping-pong).
- Because `can_move`/gravity remain `false` in the scene, `SimpleEnemy._physics_process` does no movement — the tween IS the motion.

## Player interaction
Standard SimpleEnemy: `Pivot/Area2D.body_entered` → `body.die()`.

## Signals
None.

## Dependencies
- [simple-enemy.md](simple-enemy.md), [player.md](../../player/player.md).

# TofuKozo

**Category:** Enemy / Thrower
**Scene:** `src/characters/enemies/tofu-kozo/TofuKozo.tscn`
**Script:** `src/characters/enemies/tofu-kozo/TofuKozo.gd` (`class_name TofuKozo`)
**Extends:** `Area2D` (in `enemy` group)

## Purpose
A small umbrella-hat yokai holding a plate of tofu. Stands in place; periodically performs a "prep then throw" animation and launches a `Tofu` RigidBody2D in an arc toward the player's direction. Turns to face the player while they're in range.

## Assets
- Sprite atlas: `tofu-kozo-sheet.png` (45x48 frames). SpriteFrames:
  - `idle` (22-frame loop @ 10 fps — mostly held on one frame for the static pose)
  - `prep` (2f @ 15 fps, non-looping)
  - `throw` (2f @ 5 fps, non-looping)
- AnimationPlayer drives plate offset: `RESET` (resting position) and `prep` (lifts the plate 4 px on prep).
- No SFX on the TofuKozo itself; the Tofu projectile plays its own land SFX.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `direction` | enum `Direction` | `RIGHT` | `LEFT (-1)` or `RIGHT (1)`. Initial facing — applied via `scale.x = direction`. |
| `follow_player` | bool | `true` | If true, turns to face the player every `_process` while in range. |

Constants in script:
| Constant | Value | Notes |
|----------|------:|-------|
| `throw_impulse_strength` | `240` | Base impulse magnitude on the Tofu RigidBody2D. |
| `throw_x_amount` | `0.15` | x-component of the throw direction (very upward + slight horizontal). |
| `ThrowTimer.wait_time` | `2.0 s` | Interval between throws. |

## Behavior
- `_ready()`: switch sprite to `idle`, update facing, after 0.1 s call `_add_tofu()` to instance a fresh `Tofu.tscn` onto the current scene at `TofuPosition2D.global_position`. Cache the reference as `self.tofu`.
- `_process`: while `follow_player` and `player_in_range`, set `direction` from player x and `_update_character()` (rescales the entire node).
- `_physics_process`: if `throw` flag set and a tofu is held: switch sprite to `throw`, compute `throw_direction = (throw_x_amount * direction, -1)`, apply impulse `(throw_impulse_strength + rng.randi_range(-20, 20))` magnitude. Clear `tofu` reference and `throw = false`.
- `PlayerDetectionArea2D.body_entered` (very large ~332×322 rect): on first entry, set `player_in_range = true`, call `_throw_tofu()`, start `ThrowTimer`.
- `_throw_tofu()`: if no tofu currently held, `_add_tofu()`. Switch sprite to `prep`, play `prep` AnimationPlayer track (plate hop). After 0.3-s telegraph delay, if player still in range set `throw = true` (next `_physics_process` actually fires it).
- `ThrowTimer.timeout` → `_throw_tofu()`. `PlayerDetectionArea2D.body_exited` → `player_in_range = false`.
- `AnimatedSprite.animation_finished`: when `throw` finishes, return to `idle` and `RESET` plate position.

## Player interaction
- `TofuKozo.body_entered` (own Area2D as the `TofuKozo` root) → `body.die()`. Touching the kozo kills the player.
- `Tofu` projectile kills on contact (see below).

## Signals
None.

### Inline projectile: Tofu
**Scene:** `.../tofu-kozo/Tofu.tscn`
**Script:** `.../Tofu.gd` (`class_name Tofu`)
**Extends:** `RigidBody2D`

- `gravity_scale = 6.0` (much heavier than the default), uses default linear damping.
- `Area2D.body_entered`: if player → `body.die()`. If body is a `TileMap` → play `Game_AudioManager.sfx_env_tofu_land` (duplicated) and set `_landed = true` (does NOT `queue_free` — the tofu lies on the ground).
- Sprite: single-frame `default` from `tofu-sheet.png` at offset `(0, -8)`.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_tofu_land`.
- The Tofu is added to `get_parent().get_tree().current_scene` (NOT to `Projectiles`). TBD — may persist in scene after landing.

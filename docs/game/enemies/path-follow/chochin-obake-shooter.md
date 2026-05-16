# ChochinObakeShooter

**Category:** Enemy / PathFollow (with projectile)
**Scene:** `src/characters/enemies/path-follow-enemy/chochin-obake-shooter/ChochinObakeShooter.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/chochin-obake-shooter/ChochinObakeShooter.gd` (`tool`, `class_name ChochinObakeShooter`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A variant of the floating lantern yokai that periodically drops a falling candle (gravity-driven spike with an explosion + fire-yokai spawn) onto the player.

## Assets
- Sprite: `ChochinObakeShooterSheet.png` (24-frame default loop at 10 fps, 32x40 frames).
- Candle: see inline projectile below.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `path_length` | int | `100` | Length of procedurally built straight curve. |
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | Only `HORIZONTAL_LEFT_RIGHT` / `HORIZONTAL_RIGHT_LEFT` are honoured in the scene (script also handles vertical for completeness). |

## Behavior
- Overrides base defaults: `speed = 30`, `tween_transition_type = TRANS_SINE`, `follow_path_type = PING_PONG`, `oscillation_amplitude = 2`, `oscillation_frequency = 5`.
- `ShootTimer` (autostart, `wait_time = 1.3 s`) → `_drop_candle()` instances `FallingCandle.tscn` 8 px to the left of the sprite, adds it to `get_parent().get_tree().current_scene`, calls `candle.trigger()` (no-op guarded by `has_method`).

## Player interaction
Standard base body-touch death. The dropped candle has its own hit zone (see below).

## Signals
None.

### Inline projectile: FallingCandle
**Scene:** `.../chochin-obake-shooter/falling-candle/FallingCandle.tscn`
**Script:** `.../FallingCandle.gd`
**Extends:** `KinematicBody2D` (in `falling_spike` group, layer 4 / mask 3)

- Idle (sprite shaking-anim available but autoplay = idle). `trigger()` plays `sfx_env_falling_spike` and sets `triggered = true`.
- While `triggered`: `vel.y += gravity (=10)` per frame, `move_and_slide(vel)`. When `vel.y == 0` on first contact (`crashed` latch), stops the falling SFX, plays `sfx_env_candle_explosion`, reparents `$FireYokai` to the current scene at `y - 11` and calls `fire_yokai.trigger()`, plays the `explode` AnimatedSprite (6 frames @ 20 fps using `enemy-death-*.png`), and `queue_free()` on animation finish.
- `HitZone` (Area2D) `body_entered`: if player → `body.die()`.
- `$FireYokai` child is an instance of `src/objects/fire-yokai/FireYokai.tscn` (homing fire effect; documented elsewhere).

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_falling_spike`, `sfx_env_candle_explosion`.
- `src/objects/fire-yokai/FireYokai.tscn`.
- `Projectiles` is NOT used by this shooter (parent = `current_scene`).

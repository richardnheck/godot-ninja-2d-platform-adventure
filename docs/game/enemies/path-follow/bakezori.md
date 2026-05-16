# Bakezori

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/bakezori/Bakezori.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/bakezori/Bakezori.gd` (`tool`, `class_name Bakezori`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A sandal yokai that slides back and forth along a horizontal segment with sine easing. Faster than most path-follow enemies (`speed = 70`).

## Assets
- Sprite: `BakezoriSheet.png` (6-frame default loop at 10 fps, 16x24 frames).
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `path_length` | int | `100` | Length of the procedurally built straight horizontal curve. |
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | Either `HORIZONTAL_LEFT_RIGHT` or `HORIZONTAL_RIGHT_LEFT` (vertical not supported). |

## Behavior
- Overrides base defaults: `speed = 70`, `tween_transition_type = TRANS_SINE`, `follow_path_type = PING_PONG`.
- Builds a 2-point straight horizontal `Curve2D` of length `path_length`. `HORIZONTAL_RIGHT_LEFT` inverts the curve direction and toggles `flip_h` once at start.
- Otherwise standard base behavior.

## Player interaction
Standard base behavior: `Area2D.body_entered` → `body.die()`.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md).
- [player.md](../../player/player.md).

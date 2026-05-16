# ChochinObake

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/chochin-obake/ChochinObake.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/chochin-obake/ChochinObake.gd` (`tool`, `class_name ChochinObake`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A floating lantern yokai that drifts back and forth along a straight, vertical, or 45°-diagonal segment with a subtle vertical bob. The most flexible of the path-follow yokai in terms of orientation.

## Assets
- Sprite: `ChochinObakeSheet.png` (24-frame default loop at 10 fps, 32x40 frames).
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | 8 options: horizontal L↔R, vertical, and 45° / 135° diagonals (each with two directions). |
| `path_length` | int | `64` | Total length; diagonal orientations split into `path_length / (2·sqrt(2))` per axis. |

## Behavior
- Overrides base defaults: `speed = 40`, `tween_transition_type = TRANS_SINE`, `follow_path_type = PING_PONG`, `oscillation_amplitude = 2`, `oscillation_frequency = 5` (gentle hover bob on top of path motion).
- Builds a 2-point straight `Curve2D` matching the chosen orientation: horizontal, vertical, ANGLE_45 (slope `\`), or ANGLE_135 (slope `/`), each with two directions.
- Otherwise standard base behavior (visibility-driven, ping-pong with sprite flip).

## Player interaction
Standard base behavior: `Area2D.body_entered` → `body.die()`.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md).
- [player.md](../../player/player.md).

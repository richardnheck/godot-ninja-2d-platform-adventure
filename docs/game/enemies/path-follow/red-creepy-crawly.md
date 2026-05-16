# RedCreepyCrawly

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/red-creepy-crawly/RedCreepyCrawly.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/red-creepy-crawly/RedCreepyCrawly.gd` (`tool`, `class_name RedCreepyCrawly`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
Faster, more aggressive variant of CreepyCrawly. A red bug that crawls back and forth horizontally with linear motion. Unlike (script-less) CreepyCrawly, this one uses the path-follow rig with a procedurally generated curve.

## Assets
- Sprite: `creepy-crawly-sheet.png` (16x16 frames).
- SpriteFrames: 8-frame `default` loop at 5 fps.
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `path_length` | int | `100` | Length of procedurally built horizontal curve. |
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | `HORIZONTAL_LEFT_RIGHT` flips the sprite once on init (so it faces movement direction); `HORIZONTAL_RIGHT_LEFT` inverts the curve. |

## Behavior
- Overrides base defaults: `speed = 40`, `tween_transition_type = TRANS_LINEAR`, `follow_path_type = PING_PONG`.
- Builds a 2-point straight horizontal `Curve2D` of length `path_length`. No oscillation.
- Standard base ping-pong: flips `flip_h` each reversal.

## Player interaction
Standard base body-touch death.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).

# Ashimigarari

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/ashimigarari/Ashimigarari.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/ashimigarari/Ashimigarari.gd` (`tool`, `class_name Ashimigarari`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A floor/wall/ceiling-crawling yokai that slides back and forth along a straight horizontal or vertical segment. Orientation chooses which surface it clings to and the curve is built procedurally in `_ready()`.

## Assets
- Sprite: `AshimigarariSheet.png` (3-frame default loop at 5 fps, 36x16).
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `path_length` | int | `100` | Total length of the procedurally built straight curve. |
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | `HORIZONTAL_LEFT_RIGHT`, `HORIZONTAL_RIGHT_LEFT`, `VERTICAL_BOTTOM_UP`, `VERTICAL_TOP_DOWN`. |
| `horizontal_wall_direction` | enum | `DOWN` | `UP` (ceiling) or `DOWN` (ground). When `UP`, `flip_v = true`. Only used for horizontal orientations. |
| `vertical_wall_direction` | enum | `RIGHT` | `LEFT` or `RIGHT` wall. When `RIGHT`, `flip_v = true`. Only used for vertical orientations. |

## Behavior
- Overrides base defaults: `speed = 25`, `tween_transition_type = TRANS_LINEAR`, `follow_path_type = PING_PONG` (constant crawl, no easing).
- Builds a 2-point straight `Curve2D` of length `path_length` along the chosen axis. Vertical orientations rotate `AnimatedSprite` 90°; horizontal orientations rotate `CollisionShape2D` 90°. The wall-direction enums flip the sprite so the body always faces the wall.
- Otherwise behaves identically to the base (visibility-driven tween, ping-pong with `flip_h` toggle on each reversal).

## Player interaction
Standard base behavior: `Area2D.body_entered` → `body.die()`.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md).
- [player.md](../../player/player.md).

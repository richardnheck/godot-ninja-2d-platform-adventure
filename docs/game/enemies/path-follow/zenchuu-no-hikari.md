# ZenchuuNoHikari

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/zenchuu-no-hikari/ZenchuuNoHikari.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/zenchuu-no-hikari/ZenchuuNoHikari.gd` (`class_name ZenchuuNoHikari`)
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A long vertical glowing-worm yokai (literally "intestinal light") that drifts up and down along a straight vertical segment with quadratic easing. Special sprite handling: instead of mirroring horizontally on ping-pong reversal, it flips vertically and offsets the sprite to keep the body anchored.

## Assets
- Sprite: `ZenchuuNoHikariSheet.png` (16x48 frames, 3 cells).
- SpriteFrames: 3-frame `default` loop at 5 fps. Sprite is `centered = false`, offset `(17, 0)`.
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `path_length` | int | `100` | Length of the procedurally built vertical curve. |
| `orientation` | enum `Orientation` | `VERTICAL_TOP_DOWN` | `VERTICAL_BOTTOM_UP` or `VERTICAL_TOP_DOWN`. |

## Behavior
- Overrides base defaults: `speed = 30`, `tween_transition_type = TRANS_QUAD`, `follow_path_type = PING_PONG`.
- Builds a 2-point straight vertical `Curve2D` of length `path_length`.
- **Custom ping-pong flip**: overrides `_on_tween_completed` to call `super` then force `flip_h = false` and toggle `flip_v` instead. When `flip_v` is true, shifts `animated_sprite.offset.y = -20` so the long body stays visually attached to its end-point on reversal.

## Player interaction
Standard base body-touch death.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).

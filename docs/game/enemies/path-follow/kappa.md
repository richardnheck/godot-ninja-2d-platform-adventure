# Kappa

**Category:** Enemy / PathFollow (scene-only)
**Scene:** `src/characters/enemies/path-follow-enemy/kappa/Kappa.tscn`
**Script:** (none — uses [`PathFollowEnemyBase.gd`](path-follow-base.md) via the inherited scene)
**Extends:** `PathFollowEnemyBase.tscn`

## Purpose
Water-imp yokai that walks continuously along a level-supplied path. Scene-only override of `PathFollowEnemyBase` with no custom GDScript.

## Assets
- Sprite atlas: `kappa-spritesheet.png` (37x28 frames, 5 cells).
- SpriteFrames: 5-frame `default` loop at 12 fps.
- AnimatedSprite offset = `(0, -4)` so the body sits above the path point.
- No SFX.

## Exported properties
Inherited from `PathFollowEnemyBase`. Scene overrides:
| Inherited | Value in scene |
|-----------|---------------|
| `tween_transition_type` | `TRANS_LINEAR` (0) |
| `follow_path_type` | `CONTINUOUS` (1) |
| Others | base defaults |

## Behavior
Standard `PathFollowEnemyBase`: constant-speed linear walk along the level Path2D, looping continuously. Direction flip handled by the base on loop reset.

## Player interaction
Standard base body-touch death.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- TBD — prefab ships with no `Curve2D`; the level must supply one.

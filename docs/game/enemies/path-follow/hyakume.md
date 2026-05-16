# Hyakume

**Category:** Enemy / PathFollow (scene-only)
**Scene:** `src/characters/enemies/path-follow-enemy/hyakume/Hyakume.tscn`
**Script:** (none — uses [`PathFollowEnemyBase.gd`](path-follow-base.md) via the inherited scene)
**Extends:** `PathFollowEnemyBase.tscn`

## Purpose
The "hundred-eyes" yokai — a passive eye-mass that creeps along a level-supplied path. Pure scene override of `PathFollowEnemyBase` with no custom GDScript.

## Assets
- Sprite atlas: `Hyakume-Sheet.png` (23x23 frames, 3 cells) plus a separate idle `Hyakume.png`.
- SpriteFrames: 6-frame `default` loop (`idle, f1, f2, f3, f2, idle`) at 8 fps.
- No SFX.

## Exported properties
Inherited from `PathFollowEnemyBase`. Scene overrides:
| Inherited | Value in scene |
|-----------|---------------|
| `tween_transition_type` | `TRANS_LINEAR` (0) |
| `follow_path_type` | `CONTINUOUS` (1) |
| (`speed`, `offset`, `delay`, oscillation) | defaults from base |

## Behavior
Standard `PathFollowEnemyBase`: walks the level-supplied Path2D at constant speed (linear interpolation), looping continuously from start to end (no ping-pong). Sprite flip on direction change is handled by the base.

## Player interaction
Standard base body-touch death.

## Signals
None.

### Variant: HyakumeLarge
**Scene:** `src/characters/enemies/path-follow-enemy/hyakume/HyakumeLarge.tscn` — same base + same overrides; uses the much larger static `HyakumeLarge.png` as a single-frame `default` animation at 5 fps and a slightly shifted collision shape. No script. Used as a giant background variant.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- TBD — prefab ships with no `Curve2D`; the level must supply one.

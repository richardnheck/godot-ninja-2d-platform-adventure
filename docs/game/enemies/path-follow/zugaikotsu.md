# Zugaikotsu

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/zugaikotsu/Zukaikotsu.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/zugaikotsu/Zukaikotsu.gd`
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
A floating skull yokai that drifts along a level-supplied path with a fast, tight vertical wobble. Files are misspelled `Zukaikotsu` in source; the proper name is "Zugaikotsu" (頭蓋骨 — skull).

## Assets
- Sprite: `zukaikotsu.png` (24x18 frames, 3 cells).
- SpriteFrames: 3-frame `default` loop at 5 fps.
- No SFX.

## Exported properties (in addition to PathFollowEnemyBase)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `flip_sprite` | bool | `false` | Initial horizontal flip — set true when the level's path runs right-to-left so the skull's face points along the travel direction. |

## Behavior
- Overrides base defaults: `speed = 40`, `tween_transition_type = TRANS_SINE`, `follow_path_type = PING_PONG`, `oscillation_amplitude = 5`, `oscillation_frequency = 10` (tight, fast wobble).
- Relies on the **level-supplied** Path2D curve (the prefab ships no `Curve2D`).
- Otherwise standard base behavior.

## Player interaction
Standard base body-touch death.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- TBD — the prefab has no `Curve2D`; levels must author the path.

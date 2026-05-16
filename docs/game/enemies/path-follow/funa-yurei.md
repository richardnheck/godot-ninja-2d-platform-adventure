# FunaYurei

**Category:** Enemy / PathFollow
**Scene:** `src/characters/enemies/path-follow-enemy/funayurei/FunaYurei.tscn`
**Script:** `src/characters/enemies/path-follow-enemy/funayurei/FunaYurei.gd`
**Extends:** `PathFollowEnemyBase` (see [path-follow-base.md](path-follow-base.md))

## Purpose
Drowned-sailor yokai that drifts slowly along a Path2D defined in the level (`curve` left null in the prefab — placement responsibility is the level designer's) with a large vertical sinusoidal bob, giving a "swimming through fog" motion.

## Assets
- Sprite: `FunaYureiSheet.png` (6-frame default loop at 5 fps, 32x32 frames).
- No SFX.

## Exported properties
Inherited from `PathFollowEnemyBase` only. The script overrides defaults at `_ready()` and exposes no new exports.

| Override | Value |
|----------|-------|
| `speed` | `20` |
| `tween_transition_type` | `TRANS_SINE` |
| `follow_path_type` | `PING_PONG` |
| `oscillation_amplitude` | `30` |
| `oscillation_frequency` | `4` |

## Behavior
- Relies on the **level-supplied** Path2D curve (the prefab ships no `Curve2D`; placing a FunaYurei requires drawing the path inline). All other base behavior applies.
- Strong vertical oscillation (amplitude 30) gives a bobbing wave motion on top of the path tween.

## Player interaction
Standard base body-touch death.

## Signals
None.

## Dependencies
- [path-follow-base.md](path-follow-base.md), [player.md](../../player/player.md).
- TBD — the prefab has no `Curve2D` set, so placing this enemy in a level requires authoring the curve in the level scene.

# MegamanElectricity

**Category:** Object / Hazard
**Scene:** `src/objects/electricity/MegamanElectricity.tscn`
**Script:** `src/objects/electricity/Electricity.gd` (a 10-line `body_entered` → `die()` handler — see [Notes](#notes))
**Extends:** `Node2D`

## Purpose
An always-on horizontal "Megaman-style" electric strip. Loops a 4-frame animation, kills the player on contact, and pauses processing when off-screen via a `VisibilityEnabler2D`. Used densely throughout World 3 to wall off corridors and create timing puzzles when combined with springs/conveyors.

## Assets
- Sprite sheet: `src/objects/electricity/MegamanStyleElectritySheet.png` — 4 atlas frames of `64 × 16` arranged horizontally. Loops at 7 fps.
- No SFX.

## Exported properties
None.

## Behavior
- Pure scene-driven. The `AnimatedSprite` autoplays its 4-frame loop. The `Area2D` is always monitoring.
- `VisibilityEnabler2D` toggles `process_parent` and `physics_process_parent`, pausing the node when off-screen.
- The root node is in the `trap` group; the inner `Area2D` is on `collision_layer = 4` (the `objects` layer).
- Collision hitbox: `RectangleShape2D` with extents `(32, 5)` — a 64 × 10 px strip.

## Player interaction
On `Area2D.body_entered`, if the body is in `Constants.GROUP_PLAYER`, the script calls `body.die()`.

The trap-group membership also means `LevelBase._on_Player_collided` would route a TileMap-style collision through `player.die(groups)`, but Area2D contact is the primary kill path.

## Signals
None.

## Scene tree
- `MegamanElectricity` (Node2D, group `trap`)
  - `VisibilityEnabler2D` (pauses parent processing when off-screen)
  - `AnimatedSprite` (4-frame loop, autoplays)
  - `Area2D` (`collision_layer = 4`, group `trap`)
    - `CollisionShape2D` — `RectangleShape2D(32, 5)`

## Levels used in
World 3: levels 3, 4, 5, 6 and the boss arena. Some levels use 20+ instances stacked into wall grids.

## Notes
- The script `Electricity.gd` is shared with the (unused) `Electricity.tscn` and `BlueFlame.tscn` experimental scenes that are not documented. The script itself is just a `_on_Area2D_body_entered` handler — porting MegamanElectricity needs nothing more than a sprite, a collision shape, and that one signal handler.

## Dependencies
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- [../../player/player.md](../../player/player.md) — receives `die()`.
- [../../levels/level-base.md](../../levels/level-base.md) — `trap`-group routing.

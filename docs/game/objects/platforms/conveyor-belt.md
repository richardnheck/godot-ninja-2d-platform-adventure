# ConveyorBelt

**Category:** Object / Platform
**Scene:** `src/objects/conveyor-belt/ConveyorBelt.tscn`
**Script:** `src/objects/conveyor-belt/ConveyorBelt.gd` (`tool` script — runs in the editor so length changes are previewed live)
**Extends:** `StaticBody2D`

## Purpose
A horizontal moving-belt surface of configurable length. Uses Godot's built-in `StaticBody2D.constant_linear_velocity` to push any body in contact along the X axis. The belt texture scrolls visually to match. When the player steps off, their applied horizontal momentum is reset so they don't keep the belt's speed.

## Assets
- Centre tile: `block.png` (used as an `AtlasTexture` whose region scrolls horizontally)
- End-cap sprite: `belt-end.png` (used twice — `LeftEndPointSprite` and `RightEndpointSprite` with `flip_h`)

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `speed` | int | 70 | Horizontal speed in px/s. Sign sets direction. Drives both `constant_linear_velocity.x` and the visual scroll. Scene default is `75`. |
| `length` | int | 1 | Length in 16-px tiles. The collision shape and the Area2D detector are stretched to `length * 16`. |

Internal: `TILE_SIZE = 16`.

## Behavior
- `_ready`:
  - Sets the solid `CollisionShape2D` and the `Area2D/CollisionShape2D` half-extents on X to `length * 16 / 2`, and shifts their X positions so the belt extends to the right of the origin (placement-friendly).
  - Sets the sprite's `texture.region` width to `length * TILE_SIZE`.
  - Sets `constant_linear_velocity.x = speed`.
  - Positions `RightEndpointSprite` at `length * 16 - 8`.
- `_process(delta)`: scrolls `sprite.texture.region.position.x -= speed * delta` so the belt visually moves.
- The Area2D acts as a presence detector — `body_exited` calls `body.reset_applied_velocity()` (defined on `Player`) when the player steps off, clearing the belt-applied horizontal velocity.

The belt is on collision layer 2 (standard "world" layer); the Area2D's child CollisionShape2D is added to group `conveyor-belt`.

## Player interaction
- Standing on the belt: `constant_linear_velocity` pushes the player as part of the standard `move_and_slide` resolution.
- Stepping off: `reset_applied_velocity()` zeros the player's X velocity component so they don't keep gliding.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- [player/player.md](../../player/player.md) — `reset_applied_velocity()` method.

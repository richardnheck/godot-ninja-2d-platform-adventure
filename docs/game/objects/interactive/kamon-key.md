# KamonKey

**Category:** Object / Interactive
**Scene:** `src/objects/key/KamonKey.tscn`
**Script:** `src/objects/key/KamonKey.gd`
**Extends:** `AnimatedSprite`

## Purpose
The collectible key that unlocks the level's exit door. The player must walk into it to pick it up. Used in every World 2 and World 3 standard level.

## Assets
- Sprite atlas: `src/objects/key/key.png` (13 unique frames at 32x32 px, padded to 26 frames so the final glow holds; `default` animation, 12 fps, looped).
- SFX: `Game_AudioManager.sfx_collectibles_key`.

## Exported properties
None.

## Behavior
- Root is `AnimatedSprite` in the `key` group, autoplaying `default`.
- `VisibilityEnabler2D` pauses the animation and the parent's processing off-screen (`process_parent = true`, `physics_process_parent = true`).
- A child `Area2D` (collision layer 8, with a `RectangleShape2D` of extents ~14 x 10) detects the player.
- `show_key(value)` — toggles `visible` and deferred-disables the collision shape. Used by `LevelBase` to hide the key when checkpoint state already has the key.
- `_on_Area2D_body_entered(body)` — if the body is in `Constants.GROUP_PLAYER`:
  1. Emits `captured`.
  2. Plays `sfx_collectibles_key`.
  3. Calls `show_key(false)`.
  4. `queue_free()`s the key.

## Player interaction
Walk into the key sprite → it disappears, SFX plays, level unlocks the cave sliding door.

## Signals
- `captured()` — listener is connected in `LevelBase._setup_key()`/`_ready()` block (`key.connect("captured", self, "_on_Key_captured")`) AND in every per-level scene file (`[connection signal="captured" from="InteractiveProps/KamonKey" ...]`). The handler `_on_Key_captured()` lives in `LevelBase.gd` (line ~234): sets `LevelData.has_key = true` and calls the level's sliding door `open()`.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Constants.GROUP_PLAYER`, `LevelData`.
- [objects/doors/cave-sliding-door.md](../doors/cave-sliding-door.md) — the door that unlocks on capture.
- [levels/level-base.md](../../levels/level-base.md) — `_on_Key_captured` handler.

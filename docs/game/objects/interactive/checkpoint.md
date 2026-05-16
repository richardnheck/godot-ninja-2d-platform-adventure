# CheckPoint

**Category:** Object / Interactive
**Scene:** `src/objects/checkpoint/CheckPoint.tscn`
**Script:** `src/objects/checkpoint/CheckPoint.gd` (`class_name Checkpoint`)
**Extends:** `Area2D`

## Purpose
A respawn marker. The player touches one to set `LevelData.level_checkpoint_reached` so death respawns the player here instead of at the level start. Up to one checkpoint per level is the typical use; an `id` export disambiguates if multiple are placed.

## Assets
- Sprites: `src/objects/checkpoint/CheckPoint#1.png` (off), `CheckPoint#2.png` (on).
- AnimatedSprite has two animations: `off` and `on` (each is a single still frame, looped at 5 fps).
- SFX: `Game_AudioManager.sfx_env_check_point` (plays once when activated).

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `id` | String | `'1'` | Unique identifier. `LevelBase` calls `set_on(LevelData.level_checkpoint_reached)` on every checkpoint at level start, lighting up only the one whose `id` matches. |

## Behavior
- Root is in the `checkpoint` group (`Constants.GROUP_CHECKPOINT`) — `LevelBase._ready()` iterates this group.
- `_ready()` calls `set_on(Constants.NO_CHECKPOINT)` so every checkpoint starts in the `off` state.
- `set_on(checkpoint_id)` — sets internal `_on` flag if `id == checkpoint_id`, plays `"on"` or `"off"` accordingly.
- `show_checkpoint(value)` — toggles `visible` and the collision shape's `disabled`. `LevelBase` calls this to hide all checkpoints when `Settings.get_level_checkpoints_enabled()` is false (or `get_boss_level_checkpoints_enabled()` on boss levels).
- `_on_body_entered(body)` — if the body is in `Constants.GROUP_PLAYER` AND `_on == false`:
  - Sets self on (`set_on(id)` → plays `"on"`).
  - Plays `sfx_env_check_point`.
  - Emits `reached(id)`.

## Player interaction
Walk into the (initially unlit) checkpoint → it animates to lit, plays the SFX, and the level remembers this as the respawn point. Already-lit checkpoints are inert.

## Signals
- `reached(id: String)` — emitted on first touch. Listener: `LevelBase._on_CheckPoint_reached(id)` (connected in `LevelBase._ready()`), which calls `LevelData.set_checkpoint_reached(id)`. `LevelData` additionally records `checkpoint_reached_with_key` for door-state preservation.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Constants.GROUP_PLAYER`, `Constants.GROUP_CHECKPOINT`, `Constants.NO_CHECKPOINT`, `LevelData`, `Settings`.
- [levels/level-base.md](../../levels/level-base.md) — owns the `reached` listener and the show/hide logic.

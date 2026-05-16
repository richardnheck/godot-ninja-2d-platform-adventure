# CameraManager

**Category:** Object / Camera
**Scene:** `src/objects/camera/CameraManager.tscn`
**Script:** `src/objects/camera/CameraManager.gd` (`class_name CameraManager`)
**Extends:** `Node2D`

## Purpose
The player's smart-follow camera. Instanced as a child of the Player (`%CameraManager` unique name). Owns a `Camera2D` and applies two kinds of offset on top of follow:
- An **X-offset** that anticipates the player's direction of travel (auto-swing).
- A **Y-offset** that shifts the camera up or down based on level-authored intent.

## Assets
None (no sprites or SFX). Pure logic + Camera2D config.

## Scene structure
```
CameraManager (Node2D, script)
  Pivot (Position2D)                  -- script tweens this for x-offset
    CameraOffset (Position2D @ 48,-16)-- script tweens this for y-offset
      Camera2D (%Camera2D)            -- the actual camera
  YOffsetTween (Tween)
```
Camera2D defaults (from .tscn): limits ±1000, `limit_smoothed = true`, drag margins enabled (h 0.25 each, v top 0.3), `smoothing_enabled = true`, `smoothing_speed = 10`.

## Exported properties
None — all tuning is done via in-script constants:

| Constant | Value | Notes |
|----------|------:|-------|
| `HISTORY_SIZE` | 20 | Frames of player velocity history used to average direction. |
| `Y_OFFSET_UP` | -16.0 | Camera looks up (default). |
| `Y_OFFSET_DOWN` | 32.0 | Camera looks down (descending sections). |
| `Y_OFFSET_NONE` | 0.0 | Balanced. |
| `X_OFFSET_MEDIUM` | 48 | Lead distance in front of the player. |
| `X_OFFSET_NONE` | 0.0 | No lead (fixed). |
| `CAMERA_WEIGHT` | 1.4 | Lerp speed of x-offset adjustment. |
| `PLAYER_VELOCITY_THRESHOLD` | 100 | Avg \|vx\| needed to swing the x-offset. |
| `CAMERA_OFFSET_TWEEN_TIME` | 1.0 s | Y-offset tween duration. |
| `SMOOTHING_SPEED` | 10 | Restored after Y tween ends. |

## Behavior

### Modes
- `xOffsetMode.OFFSET_AUTO` — pivot.x is lerped between `+x_offset` (player facing right) and `-x_offset * 2` (player facing left) whenever the running average of `|player.velocity.x|` exceeds `PLAYER_VELOCITY_THRESHOLD`. Note the asymmetric multiplier — leftward swings further than rightward.
- `xOffsetMode.OFFSET_FIXED` — pivot.x is set once and never auto-adjusted (used by `set_x_offset_type(OFFSET_NONE)`).

### Y-offset transitions
- `set_y_offset_type(yOffsetType.UP|DOWN|NONE)` chooses a target offset.
- Disables `drag_margin_v_enabled` and lowers `smoothing_speed` to `5` to soften the sudden re-anchor.
- Tweens `CameraOffset.position` from current → new value over `CAMERA_OFFSET_TWEEN_TIME`.
- On `YOffsetTween.tween_completed`: restores `smoothing_speed = 10` and re-enables vertical drag margin.

### X-offset transitions
- `set_x_offset_type(OFFSET_MEDIUM)` re-enables auto-swing with full `X_OFFSET_MEDIUM` lead.
- `set_x_offset_type(OFFSET_NONE)` snaps both `pivot.x` and `camera_offset.position.x` to 0 and switches mode to FIXED.

### Velocity sampling
- `_get_player_velocity()` reads `player.get_current_state().velocity` (the FSM's current state holds the live velocity vector). Returns 0 if there is no current state.
- `_calculate_average_velocity()` arithmetic mean of `velocity_history` (a rolling window of size 20).

## Player interaction
Indirect — `CameraAdjustArea2D` zones call `set_*_offset_type()` / `reset_*_offset_type()` on this manager when the player enters/exits them.

## Public API used by other components
- `get_camera() -> Camera2D`
- `set_x_offset_type(type)` / `reset_x_offset_type()`
- `set_y_offset_type(type)` / `reset_y_offset_type()`
- enums `xOffsetType`, `yOffsetType`, `xOffsetMode`.

## Signals
None.

## Dependencies
- [player/player.md](../../player/player.md) — parent of this scene; `player.look_direction.x` and `player.get_current_state()` drive the offsets.
- [objects/camera/camera-adjust-area.md](camera-adjust-area.md) — the level-side trigger that calls the public API.

## Notes / TBD
- `set_y_offset_type` `match` includes `yOffsetType.NONE` which would be a typo for `OFFSET_NONE` (the enum only declares `OFFSET_UP`, `OFFSET_DOWN`, `OFFSET_NONE`) — TBD: in practice this falls through to the `_:` default, which still yields `Y_OFFSET_NONE`, so behaviour is unaffected.

# CameraAdjustArea2D

**Category:** Object / Camera
**Scene:** `src/objects/camera/CameraAdjustArea2D.tscn`
**Script:** `src/objects/camera/CameraAdjustArea2D.gd` (`class_name CameraAdjustArea`)
**Extends:** `Area2D`

## Purpose
A level-authored trigger zone that overrides the player's `CameraManager` x/y offsets while the player is inside. Used to anchor the camera during climbing sections, descending shafts, or stationary set-pieces.

## Assets
None.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `camera_adjust_type` | `CameraAdjustType` | `Y_OFFSET` | `X_OFFSET`, `Y_OFFSET`, or `X_AND_Y_OFFSET`. |
| `mode` | `Mode` | `SET_ON_ENTER_RESET_ON_EXIT` | Also `SET_ON_ENTER` (sticky), `RESET_ON_EXIT` (reset-only). |
| `trigger_enter_once` | bool | true | When true, only the first enter triggers a set. |
| `trigger_exit_once` | bool | false | When true, only the first exit triggers a reset. |
| `enter_edge` | `AreaEdge` | `UNKNOWN` | If not `UNKNOWN`, require the player to cross this specific edge to trigger enter (LEFT/RIGHT/TOP/BOTTOM). |
| `exit_edge` | `AreaEdge` | `UNKNOWN` | Same idea for exits. |
| `y_offset_on_enter` | `yOffsetOption` | `DOWN` | Translated to `CameraManager.yOffsetType.OFFSET_DOWN` or `OFFSET_UP`. |
| `x_offset_on_enter` | `xOffsetOption` | `MEDIUM` | `MEDIUM` (default lead) or `NONE` (kill auto-swing). |

## Behavior

### Edge detection
- `_ready()` computes the absolute world-space edges of the child `CollisionShape2D` (must be a `RectangleShape2D`).
- `_get_edge_crossed(body)` returns which edge the body is closest to within `edge_proximity_threshold = 40` px. Used to filter entries/exits when `enter_edge` or `exit_edge` is set.

### Enter (`_on_Area2D_body_entered`)
1. Reject non-player bodies (`Constants.GROUP_PLAYER`).
2. If `enter_edge != UNKNOWN` and the actual crossed edge differs, ignore.
3. If `trigger_enter_once && entered`, ignore.
4. If `mode` is `RESET_ON_EXIT`, ignore (this mode only resets, never sets).
5. If `mode == SET_ON_ENTER` and the player has already entered and exited once, ignore.
6. Otherwise resolve the player's `CameraManager` and call `set_y_offset_type` and/or `set_x_offset_type` per `camera_adjust_type`.

### Exit (`_on_Area2D_body_exited`)
1. Reject non-player bodies.
2. Edge filter via `exit_edge` (note: the script uses `enter_edge != UNKNOWN` as the gate, then compares against `exit_edge` — slightly odd condition but functional in practice).
3. If `trigger_exit_once && exitted`, ignore.
4. If `mode` is `SET_ON_ENTER` (sticky, no-reset), ignore.
5. Call `reset_y_offset_type` and/or `reset_x_offset_type` per `camera_adjust_type`.

### Camera resolution
`_get_camera_manager(body)` casts the body to `Player` and returns `player.get_camera_manager()`.

## Player interaction
Walk into the area → camera offset is set per the export. Walk out → it is reset (depending on mode). Player never knows it exists.

## Signals
None.

## Dependencies
- [objects/camera/camera-manager.md](camera-manager.md) — the target of every API call.
- [player/player.md](../../player/player.md) — `Player.get_camera_manager()`.
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.

## Notes / TBD
- Collision shape MUST be a `RectangleShape2D` — `_ready()` silently skips edge computation otherwise, which disables edge filtering.
- The exit edge filter checks `enter_edge != UNKNOWN` instead of `exit_edge != UNKNOWN` — likely a bug but consistent with current behaviour; preserve it during port.

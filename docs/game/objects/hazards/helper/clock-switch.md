# ClockSwitch

**Category:** Object / Interactive
**Scene:** `src/objects/clock-switch/ClockSwitch.tscn`
**Script:** `src/objects/clock-switch/ClockSwitch.gd` (`tool`, `class_name ClockSwitch`)
**Extends:** `Node2D`

## Purpose
A timed broadcaster used by World 2 levels: alternates between an "on" (active) and "off" (inactive) state on a duty cycle and emits the new state on a numeric channel. Listening objects (FireballSpinner, RotatingPlatform) with a matching `receiving_channel` show or hide accordingly. Tool-mode so the editor previews it.

## Assets
- Sprite: `src/objects/clock-switch/clock-switch.png` (single frame; hidden at runtime when `invisible` is true).
- SFX: none.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `sending_channel` | int (1..1000) | 1 | Broadcast channel. Drawn on `SendingChannelLabel` for editor preview. |
| `start_state` | bool | true | `true` → start active (on-timer runs first), `false` → start inactive (off-timer runs first). |
| `on_seconds` | float (0.5..10, step 0.5) | 1 | Duration of the active phase. |
| `off_seconds` | float (0.5..10, step 0.5) | 1 | Duration of the inactive phase. |
| `invisible` | bool | true | When true the sprite + channel label are hidden at runtime (still visible in editor). |

## Behavior
- Two one-shot Timers: `OnTimer`, `OffTimer`.
- `_ready()` sets their `wait_time` from the exports and starts whichever matches `start_state`.
- `OnTimer.timeout` → starts `OffTimer` and emits `switched(false)` (now inactive).
- `OffTimer.timeout` → starts `OnTimer` and emits `switched(true)` (now active).
- All setter functions call `update()` (Node2D redraw, used because the script is `tool`).
- In editor (`Engine.editor_hint`) the sprite is forced visible regardless of `invisible`.
- Belongs to group `switch` (set in the .tscn root).

## Player interaction
None — purely a timer/broadcaster. The player never collides with it.

## Signals
- `switched(active: bool)` — emitted on every phase change. Levels wire this to the listener objects that share the same channel (see Dependencies).

## Dependencies
- Listeners (subscribe in the level scene): [objects/hazards/fireball-spinner.md](../hazards/fireball-spinner.md), [objects/platforms/rotating-platform.md](../platforms/rotating-platform.md). Each has its own `receiving_channel` export and a `_on_ClockSwitch_switched(active)` handler.
- Used in: `src/levels/World2Levels/World2Level_Level3.tscn`, `Level4`, `Level5`, `Level6`.

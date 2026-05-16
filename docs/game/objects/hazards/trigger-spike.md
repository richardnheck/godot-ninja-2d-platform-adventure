# TriggerSpike

**Category:** Object / Hazard
**Scene:** `src/objects/trigger-spikes/TriggerSpike.tscn`
**Script:** `src/objects/trigger-spikes/TriggerSpike.gd`
**Extends:** `Area2D`

## Purpose
A pressure-pad spike: hidden by default, the player steps on the trigger pad, after a short delay the spike pops up for ~1 second, then retracts. Stepping on the pad again retriggers it.

## Assets
- Sprites: `TriggerSpikeBase.png` (the pad/block visual, always shown), `TriggerSpike.png` (the spike that toggles)
- SFX: `Game_AudioManager.sfx_env_trigger_spike_press` (initial press), `bamboo-spike.wav` (local `AudioStreamPlayer2D`, played on extend and on retract)

## Exported properties
None. Internal constants: `TRIGGER_DELAY = 0.7 s` (between pad press and spike appearing), `SPIKE_UPTIME = 1.0 s` (time spike stays up).

## Behavior
1. `_ready` calls `_show_spike(false)` — disables and hides the spike's `CollisionShape2D` via `set_deferred("disabled", true)` and `visible = false`.
2. Player enters `TriggerPadArea2D` (a thin 6×1 rect at the base) → `_trigger_trap()`:
   - Play `sfx_env_trigger_spike_press`.
   - Yield 0.7 s.
   - Play local SFX (extend).
   - `_show_spike(true)` — spike collision and sprite enabled.
   - Yield 1.0 s.
   - Play local SFX (retract).
   - `_show_spike(false)`.
3. Trap is re-armable — each new player entry into the pad area runs the sequence again. There is no debounce, so re-entering during the 1.7 s active window starts a second concurrent coroutine. TBD — likely harmless but worth a note.

## Player interaction
- `TriggerPadArea2D.body_entered` — arms the trap (no damage).
- Root `Area2D.body_entered` (CapsuleShape2D 7×2 above the pad, only enabled while spike is up) — calls `body.die()`.

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager`.
- Player — `die()` receiver.

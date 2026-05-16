# ElectricityBeam

**Category:** Object / Hazard
**Scene:** `src/objects/electricity/ElectricityBeam.tscn`
**Script:** `src/objects/electricity/ElectricityBeam.gd`
**Extends:** `Node2D`

## Purpose
A pulsing horizontal electric beam strung between two stone bases. Cycles on/off on configurable timers, plays a looped pulse SFX while active, and kills the player on contact during its on phase. Two visual lengths (32 px or 64 px) selected by export.

## Assets
- Sprite sheets:
  - `src/objects/electricity/ElectricityBeam32Sheet.png` (used when `length = 32`)
  - `src/objects/electricity/ElectricityBeam64Sheet.png` (used when `length = 64`)
  - `src/objects/electricity/ElectricityBeamBase.png` (stone-base sprites at each end)
- SFX: `Game_AudioManager.sfx_env_electricity_pulse` — **duplicated** onto the node in `_ready()` so the looping pulse plays per-instance.

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `length` | `int (32 or 64)` | `64` | Picks the matching `ElectricityAnimatedSprite32`/`64`, scales the collision shape (`collision_shape.scale.x = length / 64.0`), and shifts the base sprite positions to the ends. |
| `delay_time` | `float` | `0.0` | Seconds to wait after the beam first becomes visible before starting the on/off cycle. |
| `on_time` | `float` | `1.0` | Seconds the beam stays in the on phase per cycle (`OnTimer.wait_time`). |
| `off_time` | `float` | `1.0` | Seconds the beam stays in the off phase per cycle (`OffTimer.wait_time`). |
| `show_base_left` | `bool` | `true` | Show the left stone-base sprite. |
| `show_base_right` | `bool` | `true` | Show the right stone-base sprite. |

## Behavior
- `_ready()` duplicates the pulse SFX onto the node, hides `LeftMarkerLine2D` (editor placement marker), wires timer wait times, positions the two base sprites at `±(length/2 - 8)`, scales the collision shape by `length / 64`, picks the right AnimatedSprite for the chosen length, and starts disabled via `_enable(false)`.
- `_on_VisibilityNotifier2D_screen_entered()` → `_initialise()` — waits `delay_time` then calls `_enable(true)` and starts `OnTimer`. The `_initialised` flag prevents double-init.
- `OnTimer.timeout` → `_enable(false)` and start `OffTimer`.
- `OffTimer.timeout` → `_enable(true)` and start `OnTimer`.
- `_enable(bool)` toggles `ElectricityArea2D.visible`, `ElectricityArea2D.monitoring`, the matching `AnimatedSprite.playing`, and plays/stops `sfx_electricity_pulse`.

## Player interaction
On `ElectricityArea2D.body_entered`, if the body is in `Constants.GROUP_PLAYER`, the script calls `body.die()`. Because `monitoring` is disabled during the off phase, the beam only kills while pulsing.

## Signals
None emitted.

## Scene tree (referenced by the script)
- `OnTimer`, `OffTimer` — Timer nodes.
- `ElectricityArea2D` (Area2D)
  - `CollisionShape2D` (the hitbox)
  - `ElectricityAnimatedSprite32` (visible iff `length == 32`)
  - `ElectricityAnimatedSprite64` (visible iff `length == 64`)
- `BaseLeftSprite`, `BaseRightSprite` — the stone bases.
- `LeftMarkerLine2D` — editor-only placement helper, hidden at runtime.
- `VisibilityNotifier2D` — triggers `_initialise()`.

## Dependencies
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager.sfx_env_electricity_pulse`.
- [../../player/player.md](../../player/player.md) — receives `die()`.

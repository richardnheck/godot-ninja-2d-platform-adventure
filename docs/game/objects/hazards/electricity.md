# Electricity

**Category:** Object / Hazard
**Scene:** `src/objects/electricity/Electricity.tscn` (plus variants — see below)
**Script:** `src/objects/electricity/Electricity.gd` (`class_name Electricity`), `BlueFlame.gd` (`class_name BlueFlame`), `ElectricityBeam.gd`
**Extends:** `Node2D`

## Purpose
A family of always-on / pulsing damage zones that kill the player on contact. Four scene variants share a near-identical kill-on-`body_entered` behaviour; only `ElectricityBeam` has any state (on/off timing, base sprites, length).

## Variants
| Scene | Script | Hitbox | Distinguishing behaviour |
|-------|--------|-------:|--------------------------|
| `Electricity.tscn` | `Electricity.gd` | 4×32 vertical | Vertical electric column, 14-frame loop @ 10 fps. Always on. |
| `BlueFlame.tscn` | `BlueFlame.gd` | 25.5×2.5 horizontal | Thin horizontal blue flame, 11-frame loop @ 10 fps. Always on. |
| `MegamanElectricity.tscn` | `Electricity.gd` (reused) | 32×5 horizontal | Megaman-style horizontal beam, 4-frame loop @ 7 fps. Always on; in group `trap`; `VisibilityEnabler2D` pauses process when off-screen. |
| `ElectricityBeam.tscn` | `ElectricityBeam.gd` | 32×3 horizontal | Pulsing beam with two stone bases. Has on/off cycle, configurable length 32 or 64, optional initial delay. Plays `sfx_env_electricity_pulse` while on. |

## Assets
- Sprite sheets: `ElectricitySheet.png`, `BlueFlameSheet.png`, `MegamanStyleElectritySheet.png`, `ElectricityBeamSheet.png`, `ElectricityBeam32Sheet.png`, `ElectricityBeamBase.png`
- SFX (ElectricityBeam only): `Game_AudioManager.sfx_env_electricity_pulse` (duplicated onto the node so it can play while pulsing)

## Exported properties (ElectricityBeam only)
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `length` | int (32 or 64) | 64 | Picks the matching `ElectricityAnimatedSprite32`/`64` and scales the collision shape (`collision_shape.scale.x = length / 64.0`). |
| `delay_time` | float | 0.0 | Seconds to wait after first becoming visible before the on/off cycle starts. |
| `on_time` | float | 1.0 | Seconds the beam is active per cycle. |
| `off_time` | float | 1.0 | Seconds the beam is inactive per cycle. |
| `show_base_left` | bool | true | Show the left stone-base sprite. |
| `show_base_right` | bool | true | Show the right stone-base sprite. |

The simple `Electricity` / `BlueFlame` / `MegamanElectricity` variants expose no exports.

## Behavior
- **Static variants** (Electricity, BlueFlame, MegamanElectricity): `AnimatedSprite` plays a looped animation; `Area2D/CollisionShape2D` is permanently active.
- **ElectricityBeam**: starts disabled. On `VisibilityNotifier2D.screen_entered` calls `_initialise()`, waits `delay_time`, then begins the cycle. `OnTimer.timeout` -> `_enable(false)` + start `OffTimer`. `OffTimer.timeout` -> `_enable(true)` + start `OnTimer`. `_enable(enable)` toggles `Area2D.visible`, `Area2D.monitoring`, `AnimatedSprite.playing`, and the pulse SFX.
- The `LeftMarkerLine2D` in `ElectricityBeam.tscn` is hidden at runtime (editor placement marker only).

## Player interaction
On `Area2D.body_entered`, if the body is in `Constants.GROUP_PLAYER`, the script calls `body.die()`. For `ElectricityBeam` this only fires while the beam is in its on phase (Area2D monitoring is disabled during the off phase).

## Signals
None emitted.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`; `Game_AudioManager` (ElectricityBeam pulse SFX).
- Player — receiver of `die()`.

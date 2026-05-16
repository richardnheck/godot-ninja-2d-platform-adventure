# Objects — Category Overview

All objects live in `src/objects/**`. They are non-character scenes that the level world is built from: hazards, platforms, doors, interactives, decorations, and camera/FX helpers.

## Categories

| Category | Folder | Count | Defining trait |
|----------|--------|------:|----------------|
| Hazards | [hazards/](hazards/) | 11 | Kill the player on contact. Includes static electricity (`megaman-electricity.md` always-on, `electricity-beam.md` pulsing), spikes (falling/long-moving/bamboo/trigger), kinetic (spikey-rock, water-jump-yokai), rotating systems (fireball-spinner, rotating-onibi), and the World 2 Cannon turret (mis-spelled `Canon` in source). |
| Platforms | [platforms/](platforms/) | 7 | Surface the player can stand on. Includes static (conveyor belt), destructible (cloud, crumbling, falling), and moving (platform belt, rotating platform, moving platforms). |
| Interactive | [interactive/](interactive/) | 6 | Player triggers a response — Spring, HelpSign, ClockSwitch, Boat, Checkpoint, KamonKey. |
| Doors | [doors/](doors/) | 2 | Gates progression — CaveDoor (incl. DoorStart and DoorBackground) and CaveSlidingDoor. |
| Decoration | [decoration/](decoration/) | 1 file | Purely visual — `decorations.md` covers JapaneseLamp, World3 SmallLantern, WaterSplash. |
| Camera | [camera/](camera/) | 3 | CameraManager (smart follow), CameraAdjustArea2D (zone-based overrides), ScreenShake. |
| Tutorial | [tutorial/](tutorial/) | 1 | JumpDot (onboarding marker). |

## Common patterns

- **Trigger-then-act** — many hazards have an outer Area2D "trigger zone" + an inner "hit zone". The trigger zone arms the hazard, then the hit zone kills on contact.
- **Tweened motion** — moving spikes, springs, sliding doors, falling spikes use Godot's `Tween` node to animate position or modulation.
- **Tool-mode editor preview** — RotatingPlatform, FireballSpinner, ConveyorBelt and ClockSwitch are `tool` scripts so the editor previews them. The runtime behavior is the same.
- **Channel system** — ClockSwitch broadcasts on a `sending_channel` (1–1000); FireballSpinner and RotatingPlatform listen on `receiving_channel` to show/hide.
- **Game_AudioManager** — every audible object plays SFX through this singleton (e.g. `sfx_env_spring_boing`, `sfx_env_cave_sliding_door`).

## Gem, DemonSeal, Coin

These three `src/objects/*.tscn` files are NOT documented here:
- `Coin` is unused in any shipping level.
- `Gem` and `DemonSeal` only appear during cutscenes — documented in [ui/cutscenes/cutscene-items.md](../ui/cutscenes/cutscene-items.md).
- `KamonKey` IS gameplay-interactive — documented in [interactive/kamon-key.md](interactive/kamon-key.md).

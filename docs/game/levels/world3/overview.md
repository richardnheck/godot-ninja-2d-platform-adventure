# World 3 Overview

**Category:** Level / World 3
**Folder:** `src/levels/World3Levels/`
**Theme:** Inside the Tower

The climax world. Levels are vertical and horizontal traversals through the interior of the castle keep (tenshu). Difficulty peaks here: every enemy type from earlier worlds returns, hazards stack densely (`MegamanElectricity` walls, `TriggerSpike` fields, `LongMovingSpike` arrays), and platforming combines conveyors, falling platforms, springs, rotating platforms, and `PlatformBelt`s. Most levels carry two or three checkpoints to keep retries fair.

## Level list

From `LevelData.levelsArray` (indices 14–20, see [../../systems/autoloads.md#LevelData](../../systems/autoloads.md)):

| # | Index | Display name | Scene |
|---|-------|--------------|-------|
| 1 | 14 | Taste the Tenshu | [level-1.md](level-1.md) |
| 2 | 15 | Obake Kaidan | [level-2.md](level-2.md) |
| 3 | 16 | Master my Mushin | [level-3.md](level-3.md) |
| 4 | 17 | Heya, heya and heya | [level-4.md](level-4.md) |
| 5 | 18 | No yuka...no cry | [level-5.md](level-5.md) |
| 6 | 19 | Saigo no nobori | [level-6.md](level-6.md) |
| Boss | 20 | Stage3 Boss (Ao Andon) | [boss-level.md](boss-level.md) |

## BGM

- Levels 1–6: `Bgm_World3LevelTheme` (`world3 level theme song.ogg`).
- Boss: `Bgm_World3LevelBossTheme` (`world3 boss theme song.ogg`), with `Bgm_World3BossOutro` on clear. Played explicitly in `World3Level_Boss.gd` via `Game_AudioManager.play_bgm_world3_level_boss()`.

See [../../systems/autoloads.md#Game_AudioManager](../../systems/autoloads.md) for the full BGM table.

## Tilesets used

See [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md) for atlases, autotile, collision shapes.

- `World3-Floor-Wall-Roof-Tileset.tres` — visible floor/wall/roof art in every level.
- `World3-Background-Tileset.tres` — `TileMapBg` interior wall pattern.
- `World3-Props-Tileset.tres` — decorative props (Level 5, Level 6, Boss).
- `CaveLevelTileset.tres` — owned by every (hidden) `TileMapWorld` for collision (see [overview](../tilemaps/overview.md#visible-vs-collidable-split-world-2--3)).
- `sky-tileset.tres` (shared with World 2) — `TileMapSky` in Levels 1–4.

## Mechanics (climax difficulty)

- **Multi-section layout.** Each `.tscn` splits gameplay into `Section1`…`Section5` child `Node2D`s, each owning its own `TileMapWorld` + `TileMapTraps` + `enemies/`/`traps/`/`platforms/` groups. `LevelBase` finds trap tilemaps by group, not by walking the tree.
- **Stacked hazard families.** Levels combine `TriggerSpike`, `LongMovingSpike`, `MegamanElectricity` (wall pulses), `ElectricityBeam` (continuous arcs), and `RotatingOnibi`.
- **Composite platforming.** Conveyors, `PlatformBelt`s, falling platforms, rotating platforms, springs and `MovingPlatformCave1H`/`2H` are routinely chained together to form single traversal puzzles.
- **Boss arena uses `BossPhaseTransitionArea2D`.** Two such areas push `AoAndon` to its next phase when the player crosses them — see [boss-level.md](boss-level.md).
- **Door / Key.** Levels 1–5 use the standard `KamonKey` + `Door` pair. Level 6 swaps `Door` for `CaveLevelSlidingDoor`. The Boss level has neither — it ends on `EndArea` body_entered (see `World3Level_Boss.gd`).

## Cutscenes

- Intro: `res://src/UI/CutScenes/World3/BossintroCutScene.tscn` (`scene_path` for the boss row).
- Clear: `res://src/UI/CutScenes/World3/BossClearCutScenePart1.tscn` (`boss_clear_scene_path`).

Both are covered in [../../ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) / `boss-clear-cutscenes.md`.

## Dependencies

- [../level-base.md](../level-base.md) — every level inherits this script.
- [../tilemaps/overview.md](../tilemaps/overview.md) and [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md).
- [../../systems/autoloads.md](../../systems/autoloads.md) — LevelData, Game_AudioManager.
- [../../enemies/_category-overview.md](../../enemies/_category-overview.md) — every enemy in World 3.
- [../../objects/_category-overview.md](../../objects/_category-overview.md) — hazards/platforms/interactives.

# World 1 - Cave (Beneath the Castle)

**Category:** Level / World 1 (Cave)
**Folder:** `src/levels/CaveLevels/`

The first of the game's three worlds. Six gameplay levels plus a boss arena, set in the cavern system beneath the castle keep. World 1 is also the tutorial world — onboarding panels in Level 1 introduce mobile/keyboard controls, jumping, wall sliding, and key-finding.

## Theme

"Beneath the castle". Dark cavern, stalactites overhead, stalagmites underfoot, japanese-lamp lighting, large brick fill behind the playable area. Every level shares the same palette and prop set (lamps, stalactites, stalagmites) so the world reads as a continuous space.

## BGM

| Where | AudioStreamPlayer node | Source |
|-------|------------------------|--------|
| Levels 1–6 | `Bgm_CaveLevelTheme` | `cave level theme song.ogg` |
| Boss | `Bgm_CaveLevelBossTheme` (with `Bgm_CaveLevelBossIntro` + `Bgm_CaveLevelBossOutro` stingers) | `cave boss theme.ogg` |

Levels are wired through `LevelData.CAVE_LEVEL_BGM` ([../systems/autoloads.md#LevelData](../../systems/autoloads.md)); the boss BGM is kicked off directly by `World1Level_Boss.gd` via `Game_AudioManager.play_bgm_cave_level_boss()`.

## Tilesets used

All three World 1 tilesets are documented in [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md):

- `CaveLevelTileset.tres` — drives `TileMapWorld` and `TileMapTraps` in every level.
- `CaveLevelBackgroundTileset.tres` — drives `TileMapBg` (cave-brick fill + the autotile background variant).
- `CaveLevelTilesetNoCollisions.tres` — non-collidable decorative variant used in Level 1's `TileMapWorldBg`.

Standalone PNGs (`stalectite.png`, `round-stalecmite.png`, the moving-platform body + track textures) are also used as plain `Sprite` decorations behind/inside the levels.

## Mechanics introduced

World 1 layers in a new platforming technique roughly each level:

| Level | New mechanic / theme |
|-------|----------------------|
| 1 — Time to learn young gakusei | On-screen tutorial panels (mobile + keyboard controls, double jump, wall jump, wall slide, avoid yokai, find key). No traps yet — the level is a TutorialPanels-driven gauntlet of jump-dot trails. |
| 2 — Jump did you say? Sensei? | First "real" jumps over hazards; introduces an enemy gauntlet (Ashimigarari × 2, RedCreepyCrawly). |
| 3 — Unstable ishi | Crumbling platforms (× ~20) plus horizontal moving cave platforms; falling spikes. |
| 4 — Kabe sliding all the way | Wall slide / wall jump shafts; vertical and horizontal moving platforms; first OneEyedSpikey + CreepyCrawly placements. |
| 5 — Shiver me shi | Death from above — falling spikes everywhere (× 10), moving bamboo spikes (× 9), spikey rocks. |
| 6 — Deadly dokutsu | Final pre-boss level; introduces the CaveLevelMiniBoss (× 3) jumper enemy and the sliding-door exit. |
| Boss — Stage1 Boss | CaveLevelBoss (Stone Yokai) — multi-state arena with falling-spike phase trigger. |

## Level list (from `LevelData.levelsArray`)

Indexes 0–6 of `LevelData.levelsArray`:

| Index | Display name | Scene |
|-----:|---------------------------------|-------|
| 0 | "Time to learn young gakusei" | [level-1.md](level-1.md) |
| 1 | "Jump did you say? Sensei?" | [level-2.md](level-2.md) |
| 2 | "Unstable ishi" | [level-3.md](level-3.md) |
| 3 | "Kabe sliding all the way" | [level-4.md](level-4.md) |
| 4 | "Shiver me shi" | [level-5.md](level-5.md) |
| 5 | "Deadly dokutsu" | [level-6.md](level-6.md) |
| 6 | "Stage1 Boss" | [boss-level.md](boss-level.md) |

Note: `LevelData.gd` keeps a `# Had to reduce number of levels down to 6 to make game finishable` comment block listing four older cave levels (`AcrossTheAbyss`, `ShortAndSpikey`, `CrabAppleCrumble`, `ClaustrophicCaverns1`) that were trimmed from shipping. Their `.tscn` files may still exist under `src/levels/CaveLevels/` but are not reachable through normal progression.

## Boss-level routing

The "Stage1 Boss" entry in `LevelData` does not point at the boss scene directly — its `scene_path` is `src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn`. The intro cutscene then loads `World1Level_Boss.tscn`, and on clear `World1Level_Boss.gd::_on_EndArea_body_entered` calls `LevelData.goto_boss_clear_cutscene(LevelData.WORLD1, true)` which jumps to `BossClearCutScene.tscn`. See [../level-base.md](../level-base.md) for the boss-clear flow shared with worlds 2 and 3.

## Dependencies

- [../level-base.md](../level-base.md) — every level inherits LevelBase.
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md) — tileset details.
- [../tilemaps/overview.md](../tilemaps/overview.md) — TileMap layer naming.
- [../../systems/autoloads.md](../../systems/autoloads.md) — `LevelData`, `Game_AudioManager`.
- [../../enemies/bosses/cave-level-boss.md](../../enemies/bosses/cave-level-boss.md), [../../enemies/jumpers/cave-level-mini-boss.md](../../enemies/jumpers/cave-level-mini-boss.md) — boss enemies referenced from the cave levels.

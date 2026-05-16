# Stage 1 Boss

**Category:** Level / World 1 (Cave) / Boss
**Scene:** `src/levels/CaveLevels/World1Level_Boss.tscn`
**Script:** `src/levels/CaveLevels/World1Level_Boss.gd` (extends `LevelBase`)
**Root node:** `World1 Boss`

## Display name & BGM

"Stage1 Boss" / `Bgm_CaveLevelBossTheme`.

`LevelData.levelsArray[6]`. The boss-row `scene_path` actually points at the intro cutscene (`res://src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn`); the intro then loads this scene. On clear, `_on_EndArea_body_entered` calls `LevelData.goto_boss_clear_cutscene(LevelData.WORLD1, true)` which navigates to `BossClearCutScene.tscn`.

BGM is started directly from `World1Level_Boss.gd::_ready()` via `Game_AudioManager.play_bgm_cave_level_boss()` (which sequences `Bgm_CaveLevelBossIntro` → `Bgm_CaveLevelBossTheme`).

## Tilesets used

- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — driver for `TileMapWorld`, `TileMapInvisibleFrame`, `TileMapBossWorld`, `TileMapBossFallingSpikesWorld`, `TileMapTraps`.
- `assets/art/tilesets/cave-level/CaveLevelBackgroundTileset.tres` — `TileMapBg`.

See [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers

- `TileMapBg` — cave-brick background.
- `TileMapWorld` — main collidable arena geometry.
- `TileMapInvisibleFrame` — hidden collision sealing the arena edges.
- `TileMapBossWorld` — boss-only collision swap-in (kept `visible = false` until the boss enters its slam phase).
- `TileMapBossFallingSpikesWorld` — separate hidden tilemap activated during the falling-spike phase.
- `TileMapTraps` — hazard tiles (group `["trap"]`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| CaveLevelBoss (Stone Yokai) | 1 (`Boss`) | [cave-level-boss](../../enemies/bosses/cave-level-boss.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| CrumblingPlatform | 7 (`CrumblingPlatform`, `…2`–`…7`) | [crumbling-platform](../../objects/platforms/crumbling-platform.md) |
| MovingBambooSpike | 4 (`MovingBambooSpike`, `…2`, `…6`, `…7`) | [moving-bamboo-spike](../../objects/hazards/moving-bamboo-spike.md) |
| JapaneseLamp | 22 | [decorations](../../objects/decoration/decorations.md) |
| EndArea (Area2D) | 1 | — |
| FallingSpikesArea (Area2D) | 1 | — |
| CeilingPosition2D | 1 | — |

## Checkpoints

- None placed by default. `LevelBase._ready()` checks `Settings.boss_level_checkpoints_enabled` for boss levels; if checkpoints are disabled the boss must be re-fought from full on every retry.

## Notes

- Custom `World1Level_Boss.gd` extends `LevelBase` with boss-specific wiring:
  - On `_ready()`: passes `player` to the boss, sets the boss's ceiling position from `CeilingPosition2D`, and connects the boss's `state_cycle_finished` signal.
  - Hosts a `FallingSpikesArea` Area2D — when the player enters it, queues `next_boss_state = "updown_slam"`; on exit, queues `"run_and_jump"`. The next state is committed at the end of the current boss cycle (avoids cutting attack animations).
  - Overrides `_on_EndArea_body_entered` to call the inherited `_handle_boss_level_complete()` (no auto-advance) and then `LevelData.goto_boss_clear_cutscene(LevelData.WORLD1, true)`.
- Loads `src/utility/Geometry2D.gd` as a tooling script (ExtResource id 8) — used by the boss for line-of-sight math.
- The hidden `TileMapBossWorld` and `TileMapBossFallingSpikesWorld` are toggled by the boss script when phase-specific obstacles appear in the arena. See [overview.md](../tilemaps/overview.md#layer-pattern) for the boss-only tilemap pattern.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../tilemaps/overview.md](../tilemaps/overview.md)
- [../../enemies/bosses/cave-level-boss.md](../../enemies/bosses/cave-level-boss.md)
- [../../objects/platforms/crumbling-platform.md](../../objects/platforms/crumbling-platform.md)
- [../../objects/hazards/moving-bamboo-spike.md](../../objects/hazards/moving-bamboo-spike.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../systems/autoloads.md](../../systems/autoloads.md) — `LevelData`, `Game_AudioManager`, `Constants.GROUP_PLAYER`.

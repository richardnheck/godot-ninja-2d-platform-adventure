# World 3 Boss — Ao Andon

**Category:** Level / World 3 / Boss
**Scene:** `src/levels/World3Levels/World3Level_Boss.tscn`
**Script:** `src/levels/World3Levels/World3Level_Boss.gd`
**Inherits:** LevelBase

## Display name & BGM
"Stage3 Boss" (LevelData row, index 20) / `Bgm_World3LevelBossTheme`

The boss BGM is played explicitly in `_ready()` via `Game_AudioManager.play_bgm_world3_level_boss()` (overriding the default LevelBase BGM lookup). On boss-clear, the clear cutscene plays `Bgm_World3BossOutro`.

## Tilesets used
- `World3-Floor-Wall-Roof-Tileset.tres` — visible walls/roof.
- `World3-Background-Tileset.tres` — `TileMapBg`.
- `World3-Props-Tileset.tres` — props.
- `CaveLevelTileset.tres` — hidden `TileMapWorld` collision.
- Standalone art: `sashimono.png`, `banners.png`, `hata-jirushi.png`, `pane.png`, `cave-platform-track-80.png`.

## TileMap layers
- Root: `TileMapWorld`, `TileMapBg`, `TileMapTraps` (group `trap`).
- `Section1`–`Section3` each have `TileMapWorld` + `TileMapTraps` (group `trap`).
- `Section3` adds `TileMapProps` for decorative tower-top props.

## Boss
- **AoAndon** — instanced once at the root (`ExtResource( 21 )`). The boss is a multi-phase Path2D-driven yokai with a `PathFollow2D` whose `unit_offset` is set by `World3Level_Boss.gd` based on the active checkpoint (see [../../enemies/bosses/ao-andon.md](../../enemies/bosses/ao-andon.md)).
- Path resource: `aoandon_path.tres` (Curve2D, ext_resource id 26).
- The boss is handed `player` and a `CeilingPosition2D` reference at `_ready()`. `set_spawn_offset(...)` places the boss appropriately for the current checkpoint:
  - No checkpoint → `0.006` (just on-screen at level start).
  - Checkpoint id `"1"` → `0.45`.
  - Checkpoint id `"2"` → `0.7118`.

## Boss phase transitions
- **`BossPhaseTransitionArea2D`** — two Area2D instances are placed under the root, each running `BossPhaseTransitionArea2D.gd`. When the player enters one, the script grabs sibling `AoAndon` and calls `boss.goto_next_phase()`, then locks itself (`triggered = true`) so the same area can't fire twice.
- Two areas mean two phase pushes (phase 1 → 2 → 3, etc.), positioned at specific arena thresholds.

## Enemies placed (in addition to the boss)

| Enemy | Count | Doc |
|-------|-------|-----|
| KasaObake | 2 | [../../enemies/jumpers/kasa-obake.md](../../enemies/jumpers/kasa-obake.md) |
| TofuKozo | 1 | [../../enemies/throwers/tofu-kozo.md](../../enemies/throwers/tofu-kozo.md) |
| Daruma | 1 | [../../enemies/jumpers/daruma.md](../../enemies/jumpers/daruma.md) |
| Bakezori | 2 | [../../enemies/path-follow/bakezori.md](../../enemies/path-follow/bakezori.md) |
| Hannya | 1 | [../../enemies/patrol/hannya.md](../../enemies/patrol/hannya.md) |
| ChochinObake | 3 | [../../enemies/path-follow/chochin-obake.md](../../enemies/path-follow/chochin-obake.md) |
| ChochinObakeShooter | 1 | [../../enemies/path-follow/chochin-obake-shooter.md](../../enemies/path-follow/chochin-obake-shooter.md) |
| LaserLantern | 1 | [../../enemies/path-follow/laser-lantern.md](../../enemies/path-follow/laser-lantern.md) |
| RotatingOnibi | 1 | [../../objects/hazards/rotating-onibi.md](../../objects/hazards/rotating-onibi.md) |

## Objects placed

| Object | Count | Doc |
|--------|-------|-----|
| MegamanElectricity | 23 | [../../objects/hazards/megaman-electricity.md](../../objects/hazards/megaman-electricity.md) |
| TriggerSpike | 24 | [../../objects/hazards/trigger-spike.md](../../objects/hazards/trigger-spike.md) |
| LongMovingSpike | 11 | [../../objects/hazards/long-moving-spike.md](../../objects/hazards/long-moving-spike.md) |
| ElectricityBeam | 1 | [../../objects/hazards/electricity-beam.md](../../objects/hazards/electricity-beam.md) |
| FallingPlatform | 8 | [../../objects/platforms/falling-platform.md](../../objects/platforms/falling-platform.md) |
| ConveyorBelt | 4 | [../../objects/platforms/conveyor-belt.md](../../objects/platforms/conveyor-belt.md) |
| PlatformBelt | 2 | [../../objects/platforms/platform-belt.md](../../objects/platforms/platform-belt.md) |
| RotatingPlatform | 4 | [../../objects/platforms/rotating-platform.md](../../objects/platforms/rotating-platform.md) |
| MovingPlatformCave1H | 2 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| MovingPlatformCave2H | 2 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| Spring | 1 | [../../objects/interactive/spring.md](../../objects/interactive/spring.md) |
| SmallLantern | 22 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 3 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |

No `KamonKey` and no `Door` — boss levels skip the key/door progression. The level exit is an `EndArea` Area2D under `InteractiveProps/`.

## Checkpoints
- 2 — `CheckPoint` and `CheckPoint2`. The boss restoring its `unit_offset` based on `LevelData.level_checkpoint_reached` (`"1"` or `"2"`, see `World3Level_Boss.gd`) keeps the boss aligned with the player on reload. The checkpoint instances themselves come from `ExtResource( 35 )` (note: a *different* CheckPoint ext id than Levels 1–6, which use `ExtResource( 14 )`).

## Completion flow
1. Player crosses `EndArea` → `_on_EndArea_body_entered(body)` (overrides `LevelBase`'s default end-area handler).
2. `_handle_boss_level_complete()` (from LevelBase) does standard analytics + completion routing.
3. `Analytics.track_game_completions()` + `track_event_game_completed()` are then called — finishing this boss = finishing the game.
4. `Analytics.add_game_leaderboard_entry(total_completion_time, total_deaths)` posts the final leaderboard entry.
5. `LevelData.goto_boss_clear_cutscene(LevelData.WORLD3, true)` triggers `BossClearCutScenePart1.tscn`.

## Notes
- Sections 1 and 3 do the heavy lifting — Section 1 is enemy + spike intro corridor, Section 3 is the climactic arena with `MovingPlatformCave1H`, multiple `RotatingPlatform`s, and the densest electricity grid (14 `MegamanElectricity` in `Section3/traps/Node2D4`).
- Section 2 is a vertical transition arena (`MovingPlatformCave2H` x2, single `LongMovingSpike`).
- The boss is a `PathFollow2D` follower — it doesn't physics-collide with the level geometry, so platform layouts can run beneath/through its path.
- Two checkpoint placements are unusually well-spaced for a final boss; this was added to make the fight more recoverable (matches the recent changelog entry "added a second checkpoint to final boss to make easier").

## Dependencies
- [../level-base.md](../level-base.md) — base behavior (this scene overrides `_on_EndArea_body_entered`).
- [overview.md](overview.md) — World 3 overview.
- [../tilemaps/world3-tilesets.md](../tilemaps/world3-tilesets.md) — tileset detail.
- [../../enemies/bosses/ao-andon.md](../../enemies/bosses/ao-andon.md) — the boss itself.
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Analytics`, `LevelData`, `GameState`.
- [../../ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) and `boss-clear-cutscenes.md` — sandwiching narrative.

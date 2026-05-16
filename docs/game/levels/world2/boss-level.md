# World 2 Boss Level — Wanyudo

**Category:** Level / World 2 / Boss
**Scene:** `src/levels/World2Levels/World2Level_Boss.tscn`
**Script:** `src/levels/World2Levels/World2Level_Boss.gd` (extends `LevelBase`)
**Boss:** Wanyudo — see [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md).

## Display name & BGM
"Stage2 Boss" (display from `LevelData`) / `Bgm_World2LevelBossTheme`.

Unlike non-boss levels, BGM is played explicitly by `World2Level_Boss.gd` via `Game_AudioManager.play_bgm_world2_level_boss()` in `_ready()` — it does not go through the `play_bgm_by_node_name(LevelData.get_level_bgm(scene_path))` path used by levels 1–6.

## Tilesets used
- `assets/art/tilesets/world2/world2-tileset.tres` — `TileMapTraps`.
- `assets/art/tilesets/world2/sky-tileset.tres` — `TileMapSky`.
- `assets/art/tilesets/world2/roof-wall-tileset.tres` — `TileMapWallsRoof`.
- `assets/art/tilesets/world2/bricks_tileset.tres` — `TileMapBricks`.
- `assets/art/tilesets/world2/wooden-slats-tileset.tres` — `TileMapWoodenSlats`.
- `assets/art/tilesets/world2/stone-ground-tileset.tres` — `TileMapWorldStone`.
- `assets/art/tilesets/world2/stone-bricks-tileset/tileset_stone-bricks-tileset.tres` — `TileMapWorldStonesInAir`.

Plus standalone art: `pylon.png` and `sashimono.png` placed as free `Sprite` props.

See [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).

## TileMap layers
- `TileMapSky`
- `TileMapWallsRoof`
- `TileMapWallColumns` — unique to the boss arena; vertical column tiles using `roof-wall-tileset.tres`.
- `TileMapBricks`
- `TileMapWoodenSlats`
- `TileMapWorldStone`
- `TileMapWorldStonesInAir`
- `TileMapWorld` — hidden collision.
- `TileMapTraps` (group `trap`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| Wanyudo (boss) | 1 | [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) |
| Hyakume | 8 | [../../enemies/path-follow/hyakume.md](../../enemies/path-follow/hyakume.md) |
| FireBallSpinner | 4 | [../../objects/hazards/fireball-spinner.md](../../objects/hazards/fireball-spinner.md) |
| TsurubeOtoshi | 2 | [../../enemies/jumpers/tsurube-otoshi.md](../../enemies/jumpers/tsurube-otoshi.md) |
| Zugaikotsu | 2 | [../../enemies/path-follow/zugaikotsu.md](../../enemies/path-follow/zugaikotsu.md) |
| Canon | 2 | [../../objects/test/guns.md](../../objects/test/guns.md) |
| Shirime | 1 | [../../enemies/patrol/shirime.md](../../enemies/patrol/shirime.md) |
| ClockSwitch | 1 | [../../objects/interactive/clock-switch.md](../../objects/interactive/clock-switch.md) |

Wanyudo is parented directly under the root (`[node name="Wanyudo" parent="."]`), not under `Enemies/`, because the script references it as `$Wanyudo`.

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| CloudPlatform | 6 | [../../objects/platforms/cloud-platform.md](../../objects/platforms/cloud-platform.md) |
| MovingPlatformCave2H | 2 | [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md) |
| BossPhaseTransitionArea2D | 1 (+1 disabled) | (this file) |
| CameraAdjustArea2D | 1 | [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md) |
| DoorStart | 1 | [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md) |
| CaveDoorBackground | 1 | [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md) |
| MobileControlsHUD | 1 | [../level-base.md](../level-base.md) |
| EndArea (Area2D, inline) | 1 | (see Notes) |
| EndTimer (Timer, inline) | 1 | (see Notes) |
| CeilingPosition2D | 1 | (see Notes) |

A second transition area (`TEMP-TransitionArea2`) is present in the tree but is `monitoring = false` — it's a disabled second trigger left in the scene.

## Checkpoints

- 1 `CheckPoint` instance under `InteractiveProps/` — the only mid-fight checkpoint. The boss script reads `spawned_at_checkpoint` (inherited from `LevelBase`) to detect respawn from this checkpoint.

## Boss phase transition (`BossPhaseTransitionArea2D.gd`)

The arena is large enough that the boss has two distinct phases. The phase-2 transition is driven by the player walking into an `Area2D` rather than by the boss tracking HP:

1. `BossPhaseTransitionArea2D` is an `Area2D` with `collision_layer = 0` placed at a specific arena location (`position = Vector2(3216, 32)` in this scene) with a wide rectangular collision shape.
2. The Area2D's `body_entered` signal is connected to its own `_on_body_entered(body)` method.
3. When the body that enters is in `Constants.GROUP_PLAYER` and the area has not yet `triggered`:
   - It walks up to its parent (the level root) and gets `Wanyudo` via `get_parent().get_node("Wanyudo")`.
   - If the boss has a `goto_next_phase` method, it calls `boss.goto_next_phase()` and sets `triggered = true` so it fires exactly once.
4. `Wanyudo.goto_next_phase()` (see [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md)) swaps the boss from `STATE_PHASE1` (path-following chaser with homing fireballs) to `STATE_PHASE2` (stationary, drops falling WanyudoMinis from `CeilingPosition2D`), emits `phase_changed`, and clears stray homing fireballs via `HomingFireballSpawner.force_destroy`.

The same script is reused by the World 3 boss level under `World3Levels/` (per [../level-base.md](../level-base.md)).

## Boss level wiring (`World2Level_Boss.gd`)

- Caches `boss := $Wanyudo` and `ceiling_position := $CeilingPosition2D` as onready vars.
- In `_ready()`:
  - `boss.set_player(player)` — the boss needs the player reference for both phases.
  - `boss.set_ceiling_position(ceiling_position)` — anchors the phase-2 WanyudoMini drops to the arena ceiling.
  - Calls `Game_AudioManager.play_bgm_world2_level_boss()`.
  - **Checkpoint respawn behavior:** if `spawned_at_checkpoint` (set by `LevelBase` when the player respawned at the mid-level checkpoint after dying), waits one frame (`yield(get_tree().create_timer(0), "timeout")`) and then calls `boss.set_spawn_offset(0.44)`. This shifts the boss's `PathFollow2D` `unit_offset` so it spawns "just behind the player" in phase 1 — a manually-tuned magic number. Without it the boss would start at offset 0 and be off-screen on the respawn.
- `_on_EndArea_body_entered(body)` overrides the LevelBase end-area handler:
  - On player contact with `EndArea`, calls the inherited `._handle_boss_level_complete()` (super-call) and then `LevelData.goto_boss_clear_cutscene(LevelData.WORLD2, true)` to change to the boss-clear cutscene.

## Notes

- `play_bgm_world2_level_boss()` is the only BGM call — the level skips the `play_bgm_by_node_name` path entirely.
- The `EndArea` Area2D + `EndTimer` Timer are inline scene nodes (not instanced scenes); LevelBase wires the `body_entered` / `timeout` signals.
- `CeilingPosition2D` is just a Node2D / Position2D anchor used by `Wanyudo.set_ceiling_position`.
- The cave-themed art (DoorStart, CaveDoorBackground) is still used here because LevelBase relies on a `Props/DoorStart` and the World 2 door art is not its own scene.
- The `TileMapBlockHole` / `TileMapInvisibleFrame` edge-sealing layers are NOT present in this scene — the arena is bounded by `TileMapWorld` directly.

## Dependencies

- [../level-base.md](../level-base.md) — base class; `spawned_at_checkpoint`, `_handle_boss_level_complete()`, the trap-tilemap + camera-limits wiring.
- [../../enemies/bosses/wanyudo.md](../../enemies/bosses/wanyudo.md) — boss states, `goto_next_phase()`, `set_player`, `set_ceiling_position`, `set_spawn_offset`, WanyudoMini spawner.
- [overview.md](overview.md), [../tilemaps/world2-tilesets.md](../tilemaps/world2-tilesets.md).
- [../../ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md), [../../ui/cutscenes/boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md) — pre- and post-boss cutscenes navigated to from `LevelData`.
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager.play_bgm_world2_level_boss()`, `LevelData.goto_boss_clear_cutscene`.
- Enemy/object docs linked in the tables above.

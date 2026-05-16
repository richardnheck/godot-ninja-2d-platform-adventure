# AoAndon

**Category:** Enemy / Boss
**Scene:** `src/characters/enemies/AoAndon/AoAndon.tscn`
**Script:** `src/characters/enemies/AoAndon/AoAndon.gd` (`class_name AoAndon`)
**Extends:** `PathFollowEnemyBase` (see [path-follow/path-follow-base.md](../path-follow/path-follow-base.md))

## Purpose
The World 2 boss: a giant blue lantern-yokai that drifts along a Path2D launching homing shard-lanterns at the player in phase 1, then rains falling shard-lanterns from the ceiling directly above the player in phase 2.

## Assets
- Boss body spritesheet: `AoAndonSheet.png` (8f looping at 8 fps — gentle idle hover)
- Face overlay: `AoAndonFaceSheet.png` (two frames — `default`, `shoot` — child of `AnimatedSprite`)
- Shoot effect: `shard-lantern/ShootLanternEffectSheet.png` (4f@10fps, plays at the mouth on each homing shot)
- Reference image: `AoAndonRefernce.png`
- Blue fireball: `BlueFireballSheet.png` (4f looping at 10 fps)
- Path resource: `aoandon_path.tres`
- SFX (via `Game_AudioManager`): `sfx_env_aoandon_lantern_shoot` (used by spawned shard lanterns), `sfx_env_lantern_shard_hit` (used by shards on impact), `sfx_env_crumbling_platform_explode` (re-used by shard explosion)

## Exported / overridden properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `speed` (inherited) | float | overridden to `65` in `_ready()` | Pixels/sec along Path2D |
| `tween_transition_type` | enum | `TRANS_LINEAR` | Constant speed |
| `follow_path_type` | enum | `ONCE` | Stops at end of path |
| `oscillation_amplitude` | float | `5` | Vertical bob amplitude |
| `oscillation_frequency` | float | `10` | Vertical bob frequency |
| `SHOOT_DELAY` | const float | `1.0` s | Pause between a lantern's destruction and the next shot |
| `LanternSpawnTimer.wait_time` | float | `5.0` s | Interval between phase-2 lantern array drops |
| `HomingShardLanternSpawner.bullet_scene` | PackedScene | `AoAndonShardLantern.tscn` | (Gun export, scene-level) |
| `NormalFireballSpawner.bullet_scene` | PackedScene | `NormalBlueFireball.tscn` | (Gun export, scene-level) |

## Behavior

Two-phase, identical structural pattern to [Wanyudo](wanyudo.md). State is a string (`STATE_PHASE1`, `STATE_PHASE2_TRANSITION`, `STATE_PHASE2`). Transitions are triggered by the boss level calling `goto_next_phase()`.

### Phase 1 — `STATE_PHASE1` (chase + homing shard lanterns)
- AoAndon tweens along the `Path2D` at 65 px/s with `ONCE` follow type.
- `_ready()` waits 0.5 s then calls `_shoot_lantern()`.
- `_check_position()` (called every frame from the inherited `_process`):
  - If `player.position.x < boss_pos - 5` → boss has overshot the player → `stop_following_path()`, disable `HomingShardLanternSpawner`, enable `NormalFireballSpawner`, face flips to the `shoot` animation. Player-cleanup mode: a rapid stream of straight blue fireballs fires until the player catches up.
  - If `player.position.x > boss_pos + 100` → re-enable homing spawner, disable normal, face back to `default`, resume tween from cached `current_offset`, wait 1 s, `_shoot_lantern()`.
- `_shoot_lantern()`:
  - On path: animates `face_animated_sprite` to `shoot`, plays the `ShootEffectAnimatedSprite` from frame 0, calls `homing_shard_lantern_spawner.shoot()`, yields 0.3 s, restores face to `default`.
  - Off path: face stays on `shoot`, `normal_fireball_spawner.shoot()` runs in `TIMED` mode.
- Re-fire is driven by `HomingShardLanternSpawner.lantern_destroyed` → `_on_lantern_destroyed()` → wait `SHOOT_DELAY` (1 s) → `_shoot_lantern()`.

### Phase 2 transition — `STATE_PHASE2_TRANSITION`
- Both spawners disabled.
- `phase_changed` emitted; `HomingShardLanternSpawner._on_phase_changed` emits `force_destroy`, calling `force_die()` on every live homing shard lantern so stray phase-1 shots cannot kill the player.
- Immediately falls through into phase 2 in the same call.

### Phase 2 — `STATE_PHASE2` (falling shard-lantern bombardment)
- Boss stops moving (the `STATE_PHASE2` arm of `_physics_process` is a `pass`).
- `LanternSpawnTimer` (5 s) drives repeated `_spawn_lantern_array()` calls; one array is also spawned on entry.
- `_spawn_lantern_array()`:
  - Instances `LanternArray.tscn`, places it at `(boss.global_position.x ± distance_to_player + rand_range(-10, 15), ceiling_position.global_position.y)` — roughly above the player on the ceiling Position2D supplied by the boss level.
  - Three `LanternSpawner` children spawn `FallingShardLantern` rigid bodies that fall onto the player; the front-of-player one always fires first (`delay_time = 0`), the other two stagger by `rand_range(0.3, 1.3)` s.

## Player interaction
- Body contact with AoAndon kills the player (inherited Area2D body-entered).
- Any homing or normal blue fireball / falling lantern / shard kills the player on contact.
- AoAndon is not killable by the player; the boss level ends the fight via a checkpoint or boss-clear cutscene.

## Signals
- `phase_changed(phase)` — emitted in `goto_next_phase()`. `HomingShardLanternSpawner._on_phase_changed` listens and force-destroys live homing lanterns.

## Public API
- `set_player(player_ref)` — forwards the target to both spawners.
- `set_spawn_offset(offset)` — begins path-following at a normalised offset.
- `set_ceiling_position(pos)` — caches the `Position2D` used as Y for the falling-lantern arrays.
- `goto_next_phase()` — kicks off the phase-2 transition.

## Scene structure (key nodes)
`AoAndon` (root, groups `boss`, `enemy`) → `Path2D`, `Tween`, `OscillationTween`, `Area2D` (layer 16, mask 33; `HomingShardLanternSpawner`, `NormalFireballSpawner`, `CollisionShape2D` capsule r≈19.5 / h≈44, `AnimatedSprite` body with `FaceAnimatedSprite` + `ShootEffectAnimatedSprite` children), `VisibilityNotifier2D` (freed in `_ready`), `LanternSpawnTimer`.

---

### Inline projectile: NormalBlueFireball
**Scene:** `src/characters/enemies/AoAndon/NormalBlueFireball.tscn`
**Script:** `src/characters/enemies/AoAndon/NormalBlueFireball.gd` (`class_name NormalBlueFireball`, extends `Area2D`)

- Sprite: `BlueFireballSheet.png` (4f looping at 10 fps, 32×32).
- Exported `speed = 180`. `fire(target)` samples `target.position` plus an x-offset proportional to the player's current horizontal velocity (`target.get_node('StateMachine').current_state.velocity`) so the shot leads the player.
- `_process` (not `_physics_process`) moves the projectile linearly along the captured direction.
- `LifeTimer` timeout and `VisibilityNotifier2D.screen_exited` both call `_explode()`.
- Explosion uses the shared `enemy-death-*` frames at 20 fps then `queue_free`.
- `_on_body_entered`: if body is in `GROUP_PLAYER` → `body.die()`. Emits `destroyed` on explosion end.
- Collision layer 128.

### Inline projectile: AoAndonShardLantern (homing variant)
**Scene:** `src/characters/enemies/AoAndon/shard-lantern/AoAndonShardLantern.tscn`
**Script:** `src/characters/enemies/AoAndon/shard-lantern/AoAndonShardLantern.gd` (`class_name AoAndonShardLantern`, extends `Node2D`)

- Sprite: `AoAndonShardLanternSheet.png` (2f looping at 5 fps).
- Explosion sprite: shared `enemy-death-*` frames at 20 fps.
- Exports: `speed = 180`, `shoot_direction` (UP/DOWN/LEFT/RIGHT enum, default `LEFT`), `spread = 45` degrees, `bullet_scene` (default `shard/AoAndonShard.tscn`), `steer_force = 20.0`. Internal `can_seek = true`.
- Duplicates and adds `Game_AudioManager.sfx_env_aoandon_lantern_shoot` for its detonation sound.
- Homing model in `_physics_process` matches `HomingFireball`: lerps `position.y` toward `target.position.y` (follow_speed=1 × delta) and adds `position.x += 3` each frame. The computed `seek()` steering is dead code. Once `position.x > target.position.x` and seeking → `can_seek = false`, starts `LifeTimer`.
- On `LifeTimer` timeout → `_shoot()` then `_explode()`. `_shoot()` fires three `AoAndonShard` bullets in a spread around `direction` (centre, +`spread/2`, −`spread/2`).
- `force_die()` is called by the spawner's `force_destroy` during phase transition — immediately runs `_explode()` so stray homing lanterns can't kill the player after phase 2 begins.
- `_on_body_entered` (Area2D child) kills the player on touch but does not explode the lantern automatically (it continues until LifeTimer / force_die).
- Emits `destroyed` when the duplicated SFX finishes.
- `Area2D` is on collision layer 8 (boss projectile).

### Inline projectile: AoAndonShard
**Scene:** `src/characters/enemies/AoAndon/shard-lantern/shard/AoAndonShard.tscn`
**Script:** `src/characters/enemies/AoAndon/shard-lantern/shard/AoAndonShard.gd` (`class_name AoAndonShard`, extends `Area2D`)

- Sprite: `AoAndonShardSheet.png` (rotates with `direction.angle()`).
- Explosion: `AoAndonShardExplosionSheet.png` plays on `_explode()`.
- Exported `speed = 150`. `direction` setter rotates the sprite to face travel direction.
- Owns duplicated `sfx_env_lantern_shard_hit`.
- Linear motion in `_physics_process` along `direction.normalized() * speed`.
- `_on_HitZone_body_entered`: if body is `GROUP_PLAYER` → `body.die()`, then `_explode()` (plays shard-hit SFX + `crumbling_platform_explode` SFX + explosion anim, `queue_free` on anim end).
- `_on_Shard_body_entered`: explodes when colliding with a `TileMap`.
- `_on_VisibilityNotifier2D_screen_exited` → `queue_free`.

### Inline projectile: FallingShardLantern
**Scene:** `src/characters/enemies/AoAndon/shard-lantern/FallingShardLantern.tscn`
**Script:** `src/characters/enemies/AoAndon/shard-lantern/FallingShardLantern.gd` (`class_name FallingShardLantern`, extends `RigidBody2D`)

- Sprite: `path-follow-enemy/shard-lantern/ShardLanternSheet.png` (2f loop, shared with the standard ShardLantern enemy).
- Explosion: `shard-lantern/LanternExplosionSheet.png` (12f@20fps).
- Exports: `spread = 75` degrees (overridden to `120` by `LanternSpawner._spawn`), `bullet_scene` (default `AoAndonShard.tscn`), `shoot_rate = 2`, `delay_time = 0`. Public `lifetime` is set by the spawner; when > 0 the lantern auto-explodes after that many seconds.
- Gravity scale 2 — it falls fast from the ceiling.
- Owns duplicated `sfx_env_aoandon_lantern_shoot`.
- `_explode()`: zeros `linear_velocity`, sets gravity to 0, disables collision, stops the lifetime timer, plays the explosion anim, plays SFX, then `_shoot()` fires three `AoAndonShard`s upward in a `spread + rand_range(-10, 10)` cone (`shoot_direction = Vector2.UP`).
- `_on_Area2D_body_entered`: kills the player on contact; if it hits a `GROUP_TRAP` body, explodes early.
- `_on_Area2D_area_entered`: explodes on entering a `GROUP_TRAP` area.
- `queue_free`s when the explosion animation finishes.
- Collision: body layer 4 (boss falling object), mask 7 (world + traps + player).

### Inline spawner: HomingShardLanternSpawner / NormalFireballSpawner
**Scenes:** `src/characters/enemies/AoAndon/HomingShardLanternSpawner.tscn`, `NormalFireballSpawner.tscn`
**Scripts:** `HomingShardLanternSpawner.gd` (extends `Gun`), `NormalFireballSpawner.gd` (`class_name NormalFireballSpawner`, extends `Gun`).

- `HomingShardLanternSpawner` — manual-fire (`shoot()` called by the boss). After each `_shoot` it sets `shard_lantern.rotation = 0` (upright), forwards `homing` into `can_seek`, and connects `destroyed` for chained refire. Emits `lantern_destroyed` (chain trigger) and `force_destroy` on phase change.
- `NormalFireballSpawner` — `_set_enabled` re-triggers a shot when flipped on while idle; in TIMED mode the parent `Gun` keeps firing automatically. Each spawned bullet has its rotation zeroed and emits `lantern_destroyed` on explosion (note: signal name preserved from copy-paste; the bullet is actually a fireball, not a lantern).

### Inline spawner: LanternSpawner
**Scene:** `src/characters/enemies/AoAndon/LanternSpawner.tscn`
**Script:** `src/characters/enemies/AoAndon/LanternSpawner.gd` (`class_name LanternSpawner`, extends `Node2D`)

- Holds a `ShootPosition`, `DelayTimer`, `AnimatedSprite` (Spawn animation).
- Exports: `lantern_lifetime = 3.0`, `object_scene` (set to `FallingShardLantern.tscn` at the array level), `delay_time`, `direction`.
- `set_ready()` plays the `Spawn` animation and either fires immediately or waits `delay_time`.
- `_spawn()` instantiates a `FallingShardLantern` under the `Projectiles` autoload at `_shoot_position.global_position`, sets `lifetime` and `spread = 120`, then emits `spawned_object`.
- A `LaserLanternSpawner.gd` sibling file targeting `LaserLantern` scenes also lives in the folder but is not used by the current `LanternArray` — TBD: legacy from an earlier "laser lantern" phase-2 design.

### Inline spawner array: LanternArray
**Scene:** `src/characters/enemies/AoAndon/LanternArray.tscn`
**Script:** `src/characters/enemies/AoAndon/LanternArray.gd` (`class_name LanternArray`)

- Three `LanternSpawner` children spaced at x = `-112, 0, +112` (the centre one is the "above the player" lantern).
- `_ready` randomises delay timings: spawner 1 (front of player) `delay_time = 0`, spawners 2/3 `rand_range(0.3, 1.3)` s, then calls `set_ready()` on each. After `init_delay` it also calls `trigger()` (currently a no-op — each spawner self-fires via its own DelayTimer).
- `WidthMeasurement` is a `RectangleShape2D` of half-extents `(112, 4.17)` exposed by `get_width()`.
- Counts `spawned_object` signals from each child; once all three have fired, the array `queue_free`s itself.
- The boss spawns one of these every 5 s during phase 2 (and once on entry), positioned with random x-jitter directly above the player on the ceiling Y.

## Dependencies
- [path-follow/path-follow-base.md](../path-follow/path-follow-base.md) — base class providing the `Path2D` / `PathFollow2D` / `Tween` rig and `_check_position`.
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Projectiles`, `Constants`.
- [systems/frameworks.md](../../systems/frameworks.md) — `Gun` base class for the two spawners.
- World 2 boss level scene (TBD path) — owner that calls `set_player`, `set_ceiling_position`, `goto_next_phase`.
- [ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) / [boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md) — bracket the fight.
- Shares the shard-lantern sprite sheet with the standard `ShardLantern` path-follow enemy ([path-follow/shard-lantern.md](../path-follow/shard-lantern.md)).

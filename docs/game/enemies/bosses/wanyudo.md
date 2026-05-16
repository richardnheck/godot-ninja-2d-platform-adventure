# Wanyudo

**Category:** Enemy / Boss
**Scene:** `src/characters/enemies/Wanyudo/Wanyudo.tscn`
**Script:** `src/characters/enemies/Wanyudo/Wanyudo.gd`
**Extends:** `PathFollowEnemyBase` (see [path-follow/path-follow-base.md](../path-follow/path-follow-base.md))

## Purpose
The World 1 boss: a flaming oxcart-wheel yokai that chases the player along a Path2D while flinging homing fireballs, then transitions to a stationary second phase where it carpet-bombs the arena with falling mini-Wanyudos.

## Assets
- Boss spritesheet: `WanyudoSheet.png` (3 frames: default wheel face, mid-bite, mouth-open)
- Wheel flame loop: `WanyudoFlames.tres` (8 `AnimatedSprite` children arranged in a ring around the body)
- Boss appear / explosion sheets: `BossAppearFlash.png`, `BigExplosionSheet.png`, `bigexplosion_spriteframes.tres` (used by intro/clear cutscenes)
- Path resource: `wanyudo_path.tres`
- SFX (via `Game_AudioManager`): `sfx_env_mini_wanyudo_spawn`, `sfx_env_mini_wanyudo_explosion` (owned by spawned minis)

## Exported / overridden properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `speed` (inherited) | float | overridden to `65` in `_ready()` | Pixels/sec along the Path2D |
| `tween_transition_type` | enum | `TRANS_LINEAR` | Constant pace, no easing |
| `follow_path_type` | enum | `ONCE` | Stops at end of path |
| `oscillation_amplitude` | float | `5` | Vertical bob amplitude |
| `oscillation_frequency` | float | `10` | Vertical bob frequency |
| `MiniWanyudoSpawnTimer.wait_time` | float | `5.0` s | Interval between falling-mini arrays in phase 2 |
| `HomingFireballSpawner.shoot_rate` | float | `3.0` s | (scene-level) |
| `HomingFireballSpawner.impulse` | int | `500` | |
| `HomingFireballSpawner.mode` | enum | `NORMAL` (0) | Parent calls `shoot()` manually |
| `NormalFireballSpawner.shoot_rate` | float | `0.3` s | (scene-level) |
| `NormalFireballSpawner.mode` | enum | `TIMED` (1) | Auto-fires while `enabled` |
| `NormalFireballSpawner.spread_angle` | float | `10.0` | |
| `NormalFireballSpawner.impulse` | int | `100` | |

## Behavior

Two-phase state machine driven by the `state` string (`STATE_PHASE1`, `STATE_PHASE2_TRANSITION`, `STATE_PHASE2`). Transitions are triggered externally by the boss level calling `goto_next_phase()` (typically when a checkpoint or HP threshold fires).

### Phase 1 — `STATE_PHASE1` (chase + homing fireballs)
- Boss tweens along `Path2D` at 65 px/s with `ONCE` follow type.
- `_ready()` waits 0.3 s then calls `_shoot_fireball()`.
- `_check_position()` runs every frame:
  - If the player is more than `5 px` behind the boss → `stop_following_path()`, disable `HomingFireballSpawner`, enable `NormalFireballSpawner` (rapid spread shots) so the player who has fallen behind gets cleaned up. Sprite stays on `default`.
  - If the player is more than `100 px` ahead of the boss → re-enable homing spawner, disable normal spawner, resume the path tween from the cached `current_offset`, wait 1 s, then `_shoot_fireball()`.
- `_shoot_fireball()` picks animation + spawner by `following_path`:
  - On path: `set_sprite_animation("homing-shoot")`, `homing_fireball_spawner.shoot()`.
  - Off path: `set_sprite_animation("normal-shoot")`, `normal_fireball_spawner.shoot()`.
- The next homing shot is queued by `HomingFireballSpawner.fireball_destroyed` → `_on_fireball_destroyed()` → `_shoot_fireball()`.

### Phase 2 transition — `STATE_PHASE2_TRANSITION`
- Both spawners disabled.
- `phase_changed` is emitted; `HomingFireballSpawner._on_phase_changed()` fires `force_destroy`, which calls `force_die()` on every still-airborne homing fireball so stray shots from phase 1 cannot kill the player after the transition.
- Immediately falls through to phase 2 in the same call (no real dwell).

### Phase 2 — `STATE_PHASE2` (falling mini-Wanyudo bombardment)
- Boss is stationary (no path movement; `_physics_process` match arm is empty).
- `MiniWanyudoSpawnTimer` (5 s) repeatedly calls `_spawn_falling_mini_wanyudo_array()`.
- One array is also spawned immediately on entry.
- Each spawn places a `FallingMiniWanyudoArray` at `(boss.global_position.x ± distance_to_player, ceiling_position.global_position.y)` — i.e. roughly above the player, on the ceiling Position2D the boss level passes in via `set_ceiling_position()`.

## Player interaction
- Direct contact with the wheel kills the player (the `Area2D` body-entered path inherited from `PathFollowEnemyBase`).
- Any active fireball / mini-Wanyudo / shard that touches the player calls `player.die()`.
- Wanyudo is not killed by the player; the boss level fades it out via a checkpoint / boss-clear cutscene (mirrors the CaveLevelBoss pattern — see [cave-level-boss.md](cave-level-boss.md)).

## Signals
- `phase_changed(phase)` — emitted in `goto_next_phase()`. `HomingFireballSpawner._on_phase_changed` listens and force-destroys live homing fireballs.

## Public API
- `set_player(player_ref)` — forwards the target to both spawners (`set_target`).
- `set_spawn_offset(offset)` — begins path-following at a normalised offset.
- `set_ceiling_position(pos)` — caches the `Position2D` used as Y for the falling-mini arrays.
- `goto_next_phase()` — kicks off the phase-2 transition.

## Scene structure (key nodes)
`Wanyudo` (root, groups `boss`, `enemy`) → `Path2D`, `Tween`, `OscillationTween`, `Area2D` (layer 16, mask 33; `HomingFireballSpawner`, `NormalFireballSpawner`, `CollisionShape2D` capsule r≈29.5, `AnimatedSprite`, `Flames` ring), `VisibilityNotifier2D` (freed in `_ready`), `MiniWanyudoSpawnTimer`.

---

### Inline projectile: NormalFireball
**Scene:** `src/characters/enemies/Wanyudo/NormalFireball.tscn`
**Script:** `src/characters/enemies/Wanyudo/NormalFireball.gd` (`class_name NormalFireball`, extends `Area2D`)

- Sprite: `NormalFireBalSpriteSheet.png` (4f looping at 10 fps)
- Explosion uses the shared `assets/art/sprites/enemy-death/enemy-death-1..6.png` frames (20 fps, one-shot via `_explode()`).
- Exported `speed = 180`. On `fire(target)` it samples the player position plus an x-offset proportional to the player's current horizontal velocity (read from `target.get_node('StateMachine').current_state.velocity`) so it leads the shot.
- Moves linearly along `direction` in `_physics_process`. Re-samples `player_speed` each frame (lerped to 0) but the captured `direction` is not re-aimed — it is fire-and-forget.
- `LifeTimer` timeout → `_explode()`. `_on_VisibilityNotifier2D_screen_exited` also explodes off-screen.
- `_on_body_entered`: if body is in `Constants.GROUP_PLAYER` → `body.die()`, stop physics, explode.
- Emits `destroyed` on explosion end, then `queue_free`.
- Collision layer 128, no mask (player-only contact via `body_entered` group check).

### Inline projectile: HomingFireball
**Scene:** `src/characters/enemies/Wanyudo/HomingFireball.tscn`
**Script:** `src/characters/enemies/Wanyudo/HomingFireball.gd` (`class_name HomingFireball`, extends `Area2D`)

- Sprite: `HomingFireBallSpriteSheet.png` (4f looping at 10 fps, 16×30 frame).
- Exported `speed = 180`, `steer_force = 20.0`. Internal `can_seek = true`.
- Homing model: in `_physics_process` it lerps `position.y` toward `target.position.y` at `delta * follow_speed` (follow_speed=1) and advances `position.x += 3` per frame. (The `seek()` steering function is computed but the resulting `acceleration` is not integrated — TBD: dead code from an earlier attempt; effective behaviour is the lerp + constant x.)
- Once `position.x > target.position.x` while seeking, sets `can_seek = false` and starts `LifeTimer`. After timeout → `_explode()`.
- `force_die()` is called by the spawner's `force_destroy` signal during phase transitions to clear stray shots without waiting for the lifetime.
- `_on_body_entered`: kills the player on contact, then explodes.
- Emits `destroyed` on explosion end. Collision layer 128.

### Inline spawner: HomingFireballSpawner / NormalFireballSpawner
**Scenes:** `src/characters/enemies/Wanyudo/HomingFireballSpawner.tscn`, `NormalFireballSpawner.tscn`
**Scripts:** `HomingFireballSpawner.gd`, `NormalFireballSpawner.gd`
**Extends:** `Gun` (`src/objects/test-objects/Guns/Gun.gd`) — exports `bullet_scene`, `shoot_rate`, `mode`, `spread_angle`, `direction`, `impulse`, `requires_target`.

- `HomingFireballSpawner` — manual-fire (parent calls `shoot()`), emits `fireball_destroyed` when a child fireball explodes (used to chain the next shot), and `force_destroy` on phase change to clear live fireballs. `homing` flag is forwarded to each spawned fireball's `can_seek`.
- `NormalFireballSpawner` — `_set_enabled` re-triggers a shot whenever flipped on while its internal `_shoot_timer` is stopped; `mode=TIMED` means the parent `Gun._on_ShootTimer_timeout` keeps firing automatically. Emits `on_shoot` so the boss can flip its mouth-open animation.

### Inline spawned minion: WanyudoMini
**Scene:** `src/characters/enemies/wanyudo-mini/WanyudoMini.tscn`
**Script:** `src/characters/enemies/wanyudo-mini/WanyudoMini.gd` (`class_name WanyudoMini`, extends `RigidBody2D`)

- Sprites: `wanyudo-min-wheel.png` (idle wheel, 32×32), `wanyudo-mini-Sheet.png` (flash, 2f), `WanyudoFlames.tres` (flame ring), plus a 26-frame explosion built from `src/objects/test-objects/Guns/Canon/big_100x100px.png`.
- Exported `lifetime = 3.0` s (overridden to `0.8` s by the `FallingMiniWanyudoArray` spawners).
- Group `killable-enemy`. Collision layer 128, mask 2 (world). Gravity scale 2, mass ≈2.04, `bounce = 0.7` (set in `_ready`).
- Lifecycle: on spawn, starts `LifetimeTimer`. On timeout → `_start_flashing()` (plays `flash` animation, starts `FlashTimer`). When `FlashTimer` fires → `_do_death()`: plays a duplicated `sfx_env_mini_wanyudo_explosion`, hides the wheel + flames, plays the 26-frame explosion sprite, and `queue_free`s on animation end.
- The `BodyCollideArea2D` Area2D kills the player on touch (`die()`).
- `set_impulse(value)` applies a central impulse along `direction` — used by the spawner to launch the mini downward/outward.
- `_process` keeps the flame sprite world-upright by counter-rotating the body's spin.
- `WanyudoMiniKillArea` (`wanyudo-mini/WanyudoMiniKillArea.gd/.tscn`) is a small helper Area2D used in level geometry: any body in `GROUP_KILLABLE_ENEMY` that enters it gets `die()` called. Used to clean up minis that fall into pits.

### Inline spawner: WanyudoMiniSpawner
**Scene:** `src/characters/enemies/wanyudo-mini/WanyudoMiniSpawner.tscn`
**Script:** `src/characters/enemies/wanyudo-mini/WanyudoMiniSpawner.gd` (`class_name WanyudoMiniSpawner`, extends `Node2D`)

- Sprites: `wanyudo-mini-spawner-sheet.png` (Idle 6f@7fps, Spawn 12f@15fps).
- Exports: `wanyudo_mini_lifetime` (3 s default, 0.8 s in the boss array), `idle_after_shoot` (true by default, false in the boss array — single-shot), `bullet_scene`, `shoot_rate`, `delay_time`, `direction`, `impulse` (370 default, 50 in the boss array).
- `_ready`: plays `Idle`, then either fires immediately or starts the delay timer.
- `_shoot()`: plays `Spawn`, yields 0.5 s, plays duplicated `sfx_env_mini_wanyudo_spawn`, instantiates the mini under the `Projectiles` autoload, applies `direction` + `impulse`, and emits `spawned_object`. If `idle_after_shoot` is true the spawner returns to Idle; otherwise it stops there (one-shot bombardment behaviour for the boss array).
- `_physics_process` rotates the spawner node to match `direction.angle()` so the spawn animation points the right way.

### Inline spawner array: FallingMiniWanyudoArray
**Scene:** `src/characters/enemies/Wanyudo/FallingMiniWanyudoArray.tscn`
**Script:** `src/characters/enemies/Wanyudo/FallingMiniWanyudoArray.gd` (`class_name FallingMiniWanyudoArray`)

- Three `WanyudoMiniSpawner` instances spaced at x = `-112, 0, +112` with directions `(0.3, 1)`, `(0, 1)`, `(-0.3, 1)` and delay_times `0.8 / 0.5 / 0.3` s. All use `wanyudo_mini_lifetime = 0.8`, `shoot_rate = 5.0`, `impulse = 50`, `idle_after_shoot = false`.
- `WidthMeasurement` is a `RectangleShape2D` of half-extents `(112, 4.17)` used by `get_width()` so the boss can size offsets.
- `init_delay` export defers the trigger after instancing.
- Counts `spawned_object` signals from the three children; once all three have fired, the array `queue_free`s itself.
- `trigger()` is currently a no-op — the spawners self-trigger via their own delay_time.
- The boss spawns one of these every 5 s during phase 2 (and once on phase entry), placed at the ceiling Y above the player.

## Dependencies
- [path-follow/path-follow-base.md](../path-follow/path-follow-base.md) — base class providing the `Path2D` / `PathFollow2D` / `Tween` rig and `_check_position`.
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Projectiles`, `Constants`.
- [systems/frameworks.md](../../systems/frameworks.md) — `Gun` base class used by the two fireball spawners.
- World 1 boss level scene (TBD path) — owner that calls `set_player`, `set_ceiling_position`, `goto_next_phase`.
- [ui/cutscenes/boss-intro-cutscenes.md](../../ui/cutscenes/boss-intro-cutscenes.md) / [boss-clear-cutscenes.md](../../ui/cutscenes/boss-clear-cutscenes.md) — bracket the fight.

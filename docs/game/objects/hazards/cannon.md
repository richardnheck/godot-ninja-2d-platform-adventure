# Cannon

**Category:** Object / Hazard
**Scene:** `src/objects/test-objects/Guns/Canon/Canon.tscn` (the scene name `Canon` is mis-spelled in the source — the in-game object is a cannon)
**Script:** `src/objects/test-objects/Guns/Canon/Canon.gd` — `extends Gun` (script base `src/objects/test-objects/Guns/Gun.gd`, `class_name Gun`)
**Extends:** `Gun` → `Node2D`

## Purpose
Stationary directional cannon turret that fires `Canonball` projectiles on a timer. Used widely across World 2 (Levels 2, 3, 4, 6, and Boss) to wall off corridors and pressure platforming sections. Despite living in the source tree under `test-objects/Guns/`, the Cannon is the only shipping shooting *hazard* — the other weapons in that folder (Pistol, MachineGun, GrenadeLauncher) are unused and not documented.

The underlying `Gun.gd` base script is reused (without being a shooting hazard) by two other components:
- the [WaterJumpYokaiSpawner](../../enemies/jumpers/water-jump-yokai.md) — uses `Gun` as a timer-driven spawner for the leaping fish projectile.
- the Wanyudo boss [HomingFireballSpawner / NormalFireballSpawner](../../enemies/bosses/wanyudo.md) — boss-internal projectile launchers.

The base-script behaviour documented below applies to all three consumers; only the Cannon needs animation, SFX, and a solid body.

## Assets
- Cannon sprite sheet: `src/objects/test-objects/Guns/Canon/canon-Sheet.png` (3 frames; `default` 1-frame, `shoot` 4-frame at 10 fps).
- Muzzle blast: `src/objects/test-objects/Guns/Canon/directional2_100x100px.png` (5 frames, 20 fps, scaled 0.6× and rotated 45°).
- Projectile: `Canonball` (`Canon/CanonBall.tscn`) — Area2D using `Bullets/AreaBullet.gd`.
- Canon ball texture: `Canon/canonball.png` (1-frame sprite).
- Explosion atlas: `Canon/bk_explo_one.png` (15-frame at 10 fps, scaled 0.5×, played at `speed_scale = 5`).
- SFX:
  - `Game_AudioManager.sfx_env_canon_shoot` — duplicated onto the cannon in `_ready()` per instance.
  - `Game_AudioManager.sfx_env_canon_ball_explosion` — duplicated onto each canonball in `AreaBullet._ready()`.

## Exported properties

Inherited from `Gun.gd` (the base script — all editable per-instance in the scene):

| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `bullet_scene` | `PackedScene` | — | The projectile to instance per shot. Set to `Canon/CanonBall.tscn` for the cannon. |
| `shoot_rate` | `float` | `0.25` | Seconds between shots (`ShootTimer.wait_time`). |
| `delay_time` | `float` | `0.0` | Initial delay before the first shot (`DelayTimer.wait_time`, TIMED mode only). |
| `mode` | `enum {NORMAL, AUTOMATIC, CHARGE, TIMED}` | `NORMAL` | Cannon instances set this to `TIMED` in their level scenes. |
| `max_charge_time` | `float` | `2.0` | Unused for cannons (CHARGE mode only). |
| `spread_angle` | `float` | `0.0` | Currently unused by `Gun.gd`. |
| `direction` | `Vector2` | `Vector2.RIGHT` | Bullet fly direction; the cannon also rotates itself so its barrel faces this way (`rotation = Vector2(abs(direction.x), direction.y).angle()`). |
| `impulse` | `int` | `370` | Forwarded to the bullet's `impulse` if defined. AreaBullet ignores it (uses `speed` instead). |
| `requires_target` | `bool` | `false` | If true, the gun waits for `set_target()` before `_initialize()`. Cannons leave this false. |

## Behavior

### Gun base lifecycle (`Gun.gd`)
- `_ready()`: if `requires_target == false`, calls `_initialize()`.
- `_initialize()`:
  - In `TIMED` mode, sets `ShootTimer.wait_time = shoot_rate`, then either `_shoot()` immediately (if `delay_time == 0`) or starts `DelayTimer` first.
  - In other modes just primes `ShootTimer`.
  - Calls `randomize()` once.
- `_physics_process(delta)`:
  - Rotates `self` to face `direction` every frame.
  - `TIMED`: does nothing here — firing is driven by `ShootTimer.timeout` → `_shoot()`.
  - `AUTOMATIC`: shoots while `Input.is_action_pressed("shoot")` (not used in shipping).
  - `CHARGE`: holds while `shoot` is pressed (`charge_time` ramps to `max_charge_time`), fires on release.
  - `NORMAL`: dormant (manual shoot path is commented out).
- `_shoot()`:
  1. Arms `ShootTimer`.
  2. Instances `bullet_scene`, sets `bullet.direction = direction`.
  3. `Projectiles.add_child(bullet)` — adds under the [Projectiles autoload](../../systems/autoloads.md) (the pooled container).
  4. Sets `bullet.global_position = ShootPosition.global_position`.
  5. If the bullet has `charge` / `impulse` properties, forwards them.
  6. Resets `charge_time = 0.0`.
  7. If the bullet has a `fire(target)` method, calls it.
  8. Returns the bullet.
- `_on_ShootTimer_timeout()` (TIMED) → `_shoot()`.
- `_on_DelayTimer_timeout()` → `_shoot()`.

### Cannon overrides (`Canon.gd`)
- `_ready()`: hides the blast sprite, duplicates `sfx_env_canon_shoot` onto self. A hack rotates the sprite 180° if `direction == Vector2(-1, 0)` (the generic `_sprite.rotate(direction.angle())` does not work — script comment).
- `_shoot()`: calls `._shoot()` (base) to fire the canonball. **Only if** `VisibilityNotifier2D.is_on_screen()`, plays the shoot SFX and animates the cannon (`AnimatedSprite.play("shoot")`) and muzzle blast (`CanonBlastAnimatedSprite.play()`). The bullet itself still fires off-screen (timers must keep advancing).
- `_on_AnimatedSprite_animation_finished()` returns the cannon sprite to `default`.
- `_on_CanonBlastAnimatedSprite_animation_finished()` hides the blast.

### Canonball projectile (`AreaBullet.gd`, `class_name AreaBullet`, extends `Area2D`)
- Exports `speed` (default `3500`; the Canonball scene overrides to `100`).
- `_ready()` duplicates `sfx_env_canon_ball_explosion`, grabs `ExplosionAnimatedSprite`, calls `set_as_toplevel(true)` so motion is in world space, connects `body_entered → hit_body`.
- `_physics_process(delta)` translates by `speed * delta * direction.normalized()` while not exploding.
- `set_direction(new_direction)` (setget) also rotates the bullet to face its motion.
- `hit_body(body)` — if `body.has_method("die")`, calls `body.die()`; then `_destroy()` → plays explosion SFX, disables collision, hides the ball sprite, plays `ExplosionAnimatedSprite`. `_on_ExplosionAnimatedSprite_animation_finished()` (and the duplicate `_on_ExplosionAnimatedSprite2_animation_finished()`) call `queue_free()`.

## Scene tree (`Canon.tscn`)
- `Canon` (Node2D, script `Canon.gd`)
  - `VisibilityNotifier2D` — gates SFX/animation
  - `ShootPosition` (Position2D) — local-space muzzle
  - `ShootTimer` (Timer, one_shot)
  - `DelayTimer` (Timer, one_shot)
  - `AnimatedSprite` (z_index 4) with `default` + `shoot` animations
    - `CanonBlastAnimatedSprite` — muzzle flash (positioned at `(2, 1)`, rotated `0.785398 ≈ 45°`, scale 0.6)
  - `StaticBody2D` (collision_layer 4)
    - `CollisionShape2D` — `RectangleShape2D(8.01, 7.95)` — the cannon body is solid and the player can stand on it.

## Player interaction
- Cannonballs call `player.die()` on `body_entered`.
- The cannon body itself is a `StaticBody2D` — the player can stand on it and use it as a platform.

## Signals
None.

## Levels used in
World 2: Level 2 (5 instances), Level 3 (4), Level 4 (16 — densest concentration in the world), Level 6 (6), Boss arena (2). Not used outside World 2.

## Source path note
The Cannon lives under `src/objects/test-objects/Guns/Canon/` historically (alongside dev-only weapons that never shipped). Functionally it is a hazard, hence its placement under `objects/hazards/` in this documentation. A future code refactor may move it to `src/objects/cannon/`. The `Projectiles.gd` autoload (`src/objects/test-objects/Guns/Projectiles.tscn`) is the container `Gun._shoot()` parents bullets under — it ships with the game and is required at runtime.

## Dependencies
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager.sfx_env_canon_shoot`, `sfx_env_canon_ball_explosion`; the `Projectiles` autoload node that holds spawned canonballs.
- [../../player/player.md](../../player/player.md) — receives `die()` on canonball impact.

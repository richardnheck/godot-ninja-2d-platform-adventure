# Test Guns (Pistol, MachineGun, GrenadeLauncher, Canon + projectiles)

**Category:** Object / Test
**Scenes (all in `src/objects/test-objects/Guns/`):**
- `Pistol.tscn`, `MachineGun.tscn`, `GrenadeLauncher.tscn`, `Canon/Canon.tscn` — the weapons.
- `Projectiles.tscn` (`Projectiles.gd`) — a sibling Node2D that holds spawned bullets.
- `Bullets/PistolBullet.tscn` (`AreaBullet.gd`), `Bullets/MachineGuneBullet.tscn` (`AreaBullet.gd`), `Bullets/Grenade.tscn` (`Grenade.gd`), `Bullets/Explosion.tscn` (`Explosion.gd`), `Canon/CanonBall.tscn` (`AreaBullet.gd`).

**Status: NOT used in any shipping level.** Reference / dev sandbox only. The repo retains them for testing; the Godot port can skip them entirely or move them under a `dev/` folder.

## Gun base — `Gun.gd` (`class_name Gun`, extends `Node2D`)

### Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `bullet_scene` | PackedScene | - | Projectile to instance per shot. |
| `shoot_rate` | float | 0.25 | Seconds between shots; arms `ShootTimer`. |
| `delay_time` | float | 0.00 | Initial delay before the first shot (TIMED mode). |
| `mode` | `MODE` enum | `NORMAL` | `NORMAL`, `AUTOMATIC`, `CHARGE`, `TIMED`. |
| `max_charge_time` | float | 2.0 | Used in CHARGE mode; written to `bullet.charge`. |
| `spread_angle` | float | 0.0 | Read by some bullet scenes; not consumed by `Gun.gd` directly. |
| `direction` | Vector2 | `RIGHT` | Bullet fly direction; the gun also rotates itself to `Vector2(abs(direction.x), direction.y).angle()`. |
| `impulse` | int | 370 | Forwarded to `bullet.impulse` if present. |
| `requires_target` | bool | false | If true, the gun waits for `set_target()` before initializing (used by homing variants). |

### Modes
- `NORMAL` — manual shoot path is commented out; effectively dormant.
- `AUTOMATIC` — fires whenever `Input.is_action_pressed("shoot")` AND `ShootTimer` is stopped.
- `CHARGE` — holds while `shoot` is pressed (`charge_time` ramps up to `max_charge_time`), fires on release with `bullet.charge = charge_time / max_charge_time`.
- `TIMED` — fires on `ShootTimer.timeout` after an initial `delay_time` (via `DelayTimer`).

### Shooting
`_shoot()` arms the timer, instances `bullet_scene` under the `Projectiles` autoload-style node, copies `direction` / `impulse` / `charge`, calls `bullet.fire(target)` if present, returns the bullet.

### Required child nodes
`ShootTimer` (one_shot), `DelayTimer` (one_shot), `ShootPosition` (`Position2D` — bullet origin in local space).

## Weapon variants

### Pistol (`Pistol.tscn`)
Extends `Gun.gd`. `bullet_scene = PistolBullet.tscn`, `shoot_rate = 0.2`. Default `mode = NORMAL` so currently dormant.

### MachineGun (`MachineGun.tscn`)
Extends `Gun.gd`. `bullet_scene = MachineGuneBullet.tscn`, `shoot_rate = 0.15`, `mode = 1` (AUTOMATIC), `spread_angle = 0.175`. Fires while `shoot` action held.

### GrenadeLauncher (`GrenadeLauncher.tscn`)
Extends `Gun.gd`. `bullet_scene = Grenade.tscn`, `shoot_rate = 1.0`, `mode = 2` (CHARGE), `max_charge_time = 1.0`. Hold-release to lob a grenade.

### Canon (`Canon/Canon.tscn`, `Canon.gd`)
**Extends:** `Gun` (subclasses the base script). Animated cannon barrel.
- Owns `AnimatedSprite` (`default` + `shoot` animations) and a child `CanonBlastAnimatedSprite` (muzzle flash).
- `_ready()` duplicates `Game_AudioManager.sfx_env_canon_shoot` and attaches it as a child (per-instance audio).
- `_shoot()` chains to `Gun._shoot()` then, if on-screen (`VisibilityNotifier2D.is_on_screen()`), plays the shoot SFX and the `shoot` + blast animations.
- Hack: if `direction == (-1, 0)`, `_sprite.rotation_degrees = 180` (the generic `_sprite.rotate(direction.angle())` does not work — script comment).
- Has a `StaticBody2D` (collision layer 4) — the cannon body is solid.

## Projectiles container

### Projectiles (`Projectiles.tscn`, `Projectiles.gd`)
**Extends:** `Node2D`. Single helper: `remove_all()` iterates and `queue_free()`s every child. Intended to be added to the level scene; `Gun._shoot()` does `Projectiles.add_child(bullet)` (treats `Projectiles` as a class_name singleton in-script — TBD: this only works if `Projectiles.gd` is autoloaded or there is a `class_name`; in the source it has no class_name, so the call site likely depends on a node named `Projectiles` in scope. Verify before porting.)

## Projectile scripts

### AreaBullet (`Bullets/AreaBullet.gd`, `class_name AreaBullet`, extends `Area2D`)
- Used by PistolBullet, MachineGuneBullet, CanonBall.
- Exports `speed` (default 3500 — overridden to 100 in PistolBullet.tscn).
- On `_ready`: duplicates `Game_AudioManager.sfx_env_canon_ball_explosion` as a child, grabs its `ExplosionAnimatedSprite` child, calls `set_as_toplevel(true)` so movement is in world space, connects `body_entered → hit_body`.
- `_physics_process` translates by `speed * delta * direction.normalized()` while not exploding.
- `hit_body(body)` — if body has `die()`, calls it; then `_destroy()` → plays the explosion animation and SFX, hides bullet sprite, sets collision shape disabled (deferred), queue_frees on explosion animation finished.

### Grenade (`Bullets/Grenade.gd`, extends `RigidBody2D`)
- Physics-driven (bouncy, `gravity_scale = 10`, bounce 0.6).
- Setter `set_charge(new_charge)` applies a central impulse `Vector2.RIGHT * max_impulse * charge` immediately.
- A child `Timer` (autostart, one_shot) fires `_on_Timer_timeout()` which spawns an `Explosion.tscn` at the grenade's position and frees self.
- Preloads `Explosion.tscn` as `const Explosion`.

### Explosion (`Bullets/Explosion.gd`, extends `Node2D`)
- Spawns three Particles2D bursts (`Smoke`, `Sparkles`, `Fire`) on a 2-physics-frame delay.
- Iterates `HitBox.get_overlapping_bodies()` and attempts `body.take_damage(damage)` — the call is commented out in the source.
- After 1.1 s emits `explosion_ended` and `queue_free()`s.
- `Events.emit_signal("shake_camera", 0.6)` is also commented out — TBD: no global `Events` singleton in this repo.

## Player interaction
None in shipping levels (no level instances any of these). For test scenes, the player has an `Input.action("shoot")` binding (mouse-left) that drives AUTOMATIC and CHARGE modes; AreaBullet calls `body.die()` on contact.

## Signals
- `Grenade` / `AreaBullet` / `Canon` — none exported.
- `Explosion` — `explosion_ended`.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager.sfx_env_canon_shoot`, `sfx_env_canon_ball_explosion`.
- [player/player.md](../../player/player.md) — calls `player.die()` on bullet impact (test only).

## Notes / TBD
- Whole folder is dev-only — strongly consider not porting unless the team wants a level editor / debug shooter.
- Multiple commented-out lines (`take_damage`, `Events.emit_signal`) indicate an incomplete damage system. Health was never wired up (consistent with the Player notes about `take_damage` being a stub).

# LaserLantern

**Category:** Enemy / PathFollow (stationary or short-path)
**Scene:** `src/characters/enemies/laser-lantern/LaserLantern.tscn`
**Script:** `src/characters/enemies/laser-lantern/LaserLantern.gd` (`tool`, `class_name LaserLantern`)
**Extends:** `Node2D` (NOT `PathFollowEnemyBase` — uses its own simpler tween rig)

## Purpose
A floating lantern that periodically fires a tween-extended laser beam downward (or toward a target offset). Can be fully stationary or slide along a short horizontal path. Killing the player is done via RayCast2D collision detection along the laser line.

## Assets
- Sprite: shares `ShardLanternSheet.png` from shard-lantern (2-frame default loop at 5 fps, 32x40).
- Effect sprite: `laser-effect.png` (4-frame default loop at 10 fps, 16x16).
- Line2D `gradient` from cyan to lighter blue; default `color = Color.white`.
- No bundled SFX (the boss instance plays its own).

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `mode` | enum `MODE` | `STATIONARY` | `STATIONARY` or `PATH` (horizontal slide). |
| `orientation` | enum `Orientation` | `HORIZONTAL_LEFT_RIGHT` | `HORIZONTAL_LEFT_RIGHT` (2) or `HORIZONTAL_RIGHT_LEFT` (3). |
| `speed` | float | `25` | Pixels/sec when `mode == PATH`. |
| `path_length` | int | `64` | Length of the horizontal back-and-forth path. |
| `cast_speed` | float | `7000` | Declared but actual ray growth code is commented out (TBD). |
| `target_position` | Vector2 | `(0, 100)` | Endpoint of the raycast / laser line. |
| `start_distance` | float | `0` | Distance from origin where the line starts drawing. |
| `growth_time` | float | `0.1` | Tween time for `line_2d.width` appear/disappear (`*2` on appear). |
| `color` | Color (setget) | `white` | Modulates `Line2D`. |
| `is_casting` | bool (setget) | `false` | Setting true triggers `appear()` and enables `_physics_process`. |

## Behavior
- `Timer` (autostart, `wait_time = 0.2 s`, one-shot) → `_on_Timer_timeout` toggles `is_casting`. The scene therefore starts firing once the first frame elapses; however the script also calls `set_physics_process(false)` in `_ready()` to prevent the laser firing on load.
- `appear()`/`disappear()` tween `line_2d.width` between 0 and its baked width; `disappear()` schedules `hide_line()` after 0.2 s.
- `_physics_process` (only while casting): forces `raycast.cast_to = target_position`, calls `force_raycast_update()`. If colliding: clamp `line_2d.points[1]` to the collision point and position `AnimatedSpriteEffect` there; if the collider `is Player`, call `collider.die()`.
- `PATH` mode: `PositionTween` tweens `self.position` between `position ± Vector2(path_length/2, 0)` over `path_length / speed` seconds (sine ease), looping via `_on_PositionTween_tween_completed` (invert + restart).
- `LifetimeTimer` (set externally by boss): when `lifetime > 0`, starts at `_ready()`; timeout `queue_free()`s the lantern (boss minion variant).
- `RayCast2D.collision_mask = 15`, `collide_with_areas = true` — hits player + tiles + Areas on layers 1–4.

## Player interaction
Player only dies when the RayCast2D reports them as the collider. There is no separate body Area2D for melee touch death — colliding with the lantern body does nothing.

## Signals
None.

## Dependencies
- [player.md](../../player/player.md) (`Player` class for `is` check).
- VisibilityEnabler2D pauses parent process/physics when off-screen.
- Used by AoAndon as `AoAndonShardLantern` minion (with `lifetime > 0`).

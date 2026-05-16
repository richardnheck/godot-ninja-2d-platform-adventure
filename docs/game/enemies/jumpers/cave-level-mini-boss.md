# CaveLevelMiniBoss

**Category:** Enemy / Jumper (standard enemy — NOT a boss; see [enemies/_category-overview.md](../_category-overview.md))
**Scene:** `src/characters/enemies/CaveLevelMiniBoss/CaveLevelMiniBoss.tscn`
**Script:** `src/characters/enemies/CaveLevelMiniBoss/CaveLevelMiniBoss.gd`
**Extends:** `KinematicBody2D` (layer 4 / mask 2)

## Purpose
The cave mini-boss: a stationary slamming enemy that jumps straight up and crashes back down, spawning a pair of horizontal slam-blast shockwaves on every landing. Player must time jumps to avoid the blasts. Treated as a regular enemy in this codebase (no HP, killed only by checkpoint/cutscene boundaries).

## Assets
- Sprites: `CaveLevelMiniBoss.png` (main body, `SpriteMain`) and `CaveLevelMiniBoss2.png` (flash variant, `SpriteFlash`).
- SFX: `Game_AudioManager.sfx_env_cave_mini_boss_slam` (duplicated).
- Slam-blast scene: `MiniBossSlamBlast.tscn` (see inline below).

## Exported properties
| Name | Type | Default | Notes |
|------|------|--------:|-------|
| `gravity` | int | `500` | Multiplied by `delta`. |
| `jump_power` | int | `250` | Initial `-velocity.y`. |
| `vertical_direction` | int | `1` | `+1 down`, `-1 up` — used only in the `UP_DOWN` state, which is selectable in script but the scene defaults to `JUMP`. |
| `current_state` | enum `State` | `JUMP` | `UP_DOWN = 0` (slides vertically between ceiling/floor with pauses) or `JUMP = 1` (default). |

## Behavior
- `_ready()` caches `ground_global_position` and (if `JUMP`) sets `do_jump = true` + starts `JumpTimer` (2 s).
- **JUMP state** (`_physics_process`):
  - If `do_jump`: `velocity.y = -jump_power`, start `JumpTimer`, `landing = true`.
  - `velocity.x = 0` (no horizontal motion), `move_and_slide(...)`, then `velocity.y += gravity * delta`.
  - On floor + `landing`: `_on_land()`.
- **UP_DOWN state** (alternative): if going down, `vertical_speed = 250`; if up, `100`. Move at `(0, vertical_speed * vertical_direction)`. On hitting ceiling or floor: `paused = true`, start `PauseTimer`, invert direction. On floor, also call `_on_land()`. (Pause duration = `PauseTimer.wait_time`, default 0 → not really pausing; TBD.)
- `_on_land()` plays `slam_sound`, flashes `SpriteMain` via `_flash_sprite()` (hide 0.1 s then show), screen-shakes `(0.5, 2, 100)`, then `_spawn_slam_blast()`.
- `_spawn_slam_blast()` instances two `MiniBossSlamBlast` scenes at half-scale: one at `global_position + (0, -1)` pointing right (`set_direction(1)`), one at `global_position + (-32, -1)` pointing left (`set_direction(-1)`).
- `JumpTimer.timeout` → `do_jump = true`. `PauseTimer.timeout` → `paused = false`.

## Player interaction
- Body `Area2D` (16x16 over the body) `body_entered` → `body.die()`.
- Slam-blasts also kill on contact (see below).

## Signals
None.

### Inline projectile: MiniBossSlamBlast
**Scene:** `.../CaveLevelMiniBoss/MiniBossSlamBlast.tscn`
**Script:** `.../MiniBossSlamBlast.gd` (`class_name MiniBossSlamBlast`)
**Extends:** `Node2D`

- Exports `direction:int = 1`. `set_direction(dir)` flips `Area2D/AnimatedSprite.flip_h` when leftwards. `velocity = 200` (hardcoded, not exported).
- `_physics_process`: `area.position.x += velocity * direction * delta` — translates ONLY the child `Area2D` along x, leaving the script-owned `Node2D` root in place. Sprite (2-frame loop from `slam-blast1.png`/`slam-blast2.png` @ 10 fps) is on the same `Area2D`, so it travels along.
- `Area2D.body_entered`: if player → `body.die()`. Otherwise `queue_free()` the whole blast (so it dies on hitting a wall/tile).
- TBD: the blast has no `VisibilityNotifier2D` cleanup; if it never hits a body, it lives forever offscreen.

## Dependencies
- [player.md](../../player/player.md).
- `Game_AudioManager.sfx_env_cave_mini_boss_slam`.
- Parent-scene `ScreenShake` node.
- Sprite textures shared with `CaveLevelBoss` (`slam-blast1.png`, `slam-blast2.png`).

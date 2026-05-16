# project.godot — Engine & Project Configuration

Everything in `project.godot` that the porting agent needs to know. The file lives at the repo root.

---

## Application

- **Game title:** `Castle Yokai`
- **Main scene:** `res://src/UI/SplashScreen/SplashScreen.tscn`
- **Icon:** `res://icon.png`
- **Version:** `1.50`

## Audio
- `output_latency = 50` (ms)
- `output_latency.web = 120`

## Display
- Base render size: `320 × 180`.
- Base height for integer-scaling addon: `180`.
- Stretch mode: `2d`, aspect `keep_height`, stretch disabled (handled by IntegerResolutionHandler addon).
- `test_width = 960`, `test_height = 540` — editor preview size.
- `window/size/always_on_top = true` — editor convenience flag.

## Rendering
- Driver: `GLES2` (with GLES2 fallback) — the game targets HTML5 export, hence GLES2.
- `2d/snapping/use_gpu_pixel_snap = true`, `quality/2d/use_pixel_snap = true` — pixel-perfect rendering.
- `vram_compression/import_etc = true`.
- Default environment: `res://default_env.tres`.

## Input devices
- `pointing/emulate_touch_from_mouse = true` — mouse-as-touch for development.

---

## Autoloads

Loaded in this order (order matters — later autoloads can reference earlier ones):

| # | Name | Path | Type |
|---|------|------|------|
| 1 | `Env` | `src/lib/env.gd` | script |
| 2 | `Actions` | `src/settings/Actions.gd` | script |
| 3 | `Constants` | `src/settings/Constants.gd` | script |
| 4 | `LevelData` | `src/settings/LevelData.gd` | script |
| 5 | `Global` | `src/UI/Global.tscn` | scene |
| 6 | `Game_AudioManager` | `src/lib/AudioManager/AudioManager.tscn` | scene |
| 7 | `Settings` | `src/settings/Settings.gd` | script |
| 8 | `ArrayUtil` | `src/utility/ArrayUtil.gd` | script |
| 9 | `GameState` | `src/settings/GameState.gd` | script |
| 10 | `Ease` | `src/utility/Ease.gd` | script |
| 11 | `Projectiles` | `src/objects/test-objects/Guns/Projectiles.tscn` | scene |
| 12 | `IntegerResolutionHandler` | `addons/integer_resolution_handler/integer_resolution_handler.gd` | script |
| 13 | `MainScreenState` | `src/UI/MainScreen/MainScreenState.gd` | script |
| 14 | `Analytics` | `src/lib/Analytics/analytics.gd` | script |
| 15 | `LevelMetrics` | `src/levels/LevelMetrics.gd` | script |
| 16 | `Stopwatch` | `src/objects/stopwatch/Stopwatch.gd` | script |
| 17 | `DebugLog` | `src/UI/Debug/DebugLog.gd` | script |

Each is described in [autoloads.md](autoloads.md).

---

## Input map

| Action | Inputs |
|--------|--------|
| `jump` | Up arrow, X, W, Space, Gamepad A/B/X/Y (button_index 0–3) |
| `move_left` | Left arrow, A, Gamepad DPad-Left (button_index 14) |
| `move_right` | Right arrow, D, Gamepad DPad-Right (button_index 15) |
| `pause` | Esc |
| `shoot` | Mouse left-click (only used by test gun scenes) |
| `jump_cutscene` | (no bindings — used programmatically by cutscenes) |
| `move_left_cutscene` | (no bindings) |
| `move_right_cutscene` | (no bindings) |

The `*_cutscene` actions exist purely so `Actions.gd` can flip the active action name. They MUST be defined in the input map even though they are unbound, otherwise `Input.is_action_pressed()` calls would fail on them.

Deadzone for all actions: `0.5`.

Decoded key scancodes:
- `16777232` = Up arrow, `16777231` = Left arrow, `16777233` = Right arrow, `16777217` = Esc
- `87` = W, `88` = X, `68` = D, `65` = A, `32` = Space

---

## Collision layers (2d_physics)

| Layer # | Name |
|---:|------|
| 1 | `player` |
| 2 | `world` |
| 3 | `traps` |
| 4 | `objects` |
| 5 | `boss` |
| 6 | `boss-world` |
| 7 | `boss-spikes-world` |
| 8 | `enemies` |
| 9 | `world-border` |

Player wall raycasts mask only layer 2 (`world`). Boss arenas use the separate `boss-world` / `boss-spikes-world` layers to keep their geometry distinct from regular level geometry.

---

## Groups (defined in `Constants.gd`)

| Group | Used for |
|-------|----------|
| `player` | The player KinematicBody2D |
| `key` | The `KamonKey` interactive |
| `door` | Cave doors |
| `trap` | Damage-on-touch hazards |
| `water-trap` | Water hazards (DieByWater branch — currently commented out) |
| `checkpoint` | Checkpoint Area2Ds |
| `killable-enemy` | Enemies that can be killed by certain actions (mostly unused — see player.md) |
| `boss` | Boss enemies |

---

## Editor plugins (addons enabled)

- `addons/godot-console/plugin.cfg` — Godot Console (debug console)
- `addons/integer_resolution_handler/plugin.cfg` — pixel-perfect scaling
- `addons/onscreenkeyboard/plugin.cfg` — on-screen keyboard for mobile/HTML5 builds

---

## Importer defaults

Texture import preset (`[importer_defaults] texture`):
- `flags/filter = false` — nearest-neighbour for pixel art
- `flags/mipmaps = false`
- `flags/srgb = 2`
- `process/fix_alpha_border = true`
- `compress/mode = 0` — lossless

This is critical for pixel art: filtering off ensures crisp tiles. Every sprite in `assets/art/` inherits this preset.

---

## Tiled importer
- `enable_json_format = true` — the project can import Tiled (`.tmx` → JSON) maps, although the shipping levels use Godot's native TileMap nodes.

---

## Debug
- `debug_mode = true` — leftover dev flag in `[Debug]` section.

---

## Global script classes

`project.godot` `_global_script_classes` is the source of truth for every `class_name` in the project — every enemy, projectile, object, screen, and helper is registered there. The list is the cleanest single-place reference for "what classes exist". Each enemy/object/screen doc references its class name in the `Extends:` line.

Notable subclass parents:
- `PathFollowEnemyBase` — base for path-follow enemies (see [../enemies/path-follow/path-follow-base.md](../enemies/path-follow/path-follow-base.md))
- `SimpleEnemy` — base for some stationary enemies
- `Character`, `Character2` — character bases (see [../player/player.md](../player/player.md))
- `CutSceneBase` — base for every cutscene scene
- `Gun` — base for every test weapon variant

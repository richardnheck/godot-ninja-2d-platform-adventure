# ScreenShake

**Category:** Object / Camera
**Scene:** `src/objects/camera-effects/ScreenShake.tscn`
**Script:** `src/objects/camera-effects/ScreenShake.gd` (`class_name ScreenShake`)
**Extends:** `Node2D`

## Purpose
A reusable camera-shake driver. Tweens a random `offset` onto a target `Camera2D` for a configurable duration, with simple priority queueing so weak shakes can't interrupt strong ones already in progress.

## Assets
None.

## Scene structure
```
ScreenShake (Node2D, script)
  Tween
```

## Exported properties
None.

## Public API
- `set_camera_node(path: String)` — store the relative node path (from this node's **parent**) to the target Camera2D. Must be called once before any shake.
- `screen_shake(shake_length: float, shake_power: float, shake_priority: int)` — request a shake. If `shake_priority > current_shake_priority`, the previous shake is overridden and a new tween starts.

## Behavior
- Internal state: `current_shake_priority` (int, starts 0), `camera_node_path` (set via `set_camera_node`).
- `screen_shake(length, power, priority)`:
  1. Compare `priority > current_shake_priority`. If false → ignore.
  2. Replace `current_shake_priority = priority`.
  3. `Tween.interpolate_method(self, "_move_camera", Vector2(power, power), Vector2.ZERO, length, Tween.TRANS_SINE, Tween.EASE_OUT, 0)`.
  4. `Tween.start()`.
- `_move_camera(vector)` — called every tween frame. Sets the target camera's `offset` to `Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))`. The interpolated vector ramps from `(power, power)` down to `(0, 0)`, so the shake decays.
- `_on_Tween_tween_completed` resets `current_shake_priority = 0` — next request of any priority can start.

## Player interaction
Indirect. Bosses, explosions, and cutscenes call `screen_shake()`. The player sees the camera vibrate.

## Signals
None.

## Dependencies
- The camera target it shakes — typically the level's `Camera2D` inside the player's `CameraManager`. Callers pass the relative path via `set_camera_node()`.
- Callers (search `screen_shake` in repo): `src/levels/LevelBase.gd`, `src/UI/CutScenes/World3/BossClearCutScenePart1.gd`, `src/UI/CutScenes/CutSceneBase.gd`, `src/UI/CutScenes/World2/BossClearCutScene.gd`, `src/UI/CutScenes/CaveLevel/BossClearCutScene.gd`.

## Notes / TBD
- `_move_camera` resolves the camera via `get_parent().get_node(camera_node_path)` — `camera_node_path` is therefore relative to **this node's parent**, not to this node. The caller is responsible for setting it correctly.
- The X and Y shake magnitudes always start equal (`Vector2(power, power)`). No anisotropic shake support.

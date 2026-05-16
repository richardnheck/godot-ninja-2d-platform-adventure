# Frameworks & Utilities

Small helper modules used by gameplay code. Most are autoloaded singletons (see [autoloads.md](autoloads.md)); a few are non-autoload classes referenced by `class_name`.

---

## Physics2D

**Path:** `src/engine/Physics2D.gd`
**Class:** `Physics2D` (extends `Node2D`)
**NOT autoloaded** — added per-character as a child Node2D where needed.

Reusable physics helper for `Character2`-based characters. NOT used by the player; the player has its own gravity and `move_and_slide` inline in `motion.gd`.

Exported: `GRAVITY: float = 900.0`.

Constants:
- `FLOOR_NORMAL = Vector2(0, -1)`
- `SLOPE_SLIDE_STOP = 5.0`
- `SNAP = Vector2(0, 16)`
- `MAX_SLOPE_DEGREE = deg2rad(46)`

Method:
- `compute_gravity(host: Character2, delta)` — applies gravity (clamped to `GRAVITY`), then calls either `move_and_slide_with_snap` (if `host.snap_enable`) or `move_and_slide`, and sets `host.is_grounded`.

---

## Momentum

**Path:** `src/engine/Momentum.gd`
**Class:** `Momentum` (extends `Node2D`)
**NOT autoloaded.**

Brief slow-motion / "hit-stop" effect for impact feedback. Manipulates `Engine.time_scale` directly.

Exported:
- `DURATION: float = 0.07` — seconds.
- `STRENGTH: float = 1.0` — `1.0` = full freeze, `0.0` = no effect.

Method:
- `attack_momentum()` — sets `Engine.time_scale = 1 - STRENGTH`, then over `DURATION` eases back to `1.0` using a circular ease-in (`circl_ease_in`).

`_process(delta)` runs the easing while `is_active`.

---

## Ease

**Path:** `src/utility/Ease.gd`
**Type:** Node (autoloaded as `Ease`)

Pure easing-function utilities (formulas from easings.net). All return `[0, 1]` and accept `(x, offset = 0, length = 1)`.

Available functions:
- **Sine** — `easeInSine`, `easeOutSine`, `easeInOutSine`
- **Quad** — `easeInQuad`, `easeOutQuad`, `easeInOutQuad`
- **Poly** — `easeInPoly`, `easeOutPoly`, `easeInOutPoly` (extra `poly` arg)
- **Expo** — `easeInExpo`, `easeOutExpo`, `easeInOutExpo`
- **Circ** — `easeInCirc`, `easeOutCirc`, `easeInOutCirc`
- **Back** — `easeInBack`, `easeOutBack`, `easeInOutBack`
- **Elastic** — `easeInElastic`, `easeOutElastic`, `easeInOutElastic` (extra `wobble` arg)
- **Bounce** — `easeInBounce`, `easeOutBounce`, `easeInOutBounce`

Used by `RotatingPlatform` and `FireBallSpinner` for smooth swing motion (see those object docs).

---

## ArrayUtil

**Path:** `src/utility/ArrayUtil.gd`
**Type:** Node (autoloaded as `ArrayUtil`)

Currently exposes one static helper:
- `filter(input: Array, function: FuncRef) -> Array` — array filter using a `FuncRef`.

---

## FadeScreen

**Path:** `src/UI/FadeScreen/FadeScreen.gd` + `src/UI/FadeScreen.tscn`
**Class:** `FadeScreen` (extends `Node2D`)
**NOT autoloaded** — instanced per screen.

Reusable screen-wide fade-in / fade-out CanvasLayer used between scene transitions. Documented here (rather than as its own UI screen) because it's a utility widget consumed by other screens — see the references in [../ui/_flow.md](../ui/_flow.md).

Typical usage: instance under a screen's root, call `fade_in()` / `fade_out()` (or whatever the script exposes), wait for `animation_finished` (or equivalent signal) before triggering `get_tree().change_scene(...)`.

`TBD — exact API: read the .gd to confirm exact method names and signal name (e.g. `faded_out`).`

---

## IntegerResolutionHandler

**Path:** `addons/integer_resolution_handler/integer_resolution_handler.gd`
**Type:** Third-party plugin autoload.

Handles integer-multiple scaling for pixel-perfect rendering. The game runs at `320 × 180` base resolution (see `[display]` in `project.godot`); this autoload scales it to the window while preserving integer multiples to avoid pixel sub-sampling.

Config in `project.godot`:
- `window/integer_resolution_handler/base_height = 180`
- `window/size/width = 320`, `window/size/height = 180`
- `window/stretch/mode = "2d"`, `aspect = "keep_height"`

The addon also brings editor tooling (a plugin under `addons/integer_resolution_handler/plugin.cfg`). For the port, the equivalent is whatever pixel-perfect render scaling Defold provides — but the description here is what we have today, not how to port it.

---

## State machine framework

The generic FSM at `src/utility/state_machine/state_machine.gd` + `state.gd` is documented inside [../player/player.md](../player/player.md) because the player is the only real consumer. There is a parallel "commons" FSM under `src/characters/commons/states/` and `src/statemachine/states/` used by some character base classes (also covered in `player/player.md`'s shared-base section); these are mostly stubs and unused by shipping enemies.

---

## Geometry2D

**Path:** `src/utility/Geometry2D.gd`
**Class:** `Geometry2D` (extends `CollisionShape2D`)
**NOT autoloaded.**

Geometry helper utilities (TBD — read the file for exact API; small file).

---

## Draw

**Path:** `src/tools/draw.gd`
**Class:** `Draw` (extends `Node2D`)
**NOT autoloaded.**

Debug drawing helper used by `tool`-mode scripts (RotatingPlatform, FireBallSpinner, RotatingOnibi) to render swing/spin guide overlays in the editor. Behaviour is editor-only and can be ignored at runtime.

---

## Talo SDK helpers

`src/lib/Analytics/Talo/` — five Reference-derived classes consumed by `Analytics`:
- `TaloEntityWithProps`, `TaloLeaderboardEntry`, `TaloProp`, `TaloPropUtils`, `TaloTimeUtils`

These wrap the leaderboard/analytics API; behaviour is documented further in the leaderboard UI doc (see [../ui/leaderboard.md](../ui/leaderboard.md)).

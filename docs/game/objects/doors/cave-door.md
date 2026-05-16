# CaveDoor (Door, DoorStart, DoorBackground)

**Category:** Object / Door
**Scenes:**
- `src/objects/cave-level-door/Door.tscn` — the gameplay door (open/closed sprite + trigger).
- `src/objects/CaveDoorStart.tscn` — the start-of-level decorative door.
- `src/objects/cave-level/CaveDoorBackground.tscn` — a darker recessed door sprite placed behind the start door.

**Script:** `src/objects/cave-level-door/Door.gd` (only `Door.tscn` has a script)
**Extends:** `Node2D`

## Purpose
The level-end door. The player must collect the level's KamonKey (which calls `door.open()` via `LevelBase`) and then walk into the door to clear the level. `DoorStart` and `CaveDoorBackground` are visual-only counterparts placed at the level's spawn point.

## Assets
- Door sprite: `assets/art/props/door/world1-door.png` — 2 horizontal frames (`hframes = 2`): frame 0 = closed, frame 1 = open.
- DoorStart sprite: `assets/art/props/door/cave-door-plain.png` (single still, positioned at y=-16).
- DoorBackground sprite: `assets/art/props/door/cave-door-background.png` (uncentered, offset y=-64).
- SFX: none (the cave sliding door has its own SFX; the cave door itself is silent).

## Exported properties (`Door.gd`)
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `is_open` | bool | false | Authoring/runtime open state. Sets sprite frame on `_ready` and on `open()`/`close()`. |

## Behavior
**`Door.tscn`**
- Root is `Node2D` in the `door` group. `Sprite` (hframes 2) shows frame 0 closed / frame 1 open.
- A small `Area2D` (`RectangleShape2D` extents ~5.1 x 1.0, collision layer `2147483656`) detects the player at the doorway.
- `_ready()` sets the sprite frame from `is_open`.
- `open()` / `close()` — set `is_open` and call `_set_door_image()`.
- `_on_Area2D_body_entered(body)` — if the body is in `Constants.GROUP_PLAYER` AND `is_open == true`:
  - Emits `player_entered`.
  - Calls `set_physics_process(false)` to stop further hits (one-shot).

**`CaveDoorStart.tscn`** — pure `Sprite` with the plain-door texture. No script, no collision, no logic. Decoration only.

**`CaveDoorBackground.tscn`** — pure `Sprite` showing the recessed background piece. No script, no collision. Placed behind `CaveDoorStart` to give depth at the level entrance.

## Player interaction
- Closed door: the `Area2D` still fires `body_entered` but the script ignores it because `is_open == false` — the player can walk past, blocked instead by a separate tilemap collider behind the door.
- Open door: walk into the doorway → `player_entered` fires → level-clear sequence runs.
- DoorStart / DoorBackground: no interaction.

## Signals
- `player_entered` (Door only) — emitted once when the player passes through an open door. Listener: each level scene wires `[connection signal="player_entered" from="...Door" to="." method="_on_Door_player_entered"]`; the handler in `LevelBase.gd` triggers level-clear (cutscene transition + level-complete logic).

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.
- [objects/interactive/kamon-key.md](../interactive/kamon-key.md) — capture calls `door.open()` indirectly via `LevelBase._on_Key_captured`.
- [levels/level-base.md](../../levels/level-base.md) — `_on_Door_player_entered` handler.

## Notes / TBD
- Some early levels (no key) start with `is_open = true` set in the scene, making the door always-open.

# Decorations (JapaneseLamp, SmallLantern, WaterSplash)

**Category:** Object / Decoration
**Scenes:**
- `src/objects/japanese-lamp/JapaneseLamp.tscn` — World 1 wall lamp (no script).
- `src/objects/world3-lanterns/SmallLantern.tscn` — World 3 hanging lantern (no script).
- `src/objects/water-splash/WaterSplash.tscn` — short-lived water splash effect (script).

These three are visual-only — no collision, no gameplay impact.

## JapaneseLamp

**Extends:** `AnimatedSprite`
**Script:** none.
**Assets:** `src/objects/japanese-lamp/JapaneseLamp.png` (2 frames, 32x32, looped at 5 fps).

- Root `AnimatedSprite` autoplaying `default` (2-frame flicker), starts on `frame = 1`.
- A child `VisibilityEnabler2D` (scale 1.6, 1.6 to give a generous off-screen margin) pauses animation off-screen.
- Placed in World 1 cave levels for ambient glow. No interaction, no signals.

## SmallLantern

**Extends:** `AnimatedSprite`
**Script:** none.
**Assets:** `src/objects/world3-lanterns/SmallLantern.png` (2 frames, 32x32, looped at 4 fps).

- Root `AnimatedSprite` autoplaying `default` (2-frame flicker).
- Child `VisibilityEnabler2D` (scale 1.6, 1.6) pauses animation off-screen.
- Spawned by the World 3 boss arena's animated spawners (see commit `c65552c`) and placed statically in W3 levels. No interaction, no signals.

## WaterSplash

**Scene:** `src/objects/water-splash/WaterSplash.tscn`
**Script:** `src/objects/water-splash/WaterSplash.gd`
**Extends:** `Node2D`
**Assets:** `assets/art/tilesets/world2/water-tileset/splash-v1-Sheet.png` (10 frames, 16x16, looped at 20 fps).

- Root `Node2D` (z_index 5) with one `AnimatedSprite` child autoplaying `default`.
- The script's `_on_AnimatedSprite_animation_finished()` calls `queue_free()` — so the splash plays once and removes itself. Despite `loop = true` on the SpriteFrames, `animation_finished` still fires per cycle in Godot 3, which is what triggers the destroy.
- Instanced by water-level objects (e.g. water hazards / boat entry) when the player touches the water surface. Spawn site sets `global_position` before adding to the tree.
- No exports, no signals, no player interaction (passes through).

## Exported properties
None on any of the three scenes.

## Dependencies
- None (these are pure visuals; no autoload references).

## Notes / TBD
- WaterSplash is referenced by name from water-trap hazards and the Boat scene area, but the spawn call sites are not documented here — TBD: trace the exact spawner if needed during the port.

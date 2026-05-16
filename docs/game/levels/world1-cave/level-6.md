# Deadly dokutsu

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level6.tscn`
**Root node:** `ClaustrophobicCaverns`
**Inherits:** LevelBase (script ExtResource id 6)

## Display name & BGM

"Deadly dokutsu" / `Bgm_CaveLevelTheme`.

`LevelData.levelsArray[5]`. The final pre-boss cave level. Introduces the `CaveLevelMiniBoss` jumper (× 3) and the cave sliding door — a different exit door variant from `cave-door` used elsewhere.

## Tilesets used

- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — `TileMapWorld` + `TileMapTraps`.
- `assets/art/tilesets/cave-level/CaveLevelBackgroundTileset.tres` — `TileMapBg`.

See [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers

- `TileMapBg` — cave-brick background.
- `TileMapWorld` — collidable world geometry.
- `TileMapTraps` — hazard tiles (group `["trap"]`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| CaveLevelMiniBoss | 3 (`CaveLevelMiniBoss`, `CaveLevelMiniBoss3`, `CaveLevelMiniBoss4`) | [cave-level-mini-boss](../../enemies/jumpers/cave-level-mini-boss.md) |
| OneEyedSpikey | 1 | [one-eyed-spikey](../../enemies/path-follow/one-eyed-spikey.md) |
| Ashimigarari | 2 (`Ashimigarari2`, `Ashimigarari3`) | [ashimigarari](../../enemies/path-follow/ashimigarari.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave sliding) | 1 | [cave-sliding-door](../../objects/doors/cave-sliding-door.md) |
| DoorStart (CaveDoorStart) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CheckPoint | 2 (`CheckPoint1` default, `CheckPoint2` id `"2"`) | [checkpoint](../../objects/interactive/checkpoint.md) |
| SpikeyRock | 2 (`SpikeyRock3`, `SpikeyRock4`) | [spikey-rock](../../objects/hazards/spikey-rock.md) |
| MovingPlatformCave2H | 3 (`MovingPlatformCave2H3`, `…4`, `…5`) | [moving-platforms](../../objects/platforms/moving-platforms.md) |
| FallingSpike | 6 (`FallingSpike5`–`…7`, `…9`, `…11`, `…12`, `…6`) | [falling-spike](../../objects/hazards/falling-spike.md) |
| MovingBambooSpike | 4 (`MovingBambooSpike3`–`…6`) | [moving-bamboo-spike](../../objects/hazards/moving-bamboo-spike.md) |
| CrumblingPlatform | 2 (`CrumblingPlatform8`, `CrumblingPlatform9`) | [crumbling-platform](../../objects/platforms/crumbling-platform.md) |
| JapaneseLamp | 27 | [decorations](../../objects/decoration/decorations.md) |
| CameraAdjustArea2D | 4 (`CameraAdjustAreaDown`, `…Reset`, `…Down2`, `…Reset2`) | [camera-adjust-area](../../objects/camera/camera-adjust-area.md) |

## Checkpoints

- `CheckPoint1` — default id.
- `CheckPoint2` — id `"2"`.

## Notes

- Uses `CaveLevelSlidingDoor.tscn` instead of the normal `Door.tscn` exit. A separate `door-top` Sprite (`door-top.png`, ExtResource id 20) covers the top of the sliding door visually.
- Adds an `EndArea` Area2D (with `CollisionShape2D`) under `InteractiveProps` — the body-entered routing for level completion can fire from either the door or this area, both handled by `LevelBase._on_EndArea_body_entered`.
- Highest lamp count of any cave level (27 placements) — the level is long and narrow, so lamps mark the way.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/jumpers/cave-level-mini-boss.md](../../enemies/jumpers/cave-level-mini-boss.md)
- [../../enemies/path-follow/one-eyed-spikey.md](../../enemies/path-follow/one-eyed-spikey.md)
- [../../enemies/path-follow/ashimigarari.md](../../enemies/path-follow/ashimigarari.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md)
- [../../objects/doors/cave-sliding-door.md](../../objects/doors/cave-sliding-door.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/hazards/spikey-rock.md](../../objects/hazards/spikey-rock.md)
- [../../objects/hazards/falling-spike.md](../../objects/hazards/falling-spike.md)
- [../../objects/hazards/moving-bamboo-spike.md](../../objects/hazards/moving-bamboo-spike.md)
- [../../objects/platforms/moving-platforms.md](../../objects/platforms/moving-platforms.md)
- [../../objects/platforms/crumbling-platform.md](../../objects/platforms/crumbling-platform.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md)

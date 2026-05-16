# Jump did you say? Sensei?

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level2.tscn`
**Root node:** `CaveLevelArtOfJumping`
**Inherits:** LevelBase (script ExtResource id 4)

## Display name & BGM

"Jump did you say? Sensei?" / `Bgm_CaveLevelTheme`.

`LevelData.levelsArray[1]`. The first level with real platforming hazards: the player has the tutorial panels behind them and now has to jump across cave gaps populated with creeping yokai.

## Tilesets used

- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — `TileMapWorld` + `TileMapTraps`.
- `assets/art/tilesets/cave-level/CaveLevelBackgroundTileset.tres` — `TileMapBg`.
- Raw atlas `assets/art/tilesets/cave-level/cave-tileset.png` is also referenced (ExtResource id 6) as a `Texture` for `TileMapWorldBg`, the non-collidable decorative overlay layer.

See [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers

- `TileMapBg` — cave-brick background.
- `TileMapWorldBg` — decorative cave-tileset overlay (no collision).
- `TileMapWorld` — collidable world geometry.
- `TileMapTraps` — hazard tiles (group `["trap"]`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| Ashimigarari | 2 (`Ashimigarari`, `Ashimigarari2`) | [ashimigarari](../../enemies/path-follow/ashimigarari.md) |
| RedCreepyCrawly | 1 | [red-creepy-crawly](../../enemies/path-follow/red-creepy-crawly.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| DoorStart (CaveDoorStart) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CheckPoint | 1 (default id) | [checkpoint](../../objects/interactive/checkpoint.md) |
| JapaneseLamp | 13 | [decorations](../../objects/decoration/decorations.md) |

## Checkpoints

- `CheckPoint` — default id (no `id` export).

## Notes

- First level to use the `DoorStart` visual entry door on the player-spawn end.
- Decorative `Stalecmites` (round-stalecmite × ~15) and `Stalectites` (× 3) Sprite groups fill the cavern.
- No moving platforms or crumbling tiles yet — purely static geometry to drill the jump.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/path-follow/ashimigarari.md](../../enemies/path-follow/ashimigarari.md)
- [../../enemies/path-follow/red-creepy-crawly.md](../../enemies/path-follow/red-creepy-crawly.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)

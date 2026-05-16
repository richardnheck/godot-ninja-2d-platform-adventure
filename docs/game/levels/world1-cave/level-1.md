# Time to learn young gakusei

**Category:** Level / World 1 (Cave)
**Scene:** `src/levels/CaveLevels/World1Level_Level1.tscn`
**Root node:** `CaveLevelLearningMechanics`
**Inherits:** LevelBase (script ExtResource id 1)

## Display name & BGM

"Time to learn young gakusei" / `Bgm_CaveLevelTheme` (via `LevelData.CAVE_LEVEL_BGM`).

The tutorial level — `LevelData.levelsArray[0]`. First scene the player enters after the title screen, gated only by jump-dot trails and on-screen panels.

## Tilesets used

- `assets/art/tilesets/cave-level/CaveLevelTileset.tres` — collision world + traps.
- `assets/art/tilesets/cave-level/CaveLevelBackgroundTileset.tres` — `TileMapBg` (cave-brick fill).
- `assets/art/tilesets/cave-level/CaveLevelTilesetNoCollisions.tres` — referenced indirectly for the no-collision decorative variant (see `TileMapTexture` below).

See [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md).

## TileMap layers

- `TileMapBlockHole` — hidden collision used to seal the level edges.
- `TileMapBg` — cave-brick background.
- `TileMapWorld` — main collidable world geometry.
- `TileMapTexture` — non-collidable detail overlay.
- `TileMapTraps` — hazard tiles (group `["trap"]`).

## Enemies placed

| Enemy | Count | Doc |
|-------|------:|-----|
| RedCreepyCrawly | 1 | [red-creepy-crawly](../../enemies/path-follow/red-creepy-crawly.md) |
| Ashimigarari | 1 (`Ashimigarari2`) | [ashimigarari](../../enemies/path-follow/ashimigarari.md) |

## Objects placed

| Object | Count | Doc |
|--------|------:|-----|
| KamonKey | 1 | [kamon-key](../../objects/interactive/kamon-key.md) |
| Door (cave) | 1 | [cave-door](../../objects/doors/cave-door.md) |
| CheckPoint | 3 (default, id `"2"`, id `"3"`) | [checkpoint](../../objects/interactive/checkpoint.md) |
| JapaneseLamp | 9 | [decorations](../../objects/decoration/decorations.md) |
| JumpDot | ~48 (across 4 `Dots1`–`Dots4` trails) | [jump-dot](../../objects/tutorial/jump-dot.md) |
| CameraAdjustArea2D | 1 (`CameraAdjustAreaDown`) | [camera-adjust-area](../../objects/camera/camera-adjust-area.md) |

## Checkpoints

- `CheckPoint` (default — no `id` export; falls back to script default).
- `CheckPoint2` — id `"2"`.
- `CheckPoint3` — id `"3"`.

## Notes

- Hosts the World 1 tutorial system. The scene wires a child `TutorialPanels` Node2D running `src/levels/CaveLevels/TutorialPanels.gd` (script ExtResource id 21). It contains nine NinePatchRect panels: `ControlsMobile`, `ControlsKeyboard`, `DoubleJump`, `WallJump`, `WallJump2`, `WallJump3a`, `AvoidYokai`, `WallSlide`, `FindKey`. See [../level-base.md](../level-base.md) (TutorialPanels.gd entry).
- The tutorial panels reference `MobileControlsPane.png`, `KeyboardControlsPane.png`, `TutorialFrame.png`, `TutorialPanel.png`, and the `8-bit-fortress-font-7px.tres` DynamicFont.
- Three named jump-dot trails (`Dots1`, `Dots2`, `Dots3`, `Dots4`) overlay the level to guide first-time players through each tutorial gate.
- The decorative `Stalecmites` and `Stalectites` Node2Ds carry 30+ individual `Sprite` instances of `round-stalecmite.png` and `stalectite.png`.

## Dependencies

- [../level-base.md](../level-base.md)
- [../tilemaps/cave-tilesets.md](../tilemaps/cave-tilesets.md)
- [../../enemies/path-follow/ashimigarari.md](../../enemies/path-follow/ashimigarari.md)
- [../../enemies/path-follow/red-creepy-crawly.md](../../enemies/path-follow/red-creepy-crawly.md)
- [../../objects/interactive/kamon-key.md](../../objects/interactive/kamon-key.md)
- [../../objects/interactive/checkpoint.md](../../objects/interactive/checkpoint.md)
- [../../objects/doors/cave-door.md](../../objects/doors/cave-door.md)
- [../../objects/decoration/decorations.md](../../objects/decoration/decorations.md)
- [../../objects/tutorial/jump-dot.md](../../objects/tutorial/jump-dot.md)
- [../../objects/camera/camera-adjust-area.md](../../objects/camera/camera-adjust-area.md)

# HelpSign

**Category:** Object / Interactive
**Scene:** `src/objects/help-sign/HelpSign.tscn`
**Script:** `src/objects/help-sign/HelpSign.gd`
**Extends:** `Node2D`

## Purpose
A static wooden sign that pops up a tutorial panel when the player walks into its trigger zone. The displayed panel is picked at edit time via `messageIndex`.

## Assets
- Sign sprite: `src/objects/help-sign/HelpSign.png`
- Panel nine-patch texture: `src/objects/help-sign/help-sign-texture.png`
- Controls glyph (used by panel `0`): `src/UI/Settings/controls.png`
- Fonts: `assets/fonts/pixeloperator8-font.tres`, `assets/fonts/m5x7.tres`
- SFX: none.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `messageIndex` | int | -1 | Index into the panel list. `< 0` shows nothing. Valid range `0..4`. |

## Help messages (in-code, informational)
The `helpMessages` array (defined in script but not currently rendered — each panel has its own pre-authored Label nodes) is:
1. `"Press ^ to jump"`
2. `"Press ^ twice\nto double jump"`
3. `"Need a key to open door"`
4. `"Hold ^ against a wall\n and press arrow away\n from wall to walljump"`
5. `"Walljump off one wall only"`

In practice the displayed text is the pre-authored `RichTextLabel` inside each of `Panels/0..Panels/4`.

## Behavior
- `_ready()` hides every child of `$Panels` (deferred `visible = false`).
- On `$Area2D.body_entered`, if the body is in `Constants.GROUP_PLAYER`, calls `_show_help_panel(true)` which makes `$Panels.get_child(messageIndex)` visible.
- On `body_exited` with the player, hides it again.
- Bounds check: only shows when `0 <= messageIndex < helpMessages.size()` (5).
- The `Panels` node has `z_index = 4096` and `z_as_relative = false` so the popup floats above everything.

## Player interaction
Stand inside the `Area2D` (rectangle collision shape centred at y=-10) → matching panel appears. Walk out → it hides. No input required.

## Signals
None.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`.

## Notes / TBD
- The `helpMessages` GDScript array is never read for display; the visible text lives in the scene's `RichTextLabel` nodes. The Godot port can keep either source of truth but the scene labels are authoritative.

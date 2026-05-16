# UserScreen

**Category:** UI / Screen
**Scene:** `src/UI/UserScreen/UserScreen.tscn`
**Script:** `src/UI/UserScreen/UserScreen.gd`
**Extends:** `Control`

## Purpose
Modal "User" panel embedded in `MainScreen`. Lets the player set or change their display name (validated against the Talo analytics backend so two players cannot share a name) and reset all local progress.

## Assets
- Sprites: `Title Decoration1.png`, `Title Decoration2.png`, `dot-spinner.png`, `line-edit-cross.png` (under `src/UI/UserScreen/`).
- SFX: `Game_AudioManager.sfx_ui_basic_blip_select.play()` on close.

## Behavior
- `_ready()` sets minimum sizes on the `ResetProgressConfirmationDialog`'s OK/Cancel buttons, hides the overlay, and probes `Settings.is_mobile()`:
  - On mobile: enables the bundled `OnscreenKeyboard` addon and removes focus from the `DisplayNameLineEdit` so the OS keyboard does not auto-pop; the on-screen keyboard is toggled manually via clicks on the input.
  - On desktop/non-mobile: text entry happens through the normal `LineEdit`.
- `_on_Settings_visibility_changed()` → `_initialize()` clears messages and pre-fills the line edit with `GameState.get_player_display_name()` every time the panel is shown.
- `_on_UpdateButton_pressed()` is a coroutine: empty input rejects with "A display name is required"; otherwise it calls `Analytics.get_players_by_display_name(name)`. If no other player owns the name (or the only match is this user's `identifier`), it calls `Analytics.update_player_display_name(name)` and flashes "Updated!". If taken, it flashes "Name taken!".
- `_unhandled_input` synthesises typed characters into the `LineEdit` while focus is suppressed (on mobile, so the virtual keyboard drives input directly).
- `_on_ResetProgressButton_pressed()` opens `ResetProgressConfirmationDialog`. On confirm, `GameState.reset_progress()` is called and "Progress reset!" flashes.

## Signals & Methods
- Signals: `on_closed`.

## Embedded controls
- `DisplayNameLineEdit`, `DisplayNameMessageLabel`, `UpdateButton`.
- `OverlayColorRect` (dimming while async name-check is in flight).
- `OnscreenKeyboard` (mobile-only addon).
- `ResetProgressConfirmationDialog` (`ConfirmationDialog`), `ResetProgressMessageLabel`, `ResetProgressButton`.
- `CloseButton`.
- See `_flow.md`.

## Dependencies
- Embedded in: `MainScreen`.
- Autoloads: `Settings`, `GameState`, `Analytics` (Talo backend), `Game_AudioManager`.

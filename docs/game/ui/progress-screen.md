# ProgressScreen

**Category:** UI / Screen
**Scene:** `src/UI/ProgressScreen/ProgressScreen.tscn`
**Script:** `src/UI/ProgressScreen/ProgressScreen.gd` (`class_name ProgressScreen`)
**Extends:** `Control`

## Purpose
Modal completion-stats panel. Shows whether the game has been completed, the player's total time and total deaths, plus a per-level breakdown (best time, deaths, submitted date) for the currently selected world. Embedded as a child of `MainScreen` and each `LevelSelect` scene; both instances scope themselves to one world via the exported `world` int.

## Assets
- No dedicated art folder; styles are pulled from the parent screen's theme (`control.theme.get_stylebox("title_button_normal", "Tree")` etc. — header style is the same as the Tree control used by leaderboards for visual parity).
- SFX: `Game_AudioManager.sfx_ui_basic_blip_select.play()` on close.

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `world` | `int` (1..3) | `1` | World whose levels are populated into the level grid. |

## Behavior
- `_ready()` builds a shared `StyleBoxFlat` for data cells, applies the Tree-derived header style to the two header panels, and populates the `StageOptionButton` with three world entries.
- `_on_visibility_changed()` → `_initialize()` runs every time the panel is shown: selects the option button to the exported world, then populates the two grids.
- `_populate_game_grid()` reads `GameState.has_completed_game()`, `GameState.level_results.get_total_deaths()`, and `get_total_completion_time()`. Time is formatted via `Stopwatch.get_time_as_formatted_string(..., Stopwatch.TimeFormat)`. Submitted-date column shows ISO `YYYY-MM-DD` derived from the unix-ms total when completed.
- `_populate_level_grid()` iterates the levels for the current world from `LevelData.get_levels_for_world(current_world)`, indexes into `GameState.level_results.get_level_result(level_index)`, and renders one row per level (with the last row labelled `Boss`). Levels with `completion_time == 0` render placeholder dashes.
- Grid rows are built procedurally via `_add_grid_cell(grid, text, width, centered, expand)` — each cell is a `Panel` with overridden `StyleBoxFlat` and an inner `Label` for shadowed text.
- `_on_StageOptionButton_item_selected` switches `current_world` and re-populates only the level grid.

## Signals & Methods
- Signals: `on_closed`.
- External method: setting `world` before showing.

## Embedded controls
- `GameProgressGrid`, `LevelProgressGrid` (procedural `GridContainer`s).
- `GameProgressHeaderPanel`, `LevelProgressHeaderPanel` with their header `Label`s.
- `StageOptionButton`, `CloseButton`.
- See `_flow.md`.

## Dependencies
- Embedded in: `MainScreen`, all three `LevelSelect` scenes (added at runtime by `LevelSelect._add_progress_screen()`).
- Autoloads: `GameState`, `LevelData`, `Stopwatch`, `Game_AudioManager`.

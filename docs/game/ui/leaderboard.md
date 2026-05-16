# Leaderboards (Game + Level)

**Category:** UI / Screen
**Scenes:**
- `src/UI/LeaderboardScreen/GameLeaderboardScreen.tscn` (whole-game leaderboard, embedded in `MainScreen`)
- `src/UI/LeaderboardScreen/LevelLeaderboardScreen.tscn` (per-level leaderboard, instanced at runtime by `LevelSelect`)

**Scripts:**
- `src/UI/LeaderboardScreen/GameLeaderboardScreen.gd` — `extends Control`
- `src/UI/LeaderboardScreen/LevelLeaderboardScreen.gd` (`class_name LevelLeaderBoardScreen`) — `extends Control`
- `src/UI/LeaderboardScreen/leaderboard_utils.gd` (`class_name LeaderboardUtils`) — static-only helper

**Extends:** `Control`

## Purpose
Talo-backed online leaderboard panels. `GameLeaderboardScreen` shows whole-game completion entries (total time + total deaths). `LevelLeaderboardScreen` lets the player pick any level in a world and shows per-level entries. Both render into a `Tree` and share the column setup + row population logic from `LeaderboardUtils`.

## Assets
- Loader animation: `LoaderAnimatedSprite` (visible while the async Analytics fetch is in flight).
- Resource: `game_level_buttongroup.tres` (a `ButtonGroup` for the level-tab radios — TBD which scene uses it).
- SFX: `Game_AudioManager.sfx_ui_basic_blip_select.play()` on close.

## Exported properties (`LevelLeaderboardScreen` only)
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `world` | `int` (1..3) | `1` | World whose levels populate `LevelOptionButton`. Set by `LevelSelect._add_level_leaderboard_screen()` at runtime. |

## Behavior
- Both panels run `_on_visibility_changed()` → `_initialize()` every time they appear.
- `_initialize()` calls `LeaderboardUtils.init_tree(tree)` to set up the columns (`Rank` / `Name` / `Time` / `Deaths` / `Submitted`) with fixed widths on cols 0–3 and expand on col 4. The fifth column is right-truncated to a 10-char ISO date (`updated_at.left(10)`).
- `GameLeaderboardScreen._load_game_entries()` does `yield(Analytics.get_game_leaderboard_entries(), "completed")`, then `LeaderboardUtils.populate_tree(...)` fills the rows. The loader sprite is shown for the duration via `_show_loading(true/false)`.
- `LevelLeaderboardScreen._populate_level_option_button()` builds the `OptionButton` items from `LevelData.get_levels_for_world(world)`, using the absolute level index (`(world - 1) * LevelData.LEVELS_PER_WORLD + index`) as the option id. `_load_selected_level()` reads the selected id and calls `Analytics.get_level_leaderboard_entries_for_level(level_index)`.
- Score is formatted via `Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat)`. Deaths come from `entry.get_prop("deaths").value`. Each row disables tooltips on every column.

## Signals & Methods
- Signals (both): `on_closed`.
- `LeaderboardUtils` helpers (static): `init_tree(tree) -> TreeItem`, `clear_tree(tree) -> TreeItem`, `populate_tree(tree, tree_root, entries_page)`, `add_entry_to_tree(tree, tree_root, entry)`.

## Embedded controls
- `Tree` (results), `LoaderAnimatedSprite` (loading state), `CloseButton`.
- `LevelOptionButton` (level screen only).
- See `_flow.md` for embedded-controls inventory.

## Dependencies
- Embedded in: `MainScreen` (game leaderboard) and every `LevelSelect` scene (level leaderboard, instanced at runtime).
- Autoloads: `Analytics`, `LevelData`, `Stopwatch`, `Game_AudioManager`.
- External: Talo SDK leaderboard entries (`TaloLeaderboardEntry`) — see `Analytics` autoload.

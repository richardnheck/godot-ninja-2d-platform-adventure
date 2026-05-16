# UI — Flow & Embedded Controls

## Screen navigation

```
SplashScreen
   ↓
StoryIntro (first launch)
   ↓
MainScreen ─────────────────────────────────────────┐
   ↓                                                 │
WorldSelect ──→ CaveLevelSelect / World2LevelSelect / World3LevelSelect
                       ↓
                    {Level scene}
                       ↓ (level cleared)
                   BossClearCutScene → next world's MainScreen / WorldSelect
                       ↓ (game end)
                   GameEndCutScene → GameCreditsScene → MainScreen
```

Side branches (reachable from MainScreen):
- `Settings`
- `ProgressScreen`
- `UserScreen`
- `GameLeaderboardScreen` / `LevelLeaderboardScreen`

Each level's intro plays `BossintroCutScene` if it is a boss level. Cutscene flow is handled in the parent level via `CutSceneBase`.

## Embedded controls reference

These controls are NOT documented as their own files. Each appears in the **Dependencies** section of the parent screen/level/cutscene that embeds it.

| Control / Overlay | Path | Embedded in |
|-------------------|------|-------------|
| `BackButton`, `BigBackButton`, `CloseButton` | `src/UI/Controls/BackButton.tscn` etc. | All screens with a back arrow |
| `MainPlayButton`, `PlayButton`, `PausedPlayButton` | `src/UI/Controls/...` | MainScreen, pause overlays |
| `QuitButton` | `src/UI/Controls/QuitButton.tscn` | MainScreen, MainScreen pause |
| `RetryButton` | `src/UI/Controls/RetryButton.tscn` | Level pause overlay |
| `SettingsButton` | `src/UI/Controls/SettingsButton.tscn` | MainScreen, WorldSelect |
| `LevelSelectButton` | `src/UI/Controls/LevelSelectButton.tscn` | CaveLevelSelect, World2LevelSelect, World3LevelSelect |
| `ChangeSceneButton` | `src/UI/Controls/ChangeSceneButton.tscn` | Cutscenes, navigation between screens |
| `SkipButton` | `src/UI/Controls/SkipButton/SkipButton.tscn` | All cutscenes |
| `ContinueButton` | `src/UI/Controls/ContinueButton/ContinueButton.tscn` | Story intro and game end cutscenes |
| `MusicButton`, `SoundButton` | `src/UI/Controls/...` and `src/UI/Settings/...` | MainScreen, Settings |
| `OnOffButton` | `src/UI/Settings/OnOffButton.tscn` | Settings |
| `TouchScreenControlsOnOffButton` | `src/UI/Settings/...` | Settings (mobile only) |
| `MusicVolumeSlider`, `SoundFxVolumeSlider` | `src/UI/Settings/...` | Settings |
| `LoadingIndicator` | `src/UI/Controls/LoadingIndicator/LoadingIndicator.tscn` | LeaderboardScreen and any async-loading screen |
| `FadeScreen` (CanvasLayer transition) | `src/UI/FadeScreen.tscn` | Documented in [../systems/frameworks.md](../systems/frameworks.md); embedded by main screens for transitions |
| `MobileControlsHUD` | `src/UI/MobileControlsHUD.tscn` | Documented in [../levels/level-base.md](../levels/level-base.md); shown during gameplay on touch devices |
| `LevelTimer` | `src/UI/LevelTimer.tscn` | Documented in [../levels/level-base.md](../levels/level-base.md) |
| `LevelIntroTitle` | `src/UI/LevelIntroTitle.tscn` | Documented in [../levels/level-base.md](../levels/level-base.md) — shown on level load |
| `DebugConsole`, `DebugLog` | `src/UI/Debug/*` | Documented in [../systems/autoloads.md](../systems/autoloads.md) (DebugLog is autoloaded) |
| `Global.tscn` (scene navigation singleton) | `src/UI/Global.tscn` | Intentionally undocumented per plan |
| `TemporaryEndScene` | `src/UI/TemporaryEndScene.tscn` | Dropped per plan — placeholder no longer used |

## Theming

Each world has its own UI theme:
- `assets/themes/cave-level/` — World 1
- `assets/themes/world2/` — World 2
- `assets/themes/world3/` — World 3
- `assets/themes/main/`, `pause/`, `settings/` — shared menu themes

Themes are Godot `Theme` resources; screens reference them via the `theme` property.

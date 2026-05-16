# Conventions

## Doc template

Every component file follows this template. Target 40–80 lines per file. Trivial wrappers can be ~20 lines.

```markdown
# {ComponentName}

**Category:** {e.g. Enemy / PathFollow, Object / Hazard, UI / Screen, System / Autoload}
**Scene:** `src/path/to/Thing.tscn`
**Script:** `src/path/to/Thing.gd`
**Extends:** `KinematicBody2D` | `Area2D` | `Node2D` | ...

## Purpose
One or two sentences.

## Assets
- Sprite(s): `assets/art/.../sprite.png`
- SFX: `Game_AudioManager.sfx_*`
- Particles / shaders / other resources

## Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `prop_name` | int | 0 | What it controls |

## Behavior
Concise bullet list or short state diagram.

## Player interaction
What happens on contact / proximity / input.

## Signals
- `signal_name(args)` — when emitted, who listens.

## Dependencies
- Other components/scenes this one instances or messages.
- For screens/levels: the smaller controls/overlays they embed.
```

Mark anything unclear as `TBD — <reason>`. Do not invent behavior.

## Categories

### Enemies
- **PathFollow** — moves along a Path2D / PathFollow2D using a tween, or is stationary (basic types fold here too).
- **Patrol** — back-and-forth or trigger-and-charge along a horizontal line; not Path2D-driven.
- **Chaser** — homes on the player when in range.
- **Jumper** — gravity-driven hops with wall/floor raycast turnaround.
- **Thrower** — stationary, throws projectiles at the player.
- **Boss** — multi-phase, multi-attack, world-ending arena enemy.

### Objects
- **Hazard** — kills or damages the player on contact.
- **Platform** — surface the player can stand on (static, moving, destructible, conveyor, etc.).
- **Interactive** — player triggers a response (spring, switch, sign, checkpoint, boat, key).
- **Door** — gates progression; opens via state change.
- **Decoration** — purely visual, no gameplay logic.
- **Camera** — affects the level camera (follow, shake, area-based overrides).
- **Tutorial** — onboarding markers and panels.
- **Test** — debug/test scenes not used in shipping levels.

### UI
- **Screen** — a top-level scene the player navigates to.
- **Cutscene** — a non-interactive narrative scene; extends CutSceneBase.

### Systems
- **Autoload** — registered in `project.godot` and globally available.
- **Framework** — utility helper used by other components (Physics2D, easing, etc.).
- **Config** — `project.godot` data (input map, collision layers, etc.).

## Consolidation rules

These rules avoid one-file-per-thing sprawl. The plan in `~/.claude/plans/i-am-going-to-ticklish-lighthouse.md` is the source of truth.

- **Player owns the FSM.** `player/player.md` covers the controller, the state machine, every state (idle/move/jump/air-jump/wall-slide/wall-jump/die/die-by-water/celebrate/talk), and the shared character bases (`Character.gd`, `Character2.gd`, `DamageZone.gd`, `commons/states/*`). There is no separate `characters/` folder.
- **Coin is unused** and is not documented.
- **Gem and DemonSeal** are cutscene-only and live in `ui/cutscenes/cutscene-items.md`.
- **KamonKey** is gameplay-interactive — it lives under `objects/interactive/`.
- **Basic stationary enemies** (SimpleEnemy, OneEyedSpikey, LaserLantern, CreepyCrawly) live under `enemies/path-follow/`.
- **Mini-bosses are standard enemies.** CaveLevelMiniBoss is a jumper; WanyudoMini is documented inline in `wanyudo.md`.
- **Projectiles are inline** in the enemy/boss that spawns them — never a standalone file.
- **UI controls are referenced, not documented.** Buttons, sliders, toggles, FadeScreen, MobileControlsHUD, LevelTimer, LevelIntroTitle, DebugConsole, etc. appear in the **Dependencies** section of the screen/level that uses them.
- **Object variants group together.** One `electricity.md` covers BlueFlame/MegamanElectricity/ElectricityBeam; one `moving-platforms.md` covers Base/Vertical/Cave1H/Cave2H; one `decorations.md` covers JapaneseLamp/SmallLantern/WaterSplash; one `guns.md` covers all test weapons.
- **Systems are grouped.** `autoloads.md` (one section per singleton), `frameworks.md` (helpers + FadeScreen utility), `project-config.md` (`project.godot`).
- **Cutscenes group by type.** `boss-intro-cutscenes.md` and `boss-clear-cutscenes.md` cover all three worlds inline.
- **Tilemaps & tilesets live in `levels/tilemaps/`.** Per-level docs only list which tilesets they use; tileset detail (atlas region, collision, autotile, animation) lives in the tilemap docs.

## Naming

- Folder names are lower-kebab-case.
- File names are lower-kebab-case of the component name (e.g. `KasaObake.tscn` → `kasa-obake.md`).
- Boss levels are `boss-level.md` in each world folder.

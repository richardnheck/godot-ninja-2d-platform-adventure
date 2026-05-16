# Godot → Defold Port Documentation

This tree documents every gameplay-relevant component of `godot-ninja-2d-platform-adventure` (Godot 3) so a future agent can port them to Defold one at a time without re-reading the whole codebase.

**Documentation is Godot-only.** It describes what each component is and how it behaves today. Translating those descriptions into Defold equivalents is the porting agent's job.

## How to read this tree

- Start with [conventions.md](conventions.md) for the doc template, the category vocabulary, and the consolidation rules.
- Then jump to the area you're porting. Each component has a single concise file (40–80 lines).
- Variants and projectiles are documented inline in their parent file — there is no `projectiles/` folder.
- UI buttons, sliders, toggles, HUD overlays and other reusable widgets are referenced from the screens/levels that embed them; they do not get their own files.

## Index

### Player
- [player/player.md](player/player.md) — controller, state machine, every state, shared character base
- [player/effects.md](player/effects.md) — jump, air-jump, landing-dust visual effects

### Enemies
- [enemies/_category-overview.md](enemies/_category-overview.md) — taxonomy
- [enemies/path-follow/](enemies/path-follow/) — base + 15 enemies (incl. basic stationary types)
- [enemies/jumpers/](enemies/jumpers/) — Daruma, KasaObake, TsurubeOtoshi, CaveLevelMiniBoss
- [enemies/patrol/](enemies/patrol/) — Shirime, Hannya, Fly
- [enemies/chasers/](enemies/chasers/) — Nekekubi
- [enemies/throwers/](enemies/throwers/) — TofuKozo
- [enemies/bosses/](enemies/bosses/) — Wanyudo, AoAndon, CaveLevelBoss

### Objects
- [objects/_category-overview.md](objects/_category-overview.md)
- [objects/hazards/](objects/hazards/) — 11 hazards (incl. [Cannon](objects/hazards/cannon.md), split electricity docs)
- [objects/platforms/](objects/platforms/) — 7 platforms (incl. grouped moving-platforms)
- [objects/interactive/](objects/interactive/) — Spring, HelpSign, ClockSwitch, Boat, Checkpoint, KamonKey
- [objects/doors/](objects/doors/) — CaveDoor, CaveSlidingDoor
- [objects/decoration/decorations.md](objects/decoration/decorations.md)
- [objects/camera/](objects/camera/) — CameraManager, CameraAdjustArea, ScreenShake
- [objects/tutorial/jump-dot.md](objects/tutorial/jump-dot.md)

### Levels
- [levels/level-base.md](levels/level-base.md) — LevelBase + LevelCamera + LevelMetrics + helpers
- [levels/tilemaps/](levels/tilemaps/) — tile size, layer pattern, per-world tileset references
- [levels/world1-cave/](levels/world1-cave/) — 6 levels + boss
- [levels/world2/](levels/world2/) — 6 levels + boss
- [levels/world3/](levels/world3/) — 6 levels + boss

### UI
- [ui/_flow.md](ui/_flow.md) — screen-to-screen navigation
- Screens: splash, story intro, main, world/level select, settings, progress, user, credits, leaderboard
- [ui/cutscenes/](ui/cutscenes/) — base, story intro, game end, boss intros/clears, cutscene items (Gem, DemonSeal)

### Systems
- [systems/autoloads.md](systems/autoloads.md) — every autoload singleton
- [systems/frameworks.md](systems/frameworks.md) — Physics2D, Momentum, ArrayUtil, Ease, IntegerResolutionHandler, FadeScreen
- [systems/project-config.md](systems/project-config.md) — autoloads, input map, collision layers, groups

### Assets
- [assets/overview.md](assets/overview.md) — folder layout and naming

# Cutscene Items — Gem & DemonSeal

Two collectibles that only appear inside cutscenes. They live under `src/objects/` in the source tree but the user explicitly grouped them here because shipping levels do not place them — they are exclusive to the boss-clear cutscenes.

---

## Gem

**Scene:** `src/objects/Gem.tscn`
**Script:** `src/objects/Gem.gd`
**Extends:** `Area2D`

### Purpose
Collectible jewel shown in cutscenes. On player contact, plays a sparkle effect + a collect sound, emits `gem_grabbed`, and frees itself.

### Assets
- Sprite: `assets/art/props/collectibles/GemsAndHearts.png`
- Sparkle effect: `assets/art/effects/multi_sparkle_puff/frames/` (66 frames)
- SFX: same stream as `Game_AudioManager.sfx_collectibles_demon_seal` (`assets/sounds/sfx/collectibles/demon_seal.wav`) played via the local `$EffectSound` AudioStreamPlayer (NOT the global manager — see TBD).

### Exported properties
None.

### Behavior
- `_ready()` starts a continuous bob: `$Tween` interpolates `$CollisionShape2D.position` between `Vector2(0,0)` and `Vector2(0,-4)` over 1 s, `TRANS_SINE`. The `_on_tween_completed` callback inverts `tween_values` and restarts (perpetual loop).
- `_on_Gem_body_entered(body)`: if `body.is_in_group(Constants.GROUP_PLAYER)`:
  1. emits `gem_grabbed`
  2. `collisionShape.set_deferred("disabled", true)` (one-shot grab)
  3. hides `$CollisionShape2D/Sprite`
  4. `$EffectAnimation.play()` (the sparkle puff)
  5. `$EffectSound.play()`
- `_on_EffectAnimation_animation_finished()` → `queue_free()`.

### Signals
- `gem_grabbed` — listened by the boss-clear cutscene (or the level if Gem were placed in one).

### Dependencies
- None at runtime beyond `Constants.GROUP_PLAYER`. TBD — the sound stream is loaded into a local `AudioStreamPlayer` node in the .tscn rather than the global `Game_AudioManager`; verify whether the cutscene uses the gem instance's local stream or substitutes its own.

---

## DemonSeal

**Scene:** `src/objects/demon-seal/DemonSeal.tscn`
**Script:** `src/objects/demon-seal/DemonSeal.gd` (`class_name DemonSeal`)
**Extends:** `Node2D`

### Purpose
Coloured seal that the player grabs (or that a cutscene places on an altar). Three colour variants. Optional bob hover. Has both a grab-effect and a separate placed-on-altar effect.

### Assets
- Sprite atlas: AnimatedSprite with animations `blue`, `green`, `red` (each is a separate animation in the SpriteFrames resource).
- SFX:
  - `Game_AudioManager.sfx_collectibles_demon_seal` (`assets/sounds/sfx/collectibles/demon_seal.wav`) — on grab.
  - `Game_AudioManager.sfx_collectibles_place_demon_seal` (`assets/sounds/sfx/collectibles/place-demon-seal.wav`) — on `place()` call from a cutscene.

### Exported properties
| Name | Type | Default | Notes |
|------|------|---------|-------|
| `colour` | `enum {BLUE=0, GREEN=1, RED=2}` | `BLUE` | Selects which AnimatedSprite animation plays (blue/green/red). |
| `hover` | `bool` | `true` | Enables the bob tween. |

### Behavior
- `_ready()` hides `$EffectAnimation` and `$PlacedEffectAnimation` (both shown later on demand), sets sprite animation by colour, and (if `hover`) calls `_start_tween()`.
- Bob: `$Tween` interpolates `position` between `global_position` and `global_position + Vector2(0, -4)` over 1.5 s with `TRANS_SINE`, looping forever via `_on_tween_completed` flipping the endpoints.
- `_on_body_entered(body)`: if body is in `GROUP_PLAYER`, calls `grab_seal()`.
- `grab_seal()`: emits `demon_seal_grabbed`, disables collision, hides the sprite, shows + plays `$EffectAnimation`, plays `sfx_collectibles_demon_seal`. After the effect animation finishes the node `queue_free()`s.
- `place()`: cutscene-callable. Sets `visible = true`, shows + plays `$PlacedEffectAnimation`, plays `sfx_collectibles_place_demon_seal`. Used by the boss-clear sequence to drop the seal onto an altar.

### Signals
- `demon_seal_grabbed` — listened by the cutscene script.

### Dependencies
- [../../systems/autoloads.md](../../systems/autoloads.md) — `Constants.GROUP_PLAYER`, `Game_AudioManager.sfx_collectibles_demon_seal` and `sfx_collectibles_place_demon_seal`.
- [boss-clear-cutscenes.md](boss-clear-cutscenes.md) — the cutscene that places this on the altar.

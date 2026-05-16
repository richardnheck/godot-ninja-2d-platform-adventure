# Player Effects

Three single-shot `AnimatedSprite`-based visual effects spawned by the player controller. Each plays its only animation and then `queue_free()`s itself via `animation_finished`.

## JumpEffect

**Scene:** `src/characters/player/effects/jump/JumpEffect.tscn`
**Script:** `src/characters/player/effects/jump/JumpEffect.gd`
**Extends:** `AnimatedSprite`
**Sprite:** `src/characters/player/effects/jump/jump.png`

Spawned by `player_controller.gd::on_jump()` at `(player.x + 8, player.y)`. Used on initial ground jump. Also used by `WallJump` state, where it is rotated `±90°` and offset `±6 px` toward the wall.

## AirJumpEffect

**Scene:** `src/characters/player/effects/air-jump/AirJumpEffect.tscn`
**Script:** `src/characters/player/effects/air-jump/AirJumpEffect.gd`
**Extends:** `AnimatedSprite`
**Sprite:** `src/characters/player/effects/air-jump/air-jump-sprite-sheet.png`

Spawned by `player_controller.gd::on_air_jump()` at the player's `global_position`. Used on double jump only.

## LandingDust

**Scene:** `src/characters/player/effects/landing-dust/LandingDust.tscn`
**Script:** `src/characters/player/effects/landing-dust/LandingDust.gd`
**Extends:** `AnimatedSprite`
**Sprite frames:** `landing-dust1.png` through `landing-dust7.png` (7 individual PNGs).

Spawned by `player_controller.gd::do_landing()` at the player's `global_position` on ground-landing (called from motion-state `detect_and_transition_to_ground` and `Move.update`).

## Lifecycle

Each effect script is identical in shape:
```gdscript
func _ready():
    play()                       # play the default/only animation
    connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
    queue_free()
```

## Dependencies
- Instanced as siblings of the player by `player_controller.gd` (`get_parent().add_child(instance)`).
- No interaction with other components.

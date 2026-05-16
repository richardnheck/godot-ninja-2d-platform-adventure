# Spring

**Category:** Object / Interactive
**Scene:** `src/objects/springy-things/Spring.tscn`
**Script:** `src/objects/springy-things/Spring.gd`
**Extends:** `Area2D`

## Purpose
A floor-mounted bouncy pad that launches the player upward when they land on it. Uses the player's spring-jump impulse path through the FSM so coyote/buffer rules still apply.

## Assets
- Sprite atlas: `src/objects/springy-things/SpringSpriteSheet.png` (`default` 1f @ 5fps, `launch` 3f @ 15fps)
- Guide sprite (decorative dotted vertical line shown above the spring): `src/objects/springy-things/GuideSpriteSheet.png` (`default` 4f @ 8fps)
- SFX: `Game_AudioManager.sfx_env_spring_boing`

## Exported properties
None. The launch strength is a constant.

| Constant | Value | Notes |
|----------|------:|-------|
| `impulse` | `135` | Upward impulse magnitude passed to `player.spring()` as `Vector2(0, impulse)` |

## Behavior
- Single `Area2D` root with a small rectangle `CollisionShape2D` (extents 5 x 2.5 at y=-2.5).
- On `body_entered`, checks that the body is in `Constants.GROUP_PLAYER` AND that it `has_method("spring")`. If so:
  1. Plays `sfx_env_spring_boing`.
  2. Calls `player.spring(Vector2(0, impulse))` (see below).
  3. Plays the `launch` animation on `AnimatedSprite`.
- When the `launch` animation finishes, swaps `animation` back to `"default"`.
- `VisibilityEnabler2D` is configured with `process_parent` and `physics_process_parent` true — the spring (and its `Line2D` guide) pauses off-screen.

## Player interaction
Method-style trigger — the spring does not push the player directly. It calls `player.spring(spring_impulse)` on the controller. Player FSM behaviour:
- `_change_state("jump", spring_impulse)` is invoked, pushing `Jump` onto the state stack.
- `Jump.initialize()` adds `spring_impulse.y` to the standard `jump_power` so the player launches higher than a regular jump.
- The Jump state suppresses double-jump detection when triggered by a spring (it only allows air-jump after a real player jump).

## Signals
None.

## Dependencies
- [systems/autoloads.md](../../systems/autoloads.md) — `Game_AudioManager`, `Constants.GROUP_PLAYER`.
- [player/player.md](../../player/player.md) — `player.spring(impulse)` controller method and `Jump` state.

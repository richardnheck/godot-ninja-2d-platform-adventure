# JumpDot

**Category:** Object / Tutorial
**Scene:** `src/objects/tutorial/JumpDot.tscn`
**Script:** none.
**Extends:** `Node2D`

## Purpose
A small visual onboarding marker placed in early World 1 levels to suggest a jump arc — a row of dots the player follows to learn the basic jump trajectory. Pure decoration.

## Assets
- Sprite: `src/objects/tutorial/jump-dot.png` (single-frame, used as the `default` SpriteFrames animation at 5 fps).

## Scene structure
```
JumpDot (Node2D)
  AnimatedSprite (frames = SpriteFrames with one frame, not autoplaying)
```

## Exported properties
None.

## Behavior
- No script. No collision. No signals.
- The `AnimatedSprite` has a single-frame `default` animation. `playing` is not set, so the sprite simply renders the one frame.
- Levels place multiple instances of `JumpDot` in a curve to trace a jump arc.

## Player interaction
None — the player walks past these.

## Signals
None.

## Dependencies
None.

## Notes / TBD
- `JumpDot.tscn` has only one frame defined; there is no animation playback to worry about during the port. A static `Sprite2D` would be equivalent in Godot 4.

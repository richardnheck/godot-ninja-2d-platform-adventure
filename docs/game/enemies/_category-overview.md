# Enemies — Category Overview

All enemies live in `src/characters/enemies/**`. They use Godot's KinematicBody2D + Area2D pattern with `move_and_slide` for physics, AnimatedSprite for visuals, and the `Game_AudioManager` singleton for sound.

Most enemies kill the player on contact via an Area2D child connected to a `body_entered` signal that calls `player.die()`. Some shoot or drop projectiles that do the same.

## Categories

| Category | Folder | Count | Defining trait |
|----------|--------|------:|----------------|
| PathFollow | [path-follow/](path-follow/) | 15 | Moves along a Path2D + PathFollow2D using a tween (or sits stationary). Includes "basic stationary" enemies (SimpleEnemy, OneEyedSpikey, LaserLantern, CreepyCrawly) which fold into this category because they share the same general pattern of "spawn, animate, kill on touch". |
| Jumpers | [jumpers/](jumpers/) | 4 | Gravity-driven hops with wall/floor raycast turnaround. CaveLevelMiniBoss is a jumper (mini-boss = standard enemy). |
| Patrol | [patrol/](patrol/) | 3 | Back-and-forth or trigger-and-charge motion that is NOT Path2D-driven. |
| Chasers | [chasers/](chasers/) | 1 | Homes on the player when in detection range. |
| Throwers | [throwers/](throwers/) | 1 | Stationary, throws RigidBody2D projectiles at the player. |
| Bosses | [bosses/](bosses/) | 3 | Multi-phase, multi-attack arena enemies. Each boss describes its projectiles and spawned minions inline. |

## Shared base classes

- **PathFollowEnemyBase** — Common Path2D / PathFollow2D / Tween rig used by everything under `path-follow/`. See [path-follow/path-follow-base.md](path-follow/path-follow-base.md).
- **SimpleEnemy** — Minimal "stand and kill on contact" base used by OneEyedSpikey and others. See [path-follow/simple-enemy.md](path-follow/simple-enemy.md).

## Projectiles

Projectiles are NOT documented in a separate folder. Each is described inline in the enemy/boss that spawns it:

- **Wanyudo** owns NormalFireball, HomingFireball, WanyudoMini, FallingMiniWanyudoArray.
- **AoAndon** owns NormalBlueFireball, AoAndonShardLantern, LanternArray, FallingCandle (homing variant).
- **CaveLevelBoss** owns SlamBlast, BossFallingSpikeArray.
- **CaveLevelMiniBoss** owns MiniBossSlamBlast.
- **ChochinObakeShooter** owns FallingCandle.
- **ShardLantern** owns Shard.
- **TofuKozo** owns Tofu.

## Damage model

There is no enemy HP. The player has no attack — all collisions are one-way (enemy → kill player). Some enemies (CaveLevelBoss) are killed by checkpoint/cutscene triggers, not by player action.

`Game_AudioManager` exposes per-enemy SFX (e.g. `sfx_env_hannya_scream`, `sfx_env_kasa_obake_jump`) referenced from each enemy doc.

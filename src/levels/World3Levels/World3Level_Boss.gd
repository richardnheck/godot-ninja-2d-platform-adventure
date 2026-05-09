# World 3 - Boss Level (Ao Andon)
# ---------------------------------
extends LevelBase

onready var boss := $AoAndon;
onready var ceiling_position := $CeilingPosition2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pass the boss a reference to the player
	boss.set_player(player)
	boss.set_ceiling_position(ceiling_position)
	
	Game_AudioManager.play_bgm_world3_level_boss()
	
	if spawned_at_checkpoint:
		# The player died, but spawned at the checkpoint.
		# Set the boss at a position just behind the player
		# This number was visually determined by adjusting the boss PathFollow2D unit offset 
		if LevelData.level_checkpoint_reached == "1":
			yield(get_tree().create_timer(0.1), "timeout")
			boss.set_spawn_offset(0.45)
		elif LevelData.level_checkpoint_reached == "2":
			yield(get_tree().create_timer(0.1), "timeout")
			boss.set_spawn_offset(0.7118)
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		boss.set_spawn_offset(0.006)  # So AoAndon appears on the screen at the start
		
func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# handle level completion stuff such as analytics and progress
		# NB: this updates the game state progress level index so that player will have completed the game
		._handle_boss_level_complete()
	
		Analytics.track_game_completions()
		Analytics.track_event_game_completed()
		Analytics.add_game_leaderboard_entry(GameState.level_results.get_total_completion_time(),GameState.level_results.get_total_deaths())
			
		LevelData.goto_boss_clear_cutscene(LevelData.WORLD3, true)

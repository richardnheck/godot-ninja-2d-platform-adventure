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
		yield(get_tree().create_timer(0), "timeout")
		boss.set_spawn_offset(0.45)


func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Determine if player has already completed the game
		# We are calling this here before the progress is updated otherwise we can't tell if this is the first time completing the game
		var has_completed_game = GameState.has_completed_game()
		
		# handle level completion stuff such as analytics and progress
		# NB: this updates the game state progress level index so that player will have completed the game
		._handle_boss_level_complete()
		
		# Player has completed the game
		if not has_completed_game:
			print("GAME COMPLETED!")
			# This is the first time player completes the game	
			# Track game completion
			Analytics.track_game_completions()
			Analytics.track_event_game_completed()
		else:
			print("Game already completed!")
			
		LevelData.goto_boss_clear_cutscene(LevelData.WORLD3, true)

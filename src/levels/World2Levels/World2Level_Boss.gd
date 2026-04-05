# World 2 - Boss Level (Wanyudo)
# ---------------------------------
extends LevelBase

onready var boss := $Wanyudo;
onready var ceiling_position := $CeilingPosition2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Pass the boss a reference to the player
	boss.set_player(player)
	boss.set_ceiling_position(ceiling_position)
		
	Game_AudioManager.play_bgm_world2_level_boss()
	
	if spawned_at_checkpoint:
		# The player died, but spawned at the checkpoint.
		# Set the boss at a position just behind the player
		# This number was visually determined by adjusting the boss PathFollow2D unit offset 
		yield(get_tree().create_timer(0), "timeout")
		boss.set_spawn_offset(0.44)


func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		._handle_boss_level_complete()
		LevelData.goto_boss_clear_cutscene(LevelData.WORLD2, true)

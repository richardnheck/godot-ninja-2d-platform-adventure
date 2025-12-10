# World 3 - Boss Level (Ao Andon)
# ---------------------------------
extends LevelBase

onready var boss := $AoAndon;
onready var ceiling_position := $CeilingPosition2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("World3 - Boss Scene: ready()")
	
	# Pass the boss a reference to the player
	boss.set_player(player)
	
	boss.set_ceiling_position(ceiling_position)
	#boss.connect("state_cycle_finished", self, "_on_boss_state_cycle_finished")
	
	Game_AudioManager.play_bgm_cave_level_boss()

	if spawned_at_checkpoint:
		print("Spawned at checkpoint")
		# The player died, but spawned at the checkpoint.
		# Set the boss at a position just behind the player
		# This number was visually determined by adjusting the boss PathFollow2D unit offset 
		yield(get_tree().create_timer(0), "timeout")
		boss.set_spawn_offset(0.45)


func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		get_tree().change_scene("res://src/UI/CutScenes/World3/BossClearCutScene.tscn")

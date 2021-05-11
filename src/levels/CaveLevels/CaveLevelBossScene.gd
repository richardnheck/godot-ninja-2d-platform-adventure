extends LevelBase

onready var boss:KinematicBody2D = $Boss;


var boss_speed = 20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boss Scene: ready()")
	
	# Pass the boss a reference to the player
	boss.set_player(player)
	boss.connect("state_cycle_finished", self, "_on_boss_state_cycle_finished")
	
	Game_AudioManager.play_bgm_cave_level_boss()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	var ap = boss.position.distance_to(player.position)
#	print(ap)
#	if ap > 0:
#		boss.direction = 1
#	elif ap < 0:
#		boss.direction = -1
#	else:
#		boss.direction = 0
	var ap = boss.position.direction_to(player.position)
	if ap.x > 0:
		boss.direction = 1
		boss.set_sprite_animation("look-right")
	elif ap.x < 0:
		boss.direction = -1
		boss.set_sprite_animation("look-left")
	else:
		boss.direction = 0
#
	#if boss.direction_to(player):
		#pass

var next_boss_state = null

func _on_FallingSpikesArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		next_boss_state = "updown_slam"


func _on_FallingSpikesArea_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		next_boss_state = "run_and_jump"

func _on_boss_state_cycle_finished(state) -> void:
	print("boss state cycle finished: " + state)
	if next_boss_state != null:
		boss.set_state(next_boss_state)
		next_boss_state = null

func _on_Door_player_entered() -> void:
	player.celebrate();
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://src/UI/CutScenes/CaveLevel/BossClearCutScene.tscn")


func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		get_tree().change_scene("res://src/UI/CutScenes/CaveLevel/BossClearCutScene.tscn")

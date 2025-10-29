extends LevelBase

onready var boss := $Wanyudo;
onready var ceiling_position := $CeilingPosition2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Boss Scene: ready()")
	
	# Pass the boss a reference to the player
	boss.set_player(player)
	boss.set_ceiling_position(ceiling_position)
	#boss.connect("state_cycle_finished", self, "_on_boss_state_cycle_finished")
	
	Game_AudioManager.play_bgm_cave_level_boss()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

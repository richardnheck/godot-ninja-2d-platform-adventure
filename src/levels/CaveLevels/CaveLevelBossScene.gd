extends LevelBase

onready var boss:KinematicBody2D = $Boss;


var boss_speed = 20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boss Scene: ready()")
	#._ready()
	
	


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
	elif ap.x < 0:
		boss.direction = -1
	else:
		boss.direction = 0
#
	#if boss.direction_to(player):
		#pass

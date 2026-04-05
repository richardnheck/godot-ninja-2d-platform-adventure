class_name LanternArray
extends Node2D

export var init_delay = 0
signal finished

onready var spawner1 := $LanternSpawner1
onready var spawner2 := $LanternSpawner2
onready var spawner3 := $LanternSpawner3

const total_spawners = 3
var spawn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner1.position.x + rand_range(-10,10)
	spawner2.position.x + rand_range(-20,20)	# So it isn't always above the player
	spawner3.position.x + rand_range(-10,10)
	spawner1.delay_time = 0	# Always want the one in front of the player to fall first
	spawner2.delay_time = rand_range(0.3,1.3)
	spawner3.delay_time = rand_range(0.3,1.3)
	spawner1.set_ready()
	spawner2.set_ready()
	spawner3.set_ready()
	
	yield(get_tree().create_timer(init_delay), "timeout")
	trigger()

func get_width() -> float:
	return $WidthMeasurement.shape.extents.x

func trigger() -> void:
	# Trigger the spawners in different orders and timing
	pass
#	var falling_spikes = get_tree().get_nodes_in_group("falling_spike")
#	for falling_spike in falling_spikes:
#		if(falling_spike):
#			falling_spike.trigger()	
#			yield(get_tree().create_timer(0.3), "timeout")
#
#	# Wait a moment after the spikes have all been dropped
#	#yield(get_tree().create_timer(0.), "timeout")
#	emit_signal("finished");	


func _on_LanternSpawner_spawned_object():
	spawn_count = spawn_count + 1
	
	# Removing the array once all of them have spawned
	if spawn_count == total_spawners:
		queue_free()

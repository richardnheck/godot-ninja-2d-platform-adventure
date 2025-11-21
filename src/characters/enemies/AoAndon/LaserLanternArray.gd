class_name LaserLanternArray
extends Node2D

export var init_delay = 0
signal finished

onready var spawner1 := $LaserLanternSpawner1
onready var spawner2 := $LaserLanternSpawner2
onready var spawner3 := $LaserLanternSpawner3

const total_spawners = 3
var spawn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(init_delay), "timeout")
	trigger()

func get_width() -> float:
	return $WidthMeasurement.shape.extents.x

func trigger() -> void:
	# Trigger the spawners in different orders and timing
	pass
#	print("trigger spikes")
#	var falling_spikes = get_tree().get_nodes_in_group("falling_spike")
#	for falling_spike in falling_spikes:
#		if(falling_spike):
#			falling_spike.trigger()	
#			yield(get_tree().create_timer(0.3), "timeout")
#
#	# Wait a moment after the spikes have all been dropped
#	#yield(get_tree().create_timer(0.), "timeout")
#	emit_signal("finished");	


func _on_LaserLanternSpawner_spawned_object():
	spawn_count = spawn_count + 1
	
	# Removing the array once all of them have spawned
	if spawn_count == total_spawners:
		queue_free()

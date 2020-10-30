extends Node2D

export var init_delay = 0
signal finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(init_delay), "timeout")
	trigger()

func get_width() -> float:
	return $WidthMeasurement.shape.extents.x

func trigger() -> void:
	print("trigger spikes")
	var falling_spikes = get_tree().get_nodes_in_group("falling_spike")
	for falling_spike in falling_spikes:
		if(falling_spike):
			falling_spike.trigger()	
			yield(get_tree().create_timer(0.3), "timeout")
	
	# Wait a moment after the spikes have all been dropped
	#yield(get_tree().create_timer(0.), "timeout")
	emit_signal("finished");	

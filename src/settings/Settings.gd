extends Node

signal controls_changed

var touch_screen_controls_visible:bool = true setget set_touch_screen_controls_visible, get_touch_screen_controls_visible

func set_touch_screen_controls_visible(new_value) -> void: 
	touch_screen_controls_visible = new_value
	emit_signal("controls_changed")

func get_touch_screen_controls_visible() -> bool:
	return touch_screen_controls_visible 
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

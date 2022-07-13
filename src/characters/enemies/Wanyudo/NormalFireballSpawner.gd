extends Gun

signal fireball_destroyed

var enabled:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called manually by the parent to shoot when in NORMAL mode
func shoot():
	if enabled:
		_shoot()


# Called internally when in TIMED mode
func _shoot():
	# Call parent shoot
	var fireball = ._shoot()
	print("Fireball pos", fireball.global_position)
	fireball.connect("destroyed", self, "_on_fireball_destroyed")


func _on_fireball_destroyed():
	emit_signal("fireball_destroyed")
	

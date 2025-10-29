extends Gun

signal fireball_destroyed

var enabled:bool = false setget _set_enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_enabled(value) -> void:
	enabled = value
	if enabled && _shoot_timer.is_stopped():
		_shoot()

# Called manually by the parent to shoot when in NORMAL mode
func shoot():
	if enabled:
		_shoot()


# Called internally when in TIMED mode
func _shoot():
	if enabled:
		# Call parent shoot
		print_debug("NormalFireBallSpanwer: _shoot()")
		var fireball = ._shoot()	
		fireball.connect("destroyed", self, "_on_fireball_destroyed")
		
func _on_fireball_destroyed():
	emit_signal("fireball_destroyed")

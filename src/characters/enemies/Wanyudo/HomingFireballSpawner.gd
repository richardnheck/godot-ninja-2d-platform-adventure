extends Gun

signal fireball_destroyed
signal force_destroy

# Determmines whether homing fireball missile is homing or not
# Set false for just a fireball missile targeted at the player
var homing:bool = true
var enabled:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called manually by the parent to shoot when in NORMAL mode
func shoot():
	if enabled:
		_shoot()


# Called internally when in TIMED mode
func _shoot():
	if enabled:
		# Call parent shoot
		var fireball = ._shoot()
		print("Fireball pos", fireball.global_position)
		fireball.connect("destroyed", self, "_on_fireball_destroyed")
		self.connect("force_destroy", fireball, "force_die")
		
		# Modify whether the fireball is a homing missile or not
		fireball.can_seek = homing
		

func _on_fireball_destroyed():
	emit_signal("fireball_destroyed")
	

# Called when a phase is changed in the boss scene
# In this case we need to destroy any existing homing lanterns that have been shot	
func _on_phase_changed(phase):
	emit_signal("force_destroy")

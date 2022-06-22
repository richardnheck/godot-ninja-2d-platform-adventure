extends Gun

# Determmines whether homing fireball missile is homing or not
# Set false for just a fireball missile targeted at the player
var homing:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _shoot():
	# Call parent shoot
	var bullet = ._shoot()	
	
	# Modify whether the bullet is a homing missile or not
	bullet.can_seek = homing

extends Gun

signal lantern_destroyed
signal force_destroy

# Determmines whether homing shard lantern missile is homing or not
# Set false for just a shard lantern missile targeted at the player
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
		print("HomingShardLanternSpawner enabled: _shoot()")
		# Call parent shoot
		var shard_lantern = ._shoot()
		print("Shard lantern pos", shard_lantern.global_position)
		shard_lantern.connect("destroyed", self, "_on_lantern_destroyed")
		self.connect("force_destroy", shard_lantern, "force_die")
		shard_lantern.rotation = 0  # Ensure lantern is upright
		
		# Modify whether the shard_lantern is a homing missile or not
		shard_lantern.can_seek = homing
		

func _on_lantern_destroyed():
	emit_signal("lantern_destroyed")
	
# Called when a phase is changed in the boss scene
# In this case we need to destroy any existing homing lanterns that have been shot	
func _on_phase_changed(phase):
	emit_signal("force_destroy")

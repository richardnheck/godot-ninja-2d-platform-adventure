extends Node2D

onready var animated_sprite = $AnimatedSprite

# For boss shake
# How quickly the shaking stops [0, 1].
export var decay = 0.01
# Maximum hor/ver shake in pixels.
export var max_offset = Vector2(10, 10) 

# Current shake strength (0 to 1).
var trauma = 0.0
# Trauma exponent (use [2, 3] for a good feel).
var trauma_power = 2 

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize the random number generator's seed
	rng.randomize()

func _process(delta):
	if trauma > 0:
		# Apply the shake offset based on current trauma
		animated_sprite.position = Vector2(
			max_offset.x * (rng.randf_range(-1, 1)) * pow(trauma, trauma_power),
			max_offset.y * (rng.randf_range(-1, 1)) * pow(trauma, trauma_power)
		)
		# Gradually reduce trauma
		trauma -= decay * delta
		if trauma < 0:
			trauma = 0
			animated_sprite.position = Vector2.ZERO # Reset position when finished
	else:
		animated_sprite.position = Vector2.ZERO

func set_trauma(value):
	trauma = value;
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0) # Cap trauma at 1.0


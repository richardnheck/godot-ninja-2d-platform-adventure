class_name CutSceneLantern
extends AnimatedSprite

var tween : SceneTreeTween

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

var init_position:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize the random number generator's seed
	rng.randomize()
	
	init_position = position
	
	# 1. Create the tween for oscillating, set it to loops
	tween = create_tween().set_loops()
	
	# 2. Define Y-oscillation settings
	var up_amount = -3
	var down_amount = 3
	var duration = 1.5 # Time to move up or down
	
	# 3. Create the sequence
	# Move up, relative to current position, then back down
	tween.tween_property(self, "position:y", position.y + up_amount, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y + down_amount, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.stop()		# don't oscillate immediately

func _process(delta):
	if trauma > 0:
		# Apply the shake offset based on current trauma
		position = init_position + Vector2(
			max_offset.x * (rng.randf_range(-1, 1)) * pow(trauma, trauma_power),
			max_offset.y * (rng.randf_range(-1, 1)) * pow(trauma, trauma_power)
		)
		# Gradually reduce trauma
		trauma -= decay * delta
		if trauma < 0:
			trauma = 0
			position = init_position # Reset position when finished
	else:
		pass

func set_trauma(value):
	trauma = value;
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0) # Cap trauma at 1.0
	

func start_oscillating() -> void:
	tween.play()
	
func stop_oscillating() -> void:
	tween.stop()

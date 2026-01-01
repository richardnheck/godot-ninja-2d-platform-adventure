extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite

signal state_cycle_finished

var velocity = Vector2(40,0)
var speed = 80
var direction = 1

const STATE_IDLE = "idle"
const STATE_RUN = "run"

var previous_state = null
var current_state = null
var state_changed = false

var player:KinematicBody2D = null
var ground_global_position:Vector2 = Vector2.ZERO
var can_change_direction = true   # Indicates whether enemy can change direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boss Ready")
	
	ground_global_position = global_position
	
	set_state(STATE_IDLE)

func set_state(state):
	if state != current_state:
		previous_state = current_state
		current_state = state
		state_changed = true


func set_player(player_ref):
	player = player_ref;


func _just_entered_state():
	return state_changed
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:
		STATE_IDLE:
			set_sprite_animation("asleep")
		STATE_RUN:
			_update_direction()
			velocity = move_and_slide(Vector2(speed * direction, 0), Vector2.UP, false, 4, PI/4, false)

var new_direction = 0

func _update_direction() -> void:
	_apply_direction_change_if_possible()
	
	var direction_before = direction
	var tmp_direction = direction
	var ap = position.direction_to(player.position)
	if ap.x > 0:
		tmp_direction = 1
		#set_sprite_animation("look-right")
	elif ap.x < 0:
		tmp_direction = -1
		#set_sprite_animation("look-left")
	else:
		tmp_direction = 0
		
	if tmp_direction != direction_before:
		if $ChangeDirectionCoolOffTimer.is_stopped():
			new_direction = tmp_direction
		
			# The direction needs to be changed
			# Start cool timer to prevent direction from being changed immediately
			can_change_direction = false
			$ChangeDirectionCoolOffTimer.start()
	


func _apply_direction_change_if_possible() -> void:
	if can_change_direction:
		# Apply the direction change
		direction = new_direction	
		if direction == 1:
			set_sprite_animation("look-right")
		elif direction == -1:
			set_sprite_animation("look-left")
	

func _on_ChangeDirectionCoolOffTimer_timeout() -> void:
	print("change direction timeout")
	can_change_direction = true

	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func set_sprite_animation(animation) -> void:
	animated_sprite.animation = animation
	animated_sprite.play(animation)


func _on_DetectionArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		set_state(STATE_RUN)


func _on_DetectionArea2D_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		set_state(STATE_IDLE)

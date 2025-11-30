extends Position2D

onready var player:Player = $'../..'

# This affects the speed at which the camera switches positions to make the camera offset
# in front of the player depending on their direction
const CAMERA_WEIGHT = 1.4
const CAMERA_POSITION_OFFSET = 48 
const PLAYER_VELOCITY_THRESHOLD = 100

# A history of the players velocity to be able to determine when best to
# adjust the camera xoffset automatically 
const HISTORY_SIZE = 20 # The number of velocity frames to store
var velocity_history = []

enum yOffsetType {
	DOWN = 0,		# camera y offset is below player so they can see more below
	UP = 1			# camera y offset is above player so they can see more above
	NONE = 0		# camera y offset is centered on player for balanced view of above and below
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	velocity_history.append(get_player_velocity())
	
	if velocity_history.size() > HISTORY_SIZE:
		velocity_history.remove(0)
	
	update_pivot_position(delta)



func update_pivot_position(delta):
	var avg_velocity := calculate_average_velocity()
	if(abs(avg_velocity.x) > PLAYER_VELOCITY_THRESHOLD):
		var nextpos = CAMERA_POSITION_OFFSET if player.look_direction.x == 1 else -CAMERA_POSITION_OFFSET*2
		position.x = floor(lerp(position.x, nextpos, delta * CAMERA_WEIGHT ))
	
	#print("position.x", position.x)

func get_player_velocity():
	if !player:
		return 0
		
	var current_state = player.get_current_state()
	if current_state != null:
		return current_state.velocity if current_state.velocity != null else 0
	else:
		return 0


func calculate_average_velocity() -> Vector2:
	if velocity_history.empty():
		return Vector2.ZERO

	var total_velocity = Vector2.ZERO
	for v in velocity_history:
		total_velocity += v

	return total_velocity / velocity_history.size()


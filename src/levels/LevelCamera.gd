extends Camera2D

var player: Player
var smoothing_distance: = 7
var camera_offset:Vector2 = Vector2.ZERO


func set_player(player:Player):
	self.player = player
	


# Called when the node enters the scene tree for the first time.
func _ready():
	camera_offset = Vector2(3,0)
	yield(get_tree().create_timer(0), "timeout")
	last_still_position_set = true
	last_still_position_y = player.global_position.y
	global_position.y = player.global_position.y
	
var last_still_position_set = false
var last_still_position_y

func _physics_process(delta):
	if self.player != null:	
		if _player_still_vertically() and !last_still_position_set:
			last_still_position_set = true
			last_still_position_y = player.global_position.y

		if !_player_still_vertically():
			last_still_position_set = false
			
					
		var weight: float
		var camera_position: Vector2
		var camera_position_x: float
		var camera_position_y: float
		
		weight = float(smoothing_distance)/100
		camera_position = lerp(global_position, player.global_position, weight)
		camera_position_x = lerp(global_position.x, player.global_position.x, weight)
		
		if _player_jumping():
			camera_position_y = last_still_position_y
		else:
			camera_position_y = lerp(global_position.y, player.global_position.y, weight)
			
		
#		if last_still_position_set:
#			camera_position_y = last_still_position_y
#		else:
#			camera_position_y = lerp(global_position.y, player.global_position.y, weight)
			
		#global_position = camera_position.floor() + camera_offset
		#global_position = Vector2(camera_position_x, camera_position_y).floor()
		global_position = Vector2(camera_position_x, camera_position_y ).floor()
			
		


func _get_player_velocity():
	if !player:
		return 0
		
	var current_state = player.get_current_state()
	if current_state != null:
		return current_state.velocity if current_state.velocity != null else 0
	else:
		return 0


func _player_still_vertically():
	var current_state = player.get_current_state()
	if current_state != null and current_state.velocity.y == 0 and (current_state.name in ["Idle", "WallSlide"]):
		return true
	else:
		return false

func _player_jumping():
	var current_state = player.get_current_state()
	if current_state != null and (current_state.name == "Jump" or current_state.name == "AirJump" or current_state.name == "WallJump"):
		return true
	else:
		return false

var jump_started = false

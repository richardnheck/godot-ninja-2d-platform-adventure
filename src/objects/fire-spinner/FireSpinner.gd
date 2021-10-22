tool
extends Node2D

##
## A node that spins or swings fireballs
##
## @desc:
##    This node is based on the "Burney Whirler" from the game LevelHead
##

const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")

const MAX_FIREBALLS = 5

enum RotationStyle { 
	SPIN = 0,		# Spins in a continous circle
	SWING = 1		# Swings through an arc of a specified angular range
}

# Configurable properties of the Fire Spinner
# ------------------------------------------------------------------------
# Speed of rotation (degrees per second)
export(int, -180, 180, 45) var speed:int = 45 setget _set_speed

# Start direction of flames in degrees
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction

# The style rotation (spin or swing)
export(int, 0, 1) var rotation_style:int = 0 setget _set_rotation_style

# The swing angle (in degrees) either side of start direction
export(int, 45, 135, 45) var swing_degrees:int = 90 setget _set_swing_degrees

# The swing speed in degrees per second
# Positive speeds rotate in an anti-clockwise direction, negative speeds rotate in a clockwise direction 
export(int, -100, 100, 25) var swing_speed:int = 50 setget _set_swing_speed

# Number of spinning fire balls in the same line 
export(int, 1, 5) var length:int = 4 setget _set_length

# Specifies whether there is a gap between the fireballs
export var gap:bool = false setget _set_gap

# The number of fireball chains that can spin
export(int, 1, 4) var chains:int = 1 setget _set_chains
# ------------------------------------------------------------------------

# The rotation pivot
onready var pivot:=$Pivot

# Represents the actual rotation in degrees that the pivot is rotated
var actual_rotation_degrees = 0

var radius = 18   # This is big enough to allow the player through a gap

# Easing variables for Swing
var swing_ease_offset: float = 0.0
var swing_ease_start: float = 0.0
var swing_ease_target: float = 0.0
var swing_ease_length: float = 0.1    # time in seconds to complete swing from one boundary to the other (initialise non-zer

# Determines if it is the start of the swing cycle starting from start_direction
var is_swing_start = true

# Indicates whether the current direction of swing is is_swing_clockwise.
# When false the current swing direction is anti-is_swing_clockwise
var is_swing_clockwise = true

# The time that has passed
var time_passed:float = 0.0

func _ready() -> void:
	if Engine.editor_hint:	
		return
	
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			_add_fireball(i, angle)
	
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	time_passed += delta
	
	if rotation_style == RotationStyle.SPIN:
		_process_spin(delta)
	else:
		_process_swing(delta)


# Process spinning the fireballs
func _process_spin(delta: float) -> void:
	if speed == 0:
		return
	
	actual_rotation_degrees += speed * delta
	if not Engine.editor_hint:
		# Rotate the actual flames in the game
		pivot.rotation_degrees = -start_direction + actual_rotation_degrees
	else:
		# Draw the rotation in the editor
		update()


# Process swinging the fireballs
func _process_swing(delta: float) -> void:
	if swing_speed == 0:
		return
		
	# Swing back and forth
	var ease_output = 0
	if is_swing_start:
		# The swing starts at the start direction (middle of total swing range)
		swing_ease_start = start_direction
		
		# Start without easing in
		ease_output = _easeOutSine(time_passed, swing_ease_offset, swing_ease_length / 2.0)
	else:
		ease_output = _easeInOutSine(time_passed, swing_ease_offset, swing_ease_length)
	
	# Calculate the actual rotation in degrees	
	actual_rotation_degrees = (swing_ease_start + (ease_output * (swing_ease_target - swing_ease_start)))

	if not Engine.editor_hint:
		# Rotate the fireballs in the game
		pivot.rotation_degrees = -actual_rotation_degrees
	else:
		# Draw the rotation in the editor
		update()

	# Handle when a swing in one direction is finished
	# An easings output is from 0 (start) to 1 (end)
	if ease_output == 1:
		# mark that this is no longer the start of the swing
		is_swing_start = false
		
		# swing in the other direction
		is_swing_clockwise = not is_swing_clockwise
		
		# Reset the time offset to effectively start again  
		swing_ease_offset = time_passed
		
		# Recalculate the ease settings range
		_set_ease_range()			
	

# Set the length or number of fireballs in a chain	
func _set_length(value) -> void:
	length = value
	update()

# Set the speed of the spin
# Only relevant when in SPIN mode
func _set_speed(value) -> void:
	speed = value
	_reset_spin()
	
	
# Set the start direction of the fireballs
func _set_start_direction(value) -> void:
	start_direction = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# Set whether there is a gap or not
func _set_gap(value) -> void:
	gap = value
	update()
	

# Set the number of chains
func _set_chains(value) -> void:
	chains = value
	update()
	

# Set the rotation style
func _set_rotation_style(value) -> void:
	rotation_style = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# Set the swing degrees
func _set_swing_degrees(value) -> void:
	swing_degrees = value	
	_reset_swing()
	
	
# Set the swing speed
func _set_swing_speed(value) -> void:
	swing_speed = value	
	_reset_swing()


# Reset the spin so it starts with the newly configured values
func _reset_spin() -> void:
	actual_rotation_degrees = 0
	update()


# Reset the swing so it starts with the newly configured values
func _reset_swing() -> void:
	actual_rotation_degrees = 0
	is_swing_start = true
	is_swing_clockwise = swing_speed < 0
	_set_ease_range()		
	swing_ease_offset = time_passed	# Start swing ease from the beginning
	
	if swing_speed == 0:
		# Speed is zero just make one call to show it in the start position
		actual_rotation_degrees = start_direction
	
	update()
	
	
# Set the swing ease variables
func _set_ease_range():
	if swing_speed == 0:
		return 
		
	swing_ease_length = swing_degrees * 2.0 / abs(swing_speed)    # time = distance(in degrees) / speed(degrees per second)
	
	if is_swing_clockwise:
		# swing in the clockwise direction
		swing_ease_start = start_direction + swing_degrees
		swing_ease_target = start_direction - swing_degrees
	else:
		# swing in the anti-clockwise direction
		swing_ease_start = start_direction - swing_degrees
		swing_ease_target = start_direction + swing_degrees


# Add a real fireball node to the pivot node
func _add_fireball(index, start_angle) -> void:
	var dist = radius + index * radius
	var fire_ball:FireBall = preload("res://src/objects/fire-spinner/FireBall.tscn").instance()
	fire_ball.position = Vector2(dist, 0).rotated(deg2rad(start_angle))
	fire_ball.show_fireball(index < length)
	if fire_ball._showing and gap:
		# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
		fire_ball.show_fireball(not index % 2 == 0)
	pivot.add_child(fire_ball)		
	

# Draw to the screen
# Used for drawing in the editor only
func _draw():
	if not Engine.editor_hint:
		return
		
	# Draw the fireballs
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			_draw_fireball(i, -start_direction + angle)
		
	if rotation_style == RotationStyle.SPIN:
		# Draw the outer circle around the outmost fireball
		var outer_circle_radius = (radius/2) + radius + ((length - 1)  * radius)
		_draw_empty_circle(Vector2(), Vector2(0, outer_circle_radius), COLOR_WHITE, 1)
		
		# Draw the circle indicating speed of rotation
		draw_circle(Vector2(outer_circle_radius, 0).rotated(deg2rad(-start_direction + actual_rotation_degrees)), 3, COLOR_WHITE)
	elif rotation_style == RotationStyle.SWING:
		# Draw boundary lines for range of swing
		var dist = radius + length * radius
		var line_end = dist * Vector2.RIGHT.rotated(deg2rad(-start_direction)).rotated(deg2rad(-swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)
		
		line_end = dist * Vector2.RIGHT.rotated(deg2rad(-start_direction)).rotated(deg2rad(swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)
		
		# Draw the line that shows the swing motion
		line_end = dist * Vector2.RIGHT.rotated(deg2rad(-actual_rotation_degrees))
		draw_line(Vector2(), line_end, COLOR_WHITE, 1, true)
		draw_circle(line_end, 3, COLOR_WHITE)

	
# Draw a fireball (represented by a circle) to the screen
# Used for drawing in the editor only
func _draw_fireball(index, start_angle) -> void:
	var dist = radius + index * radius
	var _draw_fireball = true
	
	# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
	if gap and index % 2 == 0:
		_draw_fireball = false
		
	if _draw_fireball:
		draw_circle(Vector2(dist, 0).rotated(deg2rad(start_angle)), radius/2, COLOR_ORANGE)


# Draw an empty circle to the screen
# Used for drawing in the editor only
func _draw_empty_circle(circle_center:Vector2, circle_radius:Vector2, color:Color, resolution:int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)


# Easing function: ease out sine
func _easeOutSine(x: float, offset: float=0, length: float=1) -> float:
   x -= offset
   x /= length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else sin((x * PI) / 2.0)))


# Easing function: ease in out sine
func _easeInOutSine(x: float, offset: float=0, length: float=1) -> float:
   x -= offset
   x /= length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else -(cos(PI * x) - 1.0) / 2.0))

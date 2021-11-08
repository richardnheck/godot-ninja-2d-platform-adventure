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

# FireSpinner Configurable Properties
# ------------------------------------------------------------------------
# Speed of rotation (degrees per second)
export(int, -180, 180, 45) var speed:int = 45 setget _set_speed

# Start direction of flames in degrees
# 0 degrees is right
# Postive angles rotate clockwise
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction

# The style rotation (spin or swing)
export(RotationStyle) var rotation_style:int = 0 setget _set_rotation_style

# The swing angle (in degrees) either side of start direction
export(int, 45, 135, 45) var swing_degrees:int = 90 setget _set_swing_degrees

# The swing speed in degrees per second
# Positive speed starts rotation in clockwise direction 
export(int, -100, 100, 10) var swing_speed:int = 50 setget _set_swing_speed

# The swing time offset in seconds to reach start direction
# NB: I couldn't really figure out what the LevelHead swing time offset was 
export(float, 0, 30, 0.1) var swing_time_offset:float = 0 setget _set_swing_time_offset

# Number of spinning fire balls in the same line 
export(int, 1, 5) var length:int = 4 setget _set_length

# Specifies whether there is a gap between the fireballs
export var gap:bool = false setget _set_gap

# The number of fireball chains that can spin
export(int, 1, 4) var chains:int = 1 setget _set_chains
# ------------------------------------------------------------------------


# Additional Configuration
# ------------------------------------------------------------------------
# This is the threshold (in degrees) that starts the fireballs rotating
# when they get this close to the boundary
var start_rotation_threshold = 30.0 

# This the maximum size of a fireball
var radius = 18   # This is big enough to allow the player through a gap 
# ------------------------------------------------------------------------


# The rotation pivot node
# The fireballs are programatically added to this node
onready var pivot := $Pivot

# The tween for rotating the fireballs when rotate style is swing
onready var tween := $FireBallRotationTween

# Represents the actual rotation in degrees that the pivot is rotated
# Positive rotation results in clockwise rotation
var actual_rotation_degrees = 0

# Easing variables for Swing
# These are calculated to give a smooth easing as swing approaches the swing boundary
var swing_ease_offset: float = 0.0		# current ease offset time between start and end of easing
var swing_ease_start: float = 0.0		# start value of the easing
var swing_ease_target: float = 0.0		# end or targe value of the easing
var swing_ease_length: float = 0.1    	# time in seconds to complete swing from one boundary to the other (initialise non-zero)

# Determines if it is the start of the swing cycle starting from start_direction
var is_swing_start = true

# Indicates whether the current direction of swing is clockwise
var is_swing_clockwise = true

# The time that has passed
var time_passed:float = 0.0

# Utility for trigger once behaviour
const Once = preload("res://src/utility/Once.gd")

#
# Variables used for rotating the fireballs near the swing boundary
#
var is_clockwise_start = false			# Indicates if swing direction is clockwise at the start when swing enters threshold region
var threshold_reached = Once.new()		# A trigger when swing is inside the threshold region
var outside_threshold = Once.new()		# A trigger when sing is outside the threshold region
var prev_distance_to_boundary = null	# The previous distance to the boundary.  Used to determine if swing is approaching or moving away from the boundary
var skip_rotation = false

#
# Variables relating to swing time offset
#
var swing_time_offset_degrees = 0		# The offset in degrees from the start direction as a result of the swing time offset
var swing_time_offset_sign = 0			# The sign(positive or negative) of the starting rotation as a result of the swing time offset

# ------------------------------------------------------------------------------
# Set the length or number of fireballs in a chain	
# ------------------------------------------------------------------------------
func _set_length(value) -> void:
	length = value
	update()


# ------------------------------------------------------------------------------
# Set the speed of the spin
# Only relevant when in SPIN mode
# ------------------------------------------------------------------------------
func _set_speed(value) -> void:
	speed = value
	_reset_spin()
	
	
# ------------------------------------------------------------------------------	
# Set the start direction of the fireballs
# ------------------------------------------------------------------------------
func _set_start_direction(value) -> void:
	start_direction = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# ------------------------------------------------------------------------------
# Set whether there is a gap or not
# ------------------------------------------------------------------------------
func _set_gap(value) -> void:
	gap = value
	update()
	

# ------------------------------------------------------------------------------
# Set the number of chains
# ------------------------------------------------------------------------------
func _set_chains(value) -> void:
	chains = value
	update()
	
	
# ------------------------------------------------------------------------------
# Set the rotation style
# ------------------------------------------------------------------------------
func _set_rotation_style(value) -> void:
	rotation_style = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# ------------------------------------------------------------------------------
# Set the swing degrees
# ------------------------------------------------------------------------------
func _set_swing_degrees(value) -> void:
	swing_degrees = value	
	_reset_swing()
	
	
# ------------------------------------------------------------------------------	
# Set the swing speed
# ------------------------------------------------------------------------------
func _set_swing_speed(value) -> void:
	swing_speed = value	
	_reset_swing()


# ------------------------------------------------------------------------------
# Set the swing speed
# ------------------------------------------------------------------------------
func _set_swing_time_offset(value) -> void:
	swing_time_offset = value	
	_reset_swing()


# ------------------------------------------------------------------------------
# Reset the spin so it starts with the newly configured values
# ------------------------------------------------------------------------------
func _reset_spin() -> void:
	actual_rotation_degrees = 0
	is_swing_clockwise = speed > 0   # Positive speed starts swing in clockwise direction
	update()


# ------------------------------------------------------------------------------
# Reset the swing so it starts with the newly configured values
# ------------------------------------------------------------------------------
func _reset_swing() -> void:
	is_swing_start = true
	actual_rotation_degrees = start_direction
	is_swing_clockwise = swing_speed > 0   # Positive speed starts swing in clockwise direction
	_set_ease_range()		
	swing_ease_offset = time_passed		# Start swing ease from the beginning
	
	if swing_speed == 0:
		# Speed is zero just make one call to show it in the start position
		if not Engine.editor_hint:
			if is_instance_valid(pivot):	
				pivot.rotation_degrees = actual_rotation_degrees	
	
	if swing_time_offset > 0:
		# Calculate the offset rotation and direction caused by the swing time offset
		calculate_adjustments_caused_by_swing_time_offset()
		
		# Adjust the rotation direction based on the swing time offset
		# A negative swing time offset sign means swing starts in anti-clockwise direction
		# i.e The swing time offset sign overrides the default rotation direction
		is_swing_clockwise = false if swing_time_offset_sign < 0 else true
				
		# Based on a potential override of rotation direction recalculate the ease range
		_set_ease_range()
		
	update()


# ------------------------------------------------------------------------------
# The ready function for initialisation
# ------------------------------------------------------------------------------
func _ready() -> void:
	if Engine.editor_hint:	
		return
	
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()

	print("ready", is_swing_clockwise)
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			
			_add_fireball(i, angle, is_swing_clockwise)


# ------------------------------------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
# ------------------------------------------------------------------------------
func _process(delta: float) -> void: 
	time_passed += delta
	
	if rotation_style == RotationStyle.SPIN:
		_process_spin(delta)
	else:
		_process_swing(delta)


# ------------------------------------------------------------------------------
# Process spinning the fireballs
# ------------------------------------------------------------------------------
func _process_spin(delta: float) -> void:
	if speed == 0:
		return
	
	actual_rotation_degrees += speed * delta
	if not Engine.editor_hint:
		# Rotate the actual flames in the game
		pivot.rotation_degrees = start_direction + actual_rotation_degrees
	else:
		# Draw the rotation in the editor
		update()


var dbg_full_swing_time = 0		# time to complete a full swing from one boundar to the other

# ------------------------------------------------------------------------------
# Process swinging the fireballs
# ------------------------------------------------------------------------------
func _process_swing(delta: float) -> void:
	if swing_speed == 0:
		return
	
	# For timing debugging
	#----------------------------------------------------------------------
	dbg_full_swing_time += delta
#	if int(actual_rotation_degrees) == start_direction:
#		print(">>>START: ")
#	if actual_rotation_degrees == start_direction + swing_degrees:
#		print(">>>BOUNDARY1: ", dbg_full_swing_time)
#		dbg_full_swing_time = 0
#	if  actual_rotation_degrees == start_direction - swing_degrees:
#		print(">>>BOUNDARY2: " , dbg_full_swing_time)
#		dbg_full_swing_time = 0
	#----------------------------------------------------------------------
		
	# Swing back and forth
	var ease_output = 0
	if is_swing_start:
		var swing_time = 0
		if swing_time_offset == 0:
			# The swing starts at the start direction (middle of total swing range)
			swing_ease_start = start_direction
			swing_time = swing_ease_length / 2.0		# Because it starts in the middle 
		else:
			# Add necessary adjustments determined by swing_time_offset
			# Adjust the start direction by the rotation offset
			swing_ease_start = start_direction + swing_time_offset_degrees
		
			# TODO: This works when swing_degrees = 90, but time is not correct when 45 or 135
			if is_swing_clockwise:
				swing_time = abs((swing_degrees - swing_time_offset_degrees) / swing_speed)
			else:
				swing_time = abs((swing_degrees + swing_time_offset_degrees) / swing_speed) 
		
		# Start without easing in
		ease_output = _easeOutSine(time_passed, swing_ease_offset, swing_time)
	else:
		ease_output = _easeInOutSine(time_passed, swing_ease_offset, swing_ease_length)
	
	# When swing rotation is almost complete then start rotating the fireball smoothly to change direction
	if ease_output > 0.92 and ease_output < 0.93:
		if not Engine.editor_hint:
			pass
			# TEMP: commented out to try alternate solution _rotate_fireballs()
			#_change_fireball_direction(is_swing_clockwise, swing_ease_length)
		
	# Calculate the actual rotation in degrees	
	actual_rotation_degrees = (swing_ease_start + (ease_output * (swing_ease_target - swing_ease_start)))
	
	if not Engine.editor_hint:
		# Rotate the spinner in the actual game
		pivot.rotation_degrees = actual_rotation_degrees
		_rotate_fireballs()
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


# ------------------------------------------------------------------------------
# Rotate the fireballs as they approach the swing boundary
# ------------------------------------------------------------------------------
func _rotate_fireballs(): 
	# Calculate the distance (in degrees) how far the swing is from the swing boundary
	# This creates a positive range of values that descend to 0 when boundary is reached
	var distance_to_boundary = swing_degrees - abs(actual_rotation_degrees - start_direction)
	
	# Handle rotation of fireballs when near the boundary of the swing
	# NB: Need to check that the previous distance to boundary is set as well so we can determine
	# if swing is approaching or moving away from the boundary at the start
	if distance_to_boundary <= start_rotation_threshold and prev_distance_to_boundary != null:
		# Determine if swing is approaching the boundary
		var moving_closer_to_boundary = distance_to_boundary < prev_distance_to_boundary
		
		# For the fireball rotation equation to work make the distance values 
		# negative when approaching and keep them positive when
		var dist = -distance_to_boundary if moving_closer_to_boundary else distance_to_boundary
		
		if threshold_reached.run_once():
			# Run this code only once as the swing has reached the rotation threshold region
			outside_threshold.reset()
			is_clockwise_start = is_swing_clockwise
			
			# Skip rotation if swing is in threshold region but moving away from the boundary at the start
			# This may occur when setting swing_time_offset
			# In this case we need to skip the rotation of the fireball near the boundary because it is already moving away from it 
			skip_rotation = not moving_closer_to_boundary	
			
		# Equation to determine the relative rotation required
		# Currently fireball rotation is linear y = mx + b
		# NB: Because of the swing ease in out that occurs at the boundaries a linear
		# equation is not great as rotation at the boundary is too slow
		# TODO: Change the equation so it rotates faster at the boundary
		if not skip_rotation:
			var fireball_rotation = (90/start_rotation_threshold * dist + 90)
			
			# Flip the rotation if swing rotation is clockwise when entering threshold region
			if is_clockwise_start:
				fireball_rotation = -fireball_rotation
			
			# Call all fireballs to adjust their rotation
			get_tree().call_group(_get_fireball_group(), "adjust_rotation", fireball_rotation)
	else:
		# Swing position is no longer within the threshold distance from the boundary
		if outside_threshold.run_once():
			threshold_reached.reset() 	# Reset the threshold reached trigger
			skip_rotation = false 		# Reset the flag indicating whether rotation should be skipped
			
			# Call all fireballs to remember their current rotation
			get_tree().call_group(_get_fireball_group(), "remember_current_rotation")
			
	prev_distance_to_boundary = distance_to_boundary


# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_adjustments_caused_by_swing_time_offset() -> void:
	# Determine the total number of degrees in rotation that the swing time offset result in at the given swing speed
	# This is the number of degrees we need to delay before the swing reaches its normal 'start direction' given no offset 
	var number_of_degrees = abs(swing_speed) * swing_time_offset
	print("number of degrees: ", number_of_degrees)
	
	var degrees_left = number_of_degrees
	var offset_degrees = 0
	
	# if swing_speed > 0 (positive) then swing starts rotating clockwise
	# however the time offset results in a delay so we need to first rotate in 
	# the opposite direction so the offset swing is behind the normal swing 
	var offset_sign = -1 if swing_speed > 0 else 1
	
	var i = 0
	# Loop through the number of degrees to determine the starting offset of the swing cycle as well as the starting direction of rotation
	while degrees_left > 0 or i > 5:  # i check is to prevent infinite loop
		print(">> i = ", i, ", offset_degrees: ", offset_degrees)
		var reached_boundary_anticlockwise = offset_sign == -1 and offset_degrees - degrees_left < -swing_degrees
		var reached_boundary_clockwise = offset_sign == 1 and (offset_degrees + degrees_left > swing_degrees)
		print("ACLK boundary: ", reached_boundary_anticlockwise, ", CLK boundary: ", reached_boundary_clockwise)
		if reached_boundary_anticlockwise or reached_boundary_clockwise:
			# angle offset has reached swing boundary range
			var delta = swing_degrees - offset_degrees
			offset_degrees += delta * offset_sign		# account for direction
			degrees_left -= abs(delta)
			print("delta: ", delta, ", offset_degrees: ", offset_degrees, ", degrees_left:", degrees_left)
			offset_sign *= -1   	# change direction since boundary reached
		else:
			print("within boundary")
			# angle offset is within the within swing boundary range
			offset_degrees += degrees_left * offset_sign  # -1 because time offset delays time to reach start so need to rotate offset in opposite direction
			degrees_left = 0
			
		i += 1
	swing_time_offset_degrees = offset_degrees
	# Since the swing time is delayed the offset sign must be negated so the swing traces back through all
	# the degrees it was offset
	swing_time_offset_sign = -offset_sign
	print("swing_time_offset_degrees: ", swing_time_offset_degrees, ", swing_time_offset_sign: ", swing_time_offset_sign)
		
		
# ------------------------------------------------------------------------------	
# Set the swing ease variables
# ------------------------------------------------------------------------------
func _set_ease_range():
	if swing_speed == 0:
		return 
		
	swing_ease_length = swing_degrees * 2.0 / abs(swing_speed)    # time = distance(in degrees) / speed(degrees per second)
	
	if is_swing_clockwise:
		# swing in the clockwise direction
		# NB: In Godot positive angle is clockwise
		swing_ease_start = start_direction - swing_degrees
		swing_ease_target = start_direction + swing_degrees
	else:
		# swing in the anti-clockwise direction
		# NB: In Godot egative angle is anti-clockwise
		swing_ease_start = start_direction + swing_degrees
		swing_ease_target = start_direction - swing_degrees


# ------------------------------------------------------------------------------
# Get the name of the fireball group
# ------------------------------------------------------------------------------
func _get_fireball_group()-> String:
	return "fireball" + String(self.get_instance_id())
	

# ------------------------------------------------------------------------------
# Add a real fireball node to the pivot node

# @param index 			The index of the fireball on the chain
# @param start_angle	The starting angle of the chain
# @param clockwise		Indicates the starting direction of rotation
# ------------------------------------------------------------------------------
func _add_fireball(index, start_angle, clockwise) -> void:
	var dist = radius + index * radius
	var fire_ball:FireBall = preload("res://src/objects/fireball-spinner/FireBall.tscn").instance()
	fire_ball.add_to_group(_get_fireball_group())
	fire_ball.position = Vector2(dist, 0).rotated(deg2rad(start_angle))
	fire_ball.rotation_degrees = start_angle - 90 if clockwise else start_angle + 90		# Ensure the fireball points in the correct direction
	print("start_angle", start_angle)
	print("rotation", fire_ball.rotation_degrees)
	fire_ball.remember_current_rotation()		# Remember the current rotation so it can be adjusted incrementally in order to rotate the fireball at the end of the swing
	fire_ball.show_fireball(index < length)
	if fire_ball._showing and gap:
		# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
		fire_ball.show_fireball(not index % 2 == 0)
	pivot.add_child(fire_ball)		


# ------------------------------------------------------------------------------
# Change the direction of the fireball so it smoothly rotates to the opposite direction
# This is only used when rotation style is SWING
# NB: It is more performant to have a single tween here and updating the rotation of all
# fireballs instead of having each fireball mantain a tween and update its own rotation
# ------------------------------------------------------------------------------	
func _change_fireball_direction(clockwise: bool, swing_time: float) -> void:
	# Set the tween length based on the time in takes to complete a full swing
	# This value has been tweaked until the rotation speeds looks natural
	var tween_length = swing_time / 2.0;
	
	# Rotate the first 90 degrees
	var tween_values = []
	if clockwise:
		tween_values = [0 , -180]
	else:
		tween_values = [0 , 180]
	
	tween.interpolate_property(self, "fireball_rotation_offset", tween_values[0], tween_values[1], tween_length, Tween.TRANS_LINEAR)
	tween.start()	

	yield(tween, "tween_completed")
	
	# Call a function of the fireball to remember its current rotation
	get_tree().call_group(_get_fireball_group(), "remember_current_rotation")


# The property that is being tweened in order to rotate the fireballs
var fireball_rotation_offset = 0 setget _set_fireball_rotation_offset

# Set the rotation offset of the fireball
func _set_fireball_rotation_offset(value:float) -> void:
	fireball_rotation_offset = value
	get_tree().call_group(_get_fireball_group(), "adjust_rotation", fireball_rotation_offset)


# ------------------------------------------------------------------------------
# Draw to the screen in the editor
# ------------------------------------------------------------------------------
func _draw():
	if not Engine.editor_hint:
		return
		
	# Draw the fireballs
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			_draw_fireball(i, start_direction + angle)
		
	if rotation_style == RotationStyle.SPIN:
		# Draw the outer circle around the outmost fireball
		var outer_circle_radius = (radius/2) + radius + ((length - 1)  * radius)
		_draw_empty_circle(Vector2(), Vector2(0, outer_circle_radius), COLOR_WHITE, 1)
		
		# Draw the circle indicating speed of rotation
		draw_circle(Vector2(outer_circle_radius, 0).rotated(deg2rad(start_direction + actual_rotation_degrees)), 3, COLOR_WHITE)
	elif rotation_style == RotationStyle.SWING:
		# Draw boundary lines for range of swing
		# NB: In Godot: Positive rotation is clockwise
		var dist = radius + length * radius
		var line_end = dist * Vector2.RIGHT.rotated(deg2rad(start_direction)).rotated(deg2rad(-swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)

		line_end = dist * Vector2.RIGHT.rotated(deg2rad(start_direction)).rotated(deg2rad(swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)

		# Draw the line that shows the swing motion
		line_end = dist * Vector2.RIGHT.rotated(deg2rad(actual_rotation_degrees))
		draw_line(Vector2(), line_end, COLOR_WHITE, 1, true)
		draw_circle(line_end, 3, COLOR_WHITE)


# ------------------------------------------------------------------------------	
# Draw a fireball (represented by a circle) to the screen
# Used for drawing in the editor only
# ------------------------------------------------------------------------------
func _draw_fireball(index, start_angle) -> void:
	var dist = radius + index * radius
	var _draw_fireball = true
	
	# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
	if gap and index % 2 == 0:
		_draw_fireball = false
		
	if _draw_fireball:
		draw_circle(Vector2(dist, 0).rotated(deg2rad(start_angle)), radius/2, COLOR_ORANGE)


# ------------------------------------------------------------------------------
# Draw an empty circle to the screen
# Used for drawing in the editor only
# ------------------------------------------------------------------------------
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


# ------------------------------------------------------------------------------
# Easing function: ease out sine
# NB: The easing function need to be defined in this node for it to work in the editor
# ------------------------------------------------------------------------------
func _easeOutSine(x: float, offset: float=0, ease_length: float=1) -> float:
   x -= offset
   x /= ease_length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else sin((x * PI) / 2.0)))


# ------------------------------------------------------------------------------
# Easing function: ease in out sine
# NB: The easing function need to be defined in this node for it to work in the editor
# ------------------------------------------------------------------------------
func _easeInOutSine(x: float, offset: float=0, ease_length: float=1) -> float:
   x -= offset
   x /= ease_length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else -(cos(PI * x) - 1.0) / 2.0))

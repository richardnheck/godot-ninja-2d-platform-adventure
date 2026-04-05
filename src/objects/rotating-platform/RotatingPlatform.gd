tool
extends Node2D
class_name RotatingPlatform

##
## A node that rotates or swings platforms
##

const platform_scene = "res://src/objects/rotating-platform/Platform.tscn"	# Platform scene	
const Once = preload("res://src/utility/Once.gd")				# Utility for trigger once behaviour

enum RotationStyle { 
	SPIN = 0,		# Spins in a continous circle
	SWING = 1		# Swings through an arc of a specified angular range
}

# RotatingPlatform Configurable Properties
# ------------------------------------------------------------------------
# The style rotation (spin or swing)
export(RotationStyle) var rotation_style:int = 1 setget _set_rotation_style

# Start direction of platforms in degrees
# 0 degrees is right
# Postive angles rotate clockwise
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction


# The spin speed of rotation (degrees per second)
export(int, -180, 180, 5) var spin_speed:int = 90 setget _set_spin_speed

# The swing angle (in degrees) either side of start direction
export(int, 45, 135, 45) var swing_degrees:int = 90 setget _set_swing_degrees

# The swing speed in degrees per second
# Positive speed starts rotation in clockwise direction 
export(int, -100, 100, 5) var swing_speed:int = 90 setget _set_swing_speed

# The swing time offset in seconds to reach start direction
export(float, 0, 30, 0.1) var swing_time_offset:float = 0 setget _set_swing_time_offset

# length of the rotating pivot
export(int, 1, 5) var length:int = 3 setget _set_length

# The number of platform chains that can spin
export(int, 1, 4) var chains:int = 1 setget _set_chains

# Sets whether the rotation is animated in the editor or not
export var animate_in_editor:bool = true setget _set_animate_in_editor

# Sets whether the guides drawn in editor or shown in the game
# The guides are normally shown in the editor and not in the game
# Set this to true if you want to see them in the game
export var show_editor_guides:bool = false setget _set_show_editor_guides

# The channel it listens on for switching on and off
# 0 = None
export(int, 0, 1000) var receiving_channel:int = 0 setget _set_receiving_channel
# ------------------------------------------------------------------------


# Additional Configuration
# ------------------------------------------------------------------------
# This is used to calculate the distance from the pivot the platform is placed
# based on the length of the pivot arm holding the platform
var platform_spacing = 16

# This is the threshold distance (in degrees) that starts the platforms rotating
# When the swing is within this threshold distance from the swing boundary,
# then the fireball starts rotating
var start_rotation_threshold = 30.0  
# ------------------------------------------------------------------------


# The rotation pivot node
# The platforms are programatically added to this node
onready var pivot := $Pivot

# Represents the actual rotation in degrees that the pivot is rotated
# Positive rotation results in clockwise rotation
var actual_rotation_degrees = 0

# Easing variables for Swing
# These are calculated to give a smooth easing as swing approaches the swing boundary
var swing_ease_offset: float = 0.0			# current ease offset time between start and end of easing
var swing_ease_start_angle: float = 0.0		# start value of the easing
var swing_ease_target_angle: float = 0.0	# end or targe value of the easing
var swing_ease_time: float = 0.1			# time in seconds for the swing ease (needs to be non-zero for code in editor to work)

#
# Variables relating to swing time offset
#
var swing_time_offset_degrees = 0		# The offset in degrees from the start direction as a result of the swing time offset
var swing_time_offset_sign = 0			# The sign(positive or negative) of the starting rotation as a result of the swing time offset

# Determines if it is the start of the swing cycle starting from start_direction
var is_swing_start = true

# Indicates whether the current direction of swing is clockwise
var is_swing_clockwise = true

# The time that has passed
var time_passed:float = 0.0

#
# Variables used for rotating the platforms near the swing boundary
#
var is_clockwise_start = false			# Indicates if swing direction is clockwise at the start when swing enters threshold region
var threshold_reached = Once.new()		# A trigger when swing is inside the threshold region
var outside_threshold = Once.new()		# A trigger when sing is outside the threshold region
var skip_rotation = false

#
# Colors for drawing
# 
const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")


# ------------------------------------------------------------------------------
# Set the length or number of platforms in a chain	
# ------------------------------------------------------------------------------
func _set_length(value) -> void:
	length = value
	update()


# ------------------------------------------------------------------------------
# Set the speed of the spin
# Only relevant when in SPIN mode
# ------------------------------------------------------------------------------
func _set_spin_speed(value) -> void:
	spin_speed = value
	_reset_spin()
	
	
# ------------------------------------------------------------------------------	
# Set the start direction of the platforms
# ------------------------------------------------------------------------------
func _set_start_direction(value) -> void:
	start_direction = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()
	
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
# Set the swing time offset
# ------------------------------------------------------------------------------
func _set_swing_time_offset(value) -> void:
	swing_time_offset = value	
	_reset_swing()
		

# ------------------------------------------------------------------------------
# Set whether rotation is animated in editor or not
# ------------------------------------------------------------------------------
func _set_animate_in_editor(value) -> void:
	animate_in_editor = value
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()


# ------------------------------------------------------------------------------
# Set whether editor guides are shown in game or not
# ------------------------------------------------------------------------------
func _set_show_editor_guides(value) -> void:
	show_editor_guides = value
	
	
# ------------------------------------------------------------------------------
# Set the receiving channel
# ------------------------------------------------------------------------------
func _set_receiving_channel(value) -> void:
	receiving_channel = value
	$ReceivingChannelLabel.text = String(value)
	$ReceivingChannelLabel.visible = value > 0 && Engine.editor_hint
	update()
	
# ------------------------------------------------------------------------------
# Reset the spin so it starts with the newly configured values
# ------------------------------------------------------------------------------
func _reset_spin() -> void:
	actual_rotation_degrees = 0
	is_swing_clockwise = spin_speed > 0   # Positive speed starts swing in clockwise direction
	update()


# ------------------------------------------------------------------------------
# Reset the swing so it starts with the newly configured values
# ------------------------------------------------------------------------------
func _reset_swing() -> void:
	# Reset main swing variables
	is_swing_start = true
	actual_rotation_degrees = start_direction
	is_swing_clockwise = swing_speed > 0   # Positive speed starts swing in clockwise direction
	_set_ease_range()		
	swing_ease_offset = time_passed		# Start swing ease from the beginning
	
	# Reset fireball rotation variables
	is_clockwise_start = false
	threshold_reached = Once.new()
	outside_threshold = Once.new()
	skip_rotation = false
	
	if swing_speed == 0:
		# Speed is zero just make one call to show it in the start position
		if not Engine.editor_hint:
			if is_instance_valid(pivot):	
				pivot.rotation_degrees = actual_rotation_degrees	
	
	if swing_time_offset > 0:
		# Calculate the offset rotation and direction caused by the swing time offset
		calculate_adjustments_caused_by_swing_ease_time_offset()
		
		# Adjust the rotation direction based on the swing time offset
		# A negative swing time offset sign means swing starts in anti-clockwise direction
		# i.e The swing time offset sign overrides the default rotation direction
		is_swing_clockwise = false if swing_time_offset_sign < 0 else true
				
		# Based on a potential override of rotation direction recalculate the ease range
		_set_ease_range()
		
	update()
	

# ------------------------------------------------------------------------------	
# Reset firespinner so current settings can be freshly applied
# ------------------------------------------------------------------------------
func reset() -> void:
	if rotation_style == RotationStyle.SPIN:
		_reset_spin()
	else:
		_reset_swing()

	_init_platforms()


# ------------------------------------------------------------------------------	
# Initialise the platforms
# ------------------------------------------------------------------------------
func _init_platforms() -> void:
	# Remove current platforms
	for n in pivot.get_children():
		pivot.remove_child(n)
		n.queue_free()
		
	# Determine if the platforms have a speed (i.e are moving)	
	var has_speed = true	
	if rotation_style == RotationStyle.SPIN:
		has_speed = abs(spin_speed) > 0
	else:
		has_speed = abs(swing_speed) > 0	
	
	# Add platforms
	for c in range(0, chains):
		var angle = c * (360 / chains)
		_add_platform(length - 1, angle, is_swing_clockwise, has_speed)
	
				
# ------------------------------------------------------------------------------	
# Set the swing ease variables
# ------------------------------------------------------------------------------
func _set_ease_range():
	if swing_speed == 0:
		return 
		
	# Calculate the time for a full swing from one boundary to the other 	
	var swing_ease_full_time = swing_degrees * 2.0 / abs(swing_speed)    # time = distance(in degrees) / speed(degrees per second)
	
	if is_swing_clockwise:
		# Swing starts in the clockwise direction
		# NB: In Godot positive angle is clockwise
		swing_ease_start_angle = start_direction - swing_degrees
		swing_ease_target_angle = start_direction + swing_degrees
	else:
		# Swing starts in the anti-clockwise direction
		# NB: In Godot egative angle is anti-clockwise
		swing_ease_start_angle = start_direction + swing_degrees
		swing_ease_target_angle = start_direction - swing_degrees
	
	# Now that the base ease settings for a full swing have been calculated above,
	# Calculate the adjustments necessary for the start of the swing.  
	# - When there is no swing time offset, the swing in the middle.   
	# - When there is a swing time offset, the swing may start anywhere and also
	#   start in the opposite direction	
	if is_swing_start:
		if swing_time_offset == 0:
			# The swing starts at the start direction (middle of total swing range)
			swing_ease_start_angle = start_direction
			swing_ease_time = swing_ease_full_time / 2.0		# swing time is halved because it starts in the middle 
		else:
			# Add necessary adjustments determined by swing_time_offset
			# Adjust the start direction by the rotation offset
			swing_ease_start_angle = start_direction + swing_time_offset_degrees
		
			if is_swing_clockwise:
				swing_ease_time = abs((swing_degrees - swing_time_offset_degrees) / swing_speed)
			else:
				swing_ease_time = abs((swing_degrees + swing_time_offset_degrees) / swing_speed) 
	else:
		swing_ease_time = swing_ease_full_time

# ------------------------------------------------------------------------------
# The ready function for initialisation
# ------------------------------------------------------------------------------
func _ready() -> void:
	if Engine.editor_hint:	
		return
	reset()
	
	# Connect to any switches on the same channel
	if receiving_channel > 0:
		var switches = get_tree().get_nodes_in_group("switch")
		for switch in switches:
			if switch.sending_channel == receiving_channel:
				switch.connect("switched", self, "_on_Switch_switched")
				_on_Switch_switched(switch.start_state)		# initialize to start state of switch


func _on_Switch_switched(active) -> void:
	get_tree().call_group(_get_platform_group(), "show_fireball", active)
	
# ------------------------------------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
# ------------------------------------------------------------------------------
func _physics_process(delta: float) -> void: 
	time_passed += delta
	
	if rotation_style == RotationStyle.SPIN:
		_process_spin(delta)
	else:
		_process_swing(delta)

# ------------------------------------------------------------------------------
# Process spinning the platforms
# ------------------------------------------------------------------------------
func _process_spin(delta: float) -> void:
	actual_rotation_degrees += spin_speed * delta
	if not Engine.editor_hint:
		# Rotate the platforms around the pivot
		pivot.rotation_degrees = start_direction + actual_rotation_degrees
	
		# Counter pivot rotation to ensure platforms stay horizontal
		_rotate_platforms(-pivot.rotation_degrees)
	update()
	

# ------------------------------------------------------------------------------
# Process swinging the platforms
# ------------------------------------------------------------------------------
func _process_swing(delta: float) -> void:	
	# Draw the rotation and guides
	update()
	
	if swing_speed == 0:
		return
		
	# Swing back and forth
	var	ease_output = _easeInOutSine(time_passed, swing_ease_offset, swing_ease_time)
		
	# Calculate the actual rotation in degrees	
	actual_rotation_degrees = (swing_ease_start_angle + (ease_output * (swing_ease_target_angle - swing_ease_start_angle)))
	
	if not Engine.editor_hint:
		# Rotate the platform in the actual game so it also stays horizontal
		pivot.rotation_degrees = actual_rotation_degrees
		_rotate_platforms(-actual_rotation_degrees)
		
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
# Rotate the platforms
# Call all platforms to adjust their rotation
# ------------------------------------------------------------------------------
func _rotate_platforms(degrees) -> void:
	get_tree().call_group(_get_platform_group(), "adjust_rotation", degrees)

	
# ------------------------------------------------------------------------------
# Calculate the adjustments caused by swing time offset
# Swing time offset represents the time by which the swing is delayed before it 
# would normally reach its normal start position in the middle
# 
# When swing_time_offset == 0 the swing starts in the middle
# When swing_time_offset > 0 an adjustments needs to be made to:
# 1. The angle at the which the swing starts
# 2. The initial direction of rotation of the swing 
# ------------------------------------------------------------------------------
func calculate_adjustments_caused_by_swing_ease_time_offset() -> void:
	# Determine the total number of degrees in rotation that the swing time offset result in at the given swing speed
	# This is the number of degrees we need to delay before the swing reaches its normal 'start direction' given no offset 
	var number_of_degrees = abs(swing_speed) * swing_time_offset
	
	var degrees_left = number_of_degrees
	
	var offset_degrees = 0		
	
	# if swing_speed > 0 (positive) then swing starts rotating clockwise
	# however the time offset results in a delay so we need to first rotate in 
	# the opposite direction so the offset swing is behind the normal swing 
	var offset_sign = -1 if swing_speed > 0 else 1
	
	# Loop through the number of degrees to determine the starting offset of the swing cycle as well as the starting direction of rotation
	while degrees_left > 0:  
		var exceeded_boundary_anticlockwise = offset_sign == -1 and offset_degrees - degrees_left < -swing_degrees
		var exceeded_boundary_clockwise = offset_sign == 1 and (offset_degrees + degrees_left > swing_degrees)
		
		if exceeded_boundary_anticlockwise or exceeded_boundary_clockwise:
			var delta = 0
			if offset_degrees == 0:
				# Offset has moved from the start point at the centre of the swing to the boundary
				# So offset has moved half a full swing cycle i.e swing_degrees
				delta = swing_degrees
			else:
				# Offset has moved from one boundary to the next
				# So offset has moved a full swing cycle i.e swing_degrees * 2
				delta = swing_degrees * 2
			
			offset_degrees += delta * offset_sign		# account for direction
			degrees_left -= abs(delta)
			offset_sign *= -1   	# change direction since boundary reached
		else:
			# angle offset is within the within swing boundary range
			offset_degrees += degrees_left * offset_sign  # -1 because time offset delays time to reach start so need to rotate offset in opposite direction
			degrees_left = 0
		
	swing_time_offset_degrees = offset_degrees
	
	# Since the swing time is delayed the offset sign must be negated so the swing traces back through all
	# the degrees it was offset
	swing_time_offset_sign = -offset_sign
	
	
# ------------------------------------------------------------------------------
# Get the name of the platform group
# ------------------------------------------------------------------------------
func _get_platform_group()-> String:
	return "platform" + String(self.get_instance_id())
	

# ------------------------------------------------------------------------------
# Add a platform node to the pivot node

# @param index 			The index of the platform on the chain
# @param start_angle	The starting angle of the chain
# @param clockwise		Indicates the starting direction of rotation
# @param has_speed      Indicates if the spinner has a rotational speed (i.e true if platforms are moving)
# ------------------------------------------------------------------------------
func _add_platform(index, start_angle, clockwise, has_speed) -> void:
	# Calculate the dist the centre of the platform is away from the pivot 
	var dist = platform_spacing	 + index * platform_spacing
	var platform:Platform = load(platform_scene).instance()
	platform.add_to_group(_get_platform_group())
	platform.position = Vector2(dist, 0).rotated(deg2rad(start_angle))

	# The platforms they should all be horizontal
	platform.rotation_degrees = -start_direction
#	
	# Remember the current rotation so it can be adjusted incrementally in order to rotate the fireball at the end of the swing
	# platform.remember_current_rotation()		
	
	# Show only the platforms up to the specified length
	platform.show_platform(index < length)
	
	# Add the platform to the pivot
	pivot.add_child(platform)		


# ------------------------------------------------------------------------------
# Draw to the screen in the editor
# ------------------------------------------------------------------------------
func _draw():
	if not Engine.editor_hint:
		if not show_editor_guides:
			return
		
	# Draw the platforms
	for c in range(0, chains):
		var angle = c * (360 / chains)
		_draw_platform(length - 1, start_direction + angle)
		
	if rotation_style == RotationStyle.SPIN:
		# Draw the outer circle through the center of the platform
		var dist = (length-1)*platform_spacing + platform_spacing
		_draw_empty_circle(Vector2(), Vector2(0, dist), COLOR_WHITE, 1)
		
		# Draw the circle indicating speed of rotation
		if animate_in_editor:
			draw_circle(Vector2(dist, 0).rotated(deg2rad(start_direction + actual_rotation_degrees)), 3, COLOR_WHITE)
	
	elif rotation_style == RotationStyle.SWING:
		# Draw boundary lines for range of swing
		# NB: In Godot: Positive rotation is clockwise
		var dist = platform_spacing + (length-1) * platform_spacing
		var line_end = dist * Vector2.RIGHT.rotated(deg2rad(start_direction)).rotated(deg2rad(-swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)

		line_end = dist * Vector2.RIGHT.rotated(deg2rad(start_direction)).rotated(deg2rad(swing_degrees))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)

		# Draw the line that shows the swing motion
		if animate_in_editor:
			line_end = dist * Vector2.RIGHT.rotated(deg2rad(actual_rotation_degrees))
			draw_line(Vector2(), line_end, COLOR_WHITE, 1, true)
			draw_circle(line_end, 3, COLOR_WHITE)


# ------------------------------------------------------------------------------	
# Draw a platform (represented by a rectanggle) to the screen
# @param index			The current index of the rectangle (0 is closest to centre)
# @param start_angle	The start angle (degrees) of the platform chain
# ------------------------------------------------------------------------------
func _draw_platform(index:int, start_angle:float) -> void:
	var dist = platform_spacing + index * platform_spacing
	var platform_height = 16 
	var platform_width = 32
	var center = Vector2(dist, 0).rotated(deg2rad(start_angle))
	var top_left_x = center.x - (platform_width / 2)
	var top_left_y = center.y - (platform_height / 2)
	var rect_position = Vector2(top_left_x, top_left_y)
	draw_rect(Rect2(rect_position, Vector2(32,16)), COLOR_ORANGE)
	_draw_empty_circle(center, Vector2(2,0), COLOR_WHITE, 1)


# ------------------------------------------------------------------------------
# Draw an empty circle to the screen
# ------------------------------------------------------------------------------
func _draw_empty_circle(circle_center:Vector2, circle_fireball_spacing:Vector2, color:Color, resolution:int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_fireball_spacing + circle_center

	while draw_counter <= 360:
		line_end = circle_fireball_spacing.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_fireball_spacing.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)


# ------------------------------------------------------------------------------
# Easing function: ease in out sine
# NB: The easing function need to be defined in this node for it to work in the editor
# ------------------------------------------------------------------------------
func _easeInOutSine(x: float, offset: float=0, ease_length: float=1) -> float:
   x -= offset
   x /= ease_length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else -(cos(PI * x) - 1.0) / 2.0))


# ------------------------------------------------------------------------------
# Easing function: ease in out circ
# This easing is used to rotate the platforms. This easing function is defined
# here instead of using an easing library because the above easing functions 
# needed to be included in this node to work in the editor, and so it felt overkill
# to use an easing library for just one function
# ------------------------------------------------------------------------------
func _easeInOutCirc(x: float, offset: float=0, length: float=1) -> float:
   x -= offset
   x /= length
   return (0.0 if x < 0 else (1.0 if x > 1.0 else ((1.0 - sqrt(1.0 - pow(2 * x, 2))) / 2.0 if x < 0.5 else (sqrt(1.0 - pow(-2.0 * x + 2, 2)) + 1.0) / 2.0)))
   

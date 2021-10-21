extends Node2D

const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")

const MAX_FIREBALLS = 5

enum RotationStyle { 
	SPIN = 0,		# Spins in a continous circle
	SWING = 1		# Swings through an arc of a specified angular range
}

# Speed of rotation (degrees per second)
export(int, -180, 180, 45) var speed:int = 45

# Start direction of flames in degrees
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction

# The style rotation (spin or swing)
export(int, 0, 1) var rotation_style:int = 0 setget _set_rotation_style

# The swing angle (in degrees) either side of start direction
export(int, 0, 90, 45) var swing_degrees:int = 90 setget _set_swing_degrees

# The swing speed 
export(int, -100, 100, 25) var swing_speed:int = 50 setget _set_swing_speed

# Number of spinning fire balls in the same line 
export(int, 1, 5) var length:int = 4 setget _set_length

# Specifies whether there is a gap between the fireballs
export var gap:bool = false setget _set_gap

# The number of fireball chains that can spin
export(int, 1, 4) var chains:int = 1 setget _set_chains

onready var pivot:=$Pivot


var delta_for_draw:float = 0
var actual_rotation_degrees = 0

var radius = 18   # This is big enough to allow the player through a gap

# Easing variables for Swing
var ease_offset: float = Time.time_passed
var ease_start  := 0.0
var ease_target := 0.0
var ease_length := 0.0    # time in seconds to complete swing from one boundary to the other

# Determines if it is the start of the swing cycle starting from start_direction
var is_start = true

# Indicates whether the current direction of swing is clockwise.
# When false the current swing direction is anti-clockwise
var clockwise = true

var time_passed:float = 0.0

func _ready() -> void:
	if Engine.editor_hint:	
		return
	
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			add_fireball(i, angle)
	
	if rotation_style == RotationStyle.SPIN:
		# Set the start direction of the fireballs
		pass
	else:
		clockwise = swing_speed < 0
		set_ease_range()
	
		if swing_speed == 0:
			# Speed is zero just make one call to show it in the start position
			actual_rotation_degrees = start_direction
			update()


func _process(delta: float) -> void:
	if time_passed == null:
		time_passed = 0.0 
	time_passed += delta
	delta_for_draw = delta
	
	if rotation_style == RotationStyle.SPIN:
		# Adjust rotation for spin mode
		if speed != 0:
			actual_rotation_degrees += speed * delta
			if not Engine.editor_hint:
				# Rotate the actual flames in the game
				pivot.rotation_degrees = -start_direction + actual_rotation_degrees
			else:
				# Draw the rotation in the editor
				update()
	else:
		# Swing back and forth
		var ease_output = 0
		if is_start:
			# The swing starts at the start direction (middle of total swing range)
			ease_start = start_direction
			
			# Start without easing in
			ease_output = Ease.easeOutSine(time_passed, ease_offset, ease_length / 2.0)
		else:
			ease_output = Ease.easeInOutSine(time_passed, ease_offset, ease_length)
		
		# Calculate the actual rotation in degrees	
		actual_rotation_degrees = (ease_start + (ease_output * (ease_target - ease_start)))
		
		# Rotate the fireballs
		pivot.rotation_degrees = -actual_rotation_degrees
		
		update()

		if ease_output == 1:
			# swing in one direction is complete so:
			# mark that this is no longer the start of the swing
			is_start = false
			
			# swing in the other direction
			clockwise = not clockwise
			
			# Reset the time offset to effectively start again  
			ease_offset = time_passed
			
			# Recalculate the ease settings range
			set_ease_range()		
	
	
func _set_length(value) -> void:
	length = value
	update()

	
func _set_start_direction(value) -> void:
	start_direction = value
	update()

	
func _set_gap(value) -> void:
	gap = value
	update()
	

func _set_chains(value) -> void:
	chains = value
	update()
	
func _set_rotation_style(value) -> void:
	rotation_style = value
	update()

func _set_swing_degrees(value) -> void:
	swing_degrees = value	
	update()
	
func _set_swing_speed(value) -> void:
	actual_rotation_degrees = 0
	swing_speed = value	
	update()

# Set the ease variables for the swing
func set_ease_range():
	if swing_speed == 0:
		return 
		
	ease_length = swing_degrees * 2.0 / abs(swing_speed)    # time = distance(in degrees) / speed(degrees per second)
	
	if clockwise:
		# swing in the clockwise direction
		ease_start = start_direction + swing_degrees
		ease_target = start_direction - swing_degrees
	else:
		# swing in the anti-clockwise direction
		ease_start = start_direction - swing_degrees
		ease_target = start_direction + swing_degrees

func _draw():
	# Temporarily removed to debug drawing for siwng
	#if not Engine.editor_hint:
	#	return
		
	# Draw the fireballs
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			draw_fireball(i, -start_direction + angle)
		
	if rotation_style == RotationStyle.SPIN:
		# Draw the outer circle around the outmost fireball
		var outer_circle_radius = (radius/2) + radius + ((length - 1)  * radius)
		draw_empty_circle(Vector2(), Vector2(0, outer_circle_radius), COLOR_WHITE, 1)
		
		# Draw the circle indicating speed of rotation
		draw_circle(Vector2(0, outer_circle_radius).rotated(deg2rad(actual_rotation_degrees)), 3, COLOR_WHITE)
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

		# Draw the start direction
		line_end = dist * Vector2.RIGHT.rotated(deg2rad(-start_direction))
		draw_line(Vector2(), line_end, COLOR_ORANGE, 1, true)
	
# Add a fireball to the pivot node
func add_fireball(index, start_angle) -> void:
	var dist = radius + index * radius
	var fire_ball:FireBall = preload("res://src/objects/fire-spinner/FireBall.tscn").instance()
	fire_ball.position = Vector2(dist, 0).rotated(deg2rad(start_angle))
	fire_ball.show_fireball(index < length)
	if fire_ball._showing and gap:
		# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
		fire_ball.show_fireball(not index % 2 == 0)
	pivot.add_child(fire_ball)		
	

func draw_fireball(index, start_angle) -> void:
	var dist = radius + index * radius
	var draw_fireball = true
	
	# When gap is true, then the 2nd, 4th fireball is not shown to leave a gap
	if gap and index % 2 == 0:
		draw_fireball = false
		
	if draw_fireball:
		draw_circle(Vector2(dist, 0).rotated(deg2rad(start_angle)), radius/2, COLOR_ORANGE)


func draw_empty_circle(circle_center:Vector2, circle_radius:Vector2, color:Color, resolution:int):
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


func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


extends Node2D

const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")

var chains = 1
var start_direction = 90
var radius = 16
var length = 3
var swing_degrees = 90
var swing_speed = -45   # speed in degrees per second 
var actual_rotation_degrees = 0 

# Easing variables
var ease_offset: float = Time.time_passed
var ease_start  := 0.0
var ease_target := 0.0
var ease_length := 0.0    # time in seconds to complete swing from one boundary to the other

var is_start = true
var clockwise = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clockwise = swing_speed < 0
	set_ease_range()
	
	if swing_speed == 0:
		# Speed is zero just make one call to show it in the start position
		actual_rotation_degrees = start_direction
		update()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if swing_speed == 0:
		return
				
	var ease_output = 0
	if is_start:
		# The swing starts at the start direction (middle of total swing range)
		ease_start = start_direction
		
		# Start without easing in
		ease_output = Ease.easeOutSine(Time.time_passed, ease_offset, ease_length / 2.0)
	else:
		ease_output = Ease.easeInOutSine(Time.time_passed, ease_offset, ease_length)
	
	# Calculate the actual rotation in degrees	
	actual_rotation_degrees = (ease_start + (ease_output * (ease_target - ease_start)))

	if ease_output == 1:
		# swing in one direction is complete so:
		# mark that this is no longer the start of the swing
		is_start = false
		
		# swing in the other direction
		clockwise = not clockwise
		
		# Reset the time offset to effectively start again  
		ease_offset = Time.time_passed
		
		# Recalculate the ease settings range
		set_ease_range()
		 
	update()

func set_ease_range():
	if swing_speed == 0:
		return 
		
	ease_length = swing_degrees * 2.0 / abs(swing_speed)    # time = distance(in degrees) / speed(degrees per second)
	
	if clockwise:
		# swing clockwises
		ease_start = start_direction + swing_degrees
		ease_target = start_direction - swing_degrees
	else:
		# swing backwards
		ease_start = start_direction - swing_degrees
		ease_target = start_direction + swing_degrees

func _draw():
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
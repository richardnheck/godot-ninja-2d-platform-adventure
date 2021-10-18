extends Node2D

const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var chains = 1
var start_direction = 90
var radius = 16
var length = 3
var swing_degrees = 90
var rotation_degrees_for_draw = 0 


# Easing variables
var ease_offset: float = Time.time_passed
var ease_start  := 0.0
var ease_target := 0.0
var ease_length := 2    # time in seconds

var forward = true
var actual_start_direction = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ease_start = start_direction + swing_degrees
	ease_target = start_direction - swing_degrees
	actual_start_direction = ease_start
	print("ease_start:" + String(ease_start))
	print("ease_target:" + String(ease_target))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if forward:
		# swing forwards
		ease_start = start_direction - swing_degrees
		ease_target = start_direction + swing_degrees
	else:
		# swing backwards
		ease_start = start_direction + swing_degrees
		ease_target = start_direction - swing_degrees
	
	var ease_output = Ease.easeInOutSine(Time.time_passed, ease_offset, ease_length)
	rotation_degrees_for_draw = (ease_start + (ease_output * (ease_target - ease_start)))
	print(rotation_degrees_for_draw)
	if ease_output == 1:
		# swing in one direction is complete so swing in the other direction
		ease_offset = Time.time_passed
		forward = not forward
		 
	update()


func _draw():
	# Draw boundary lines for range of swing
	var dist = radius + length * radius
	var line_end = Vector2(dist, 0).rotated(deg2rad(-start_direction)).rotated(deg2rad(-swing_degrees))
	draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
	draw_circle(line_end, 3, COLOR_BLUE)
	
	line_end = Vector2(dist, 0).rotated(deg2rad(-start_direction)).rotated(deg2rad(swing_degrees))
	draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
	draw_circle(line_end, 3, COLOR_BLUE)
	
	# Draw the line that shows the swing motion
	line_end = Vector2(dist, 0).rotated(deg2rad(actual_start_direction)).rotated(deg2rad(rotation_degrees_for_draw))
	draw_line(Vector2(), line_end, COLOR_WHITE, 1, true)
	draw_circle(line_end, 3, COLOR_WHITE)

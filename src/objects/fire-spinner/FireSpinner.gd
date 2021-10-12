tool
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
var rotation_degrees_for_draw = 0

var radius = 18   # This is big enough to allow the player through a gap

# Tween for Swing
onready var swing_tween:=$SwingTween
onready var swing_tween_values = [0, 0]


func _start_swing_tween():
	if(swing_tween_values[0] == 0):
		swing_tween_values = [-swing_degrees, swing_degrees]
		
	var time = float(100/swing_speed)
	print("swing speed", swing_speed)
	print("time", time)
	swing_tween.interpolate_property(pivot, "rotation_degrees", swing_tween_values[0], swing_tween_values[1], time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	swing_tween.start()	


func _on_SwingTween_tween_completed(object: Object, key: NodePath) -> void:
	print ("tween completed")
	swing_tween_values.invert()
	_start_swing_tween()


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			add_fireball(i, -start_direction + angle)
			
	if rotation_style == RotationStyle.SWING:
		_start_swing_tween()


func _process(delta: float) -> void:
	if Engine.editor_hint:
		# Remember values so editor can animate the speed of the rotation
		delta_for_draw = delta
		rotation_degrees_for_draw += speed * delta
		update()
		return
	
	if rotation_style == RotationStyle.SPIN:
		# Adjust rotation for spin mode
		if speed != 0:
			pivot.rotation_degrees += speed * delta


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
	swing_tween_values = [-swing_degrees, swing_degrees]#		
	update()
	
func _set_swing_speed(value) -> void:
	swing_speed = value	
	update()

func _draw():
	if not Engine.editor_hint:
		return
		
	if rotation_style == RotationStyle.SPIN:
		# Draw the outer circle around the outmost fireball
		var outer_circle_radius = (radius/2) + radius + ((length - 1)  * radius)
		draw_empty_circle(Vector2(), Vector2(0, outer_circle_radius), COLOR_WHITE, 1)
		
		# Draw the circle indicating speed of rotation
		draw_circle(Vector2(0, outer_circle_radius).rotated(deg2rad(rotation_degrees_for_draw)), 3, COLOR_WHITE)
	elif rotation_style == RotationStyle.SWING:
		# Draw boundary lines for range of swing
		var dist = radius + length * radius
		var line_end = Vector2(dist, 0).rotated(deg2rad(start_direction)).rotated(deg2rad(-swing_degrees/2))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)
		
		line_end = Vector2(dist, 0).rotated(deg2rad(start_direction)).rotated(deg2rad(swing_degrees/2))
		draw_line(Vector2(), line_end, COLOR_BLUE, 1, true)
		draw_circle(line_end, 3, COLOR_BLUE)
		
		# Draw the line that shows the swing motion
		line_end = Vector2(dist, 0).rotated(deg2rad(start_direction)).rotated(deg2rad(-swing_degrees/2))
		draw_line(Vector2(), line_end, COLOR_WHITE, 1, true)
		draw_circle(line_end, 3, COLOR_WHITE)
	
	# Draw the fireballs
	for c in range(0, chains):
		for i in range(0, length):
			var angle = c * (360 / chains)
			draw_fireball(i, -start_direction + angle)
			
	#draw_line(Vector2(), Vector2(100,100), COLOR_WHITE, 4.0, true)
	#draw_circle(Vector2(),radius + length * radius, COLOR_WHITE)

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


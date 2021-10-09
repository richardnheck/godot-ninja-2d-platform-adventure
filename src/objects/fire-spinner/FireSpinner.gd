tool
extends Node2D

const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")

enum RotationStyle { 
	SPIN = 0,		# Spins in a continous circle
	SWING = 1		# Swings through an arc of a specified angular range
}

# Speed of rotation (degrees per second)
export(int, -180, 180, 45) var speed:int = 45

# Start direction of flames in degrees
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction

export(int, 0, 1) var rotation_style:int = 0 

# Number of spinning fire balls in the same line 
export(int, 1, 4) var length:int = 4 setget _set_length

# Specifies whether there is a gap between the fireballs
export var gap:bool = false

# The number of fireball chains that can spin
export(int, 1, 3) var chains:int = 1

onready var pivot:=$Pivot

onready var fire_balls:Array = [
	$Pivot/FireBall1,
	$Pivot/FireBall2,
	$Pivot/FireBall3,
	$Pivot/FireBall4
]

var radius = 16

func _ready() -> void:
	if Engine.editor_hint:
		return
		
	for i in len(fire_balls):
		var dist = radius + i * radius
		var fire_ball = fire_balls[i]
		fire_ball.position = Vector2(dist, 0).rotated(deg2rad(-start_direction))
		fire_ball.visible = i < length


func _process(delta: float) -> void:
	if Engine.editor_hint:
		return
	pivot.rotation_degrees += speed * delta 

func _set_length(value) -> void:
	length = value
	update()
	
func _set_start_direction(value) -> void:
	start_direction = value
	update()
	
func _draw():
	if not Engine.editor_hint:
		return
		
	#draw_line(Vector2(), Vector2(100,100), COLOR_WHITE, 4.0, true)
	#draw_circle(Vector2(),radius + length * radius, COLOR_WHITE)
	
	draw_empty_circle(Vector2(), Vector2(0, (radius/2) + radius + ((length - 1)  * radius)), COLOR_WHITE, 1)
	
	for i in range(0, length):
		var dist = radius + i * radius
		draw_circle(Vector2(dist, 0).rotated(deg2rad(-start_direction)), radius/2, COLOR_ORANGE)

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

# A script to have a placeholder track for non standard plaforms
extends Node2D

onready var path := $Path2D

var curve = null

export var platform_offset = Vector2(16,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.curve = path.curve
	update()
	
func _draw():
	if !curve:
		return
		
	var num_points = curve.get_point_count()
	if num_points != 2:
		# This script only draws a straight track between two points
		return
	
	var p1 = curve.get_point_position(0)
	var p2 = curve.get_point_position(1)
	
	draw_line(p1 + platform_offset, p2+platform_offset, Color.slategray, 2, true) # Last argument is line thickness


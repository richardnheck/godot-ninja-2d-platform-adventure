extends KinematicBody2D
class_name Actor

var FLOOR_NORMAL = Vector2.UP

var speed: = Vector2(30, 800.0)
var gravity: = 50

# Wall slide speed factor (max = 1)
# The smaller the number the slower the slide. When equal to 1 the slide is the same as falling
export var wall_slide_speed_factor = 0.8 	

var _velocity: = Vector2.ZERO


	
	

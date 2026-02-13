tool
class_name LaserLantern
extends Node2D

enum MODE {
	STATIONARY = 0,
	PATH = 1
}

enum Orientation {
	HORIZONTAL_LEFT_RIGHT = 2,
	HORIZONTAL_RIGHT_LEFT = 3,
}

# For movement and position
export (MODE) var mode = MODE.STATIONARY
export(Orientation) var orientation = Orientation.HORIZONTAL_LEFT_RIGHT
export(float) var speed := 25
export(int) var path_length = 64

onready var position_tween := $PositionTween
onready var position_line2d := $PositionLine2D

var position_tween_values = [Vector2.ZERO, Vector2.ZERO]

# For Laser
# ----------------------------------------
onready var line_2d: Line2D = $"%Line2D"
onready var line_width := line_2d.width
onready var tween := $Tween
onready var raycast := $RayCast2D
onready var effect := $AnimatedSpriteEffect

onready var lifetime_timer = $LifetimeTimer

# Speed at which the laser extends when first fired, in pixels per second.
export var cast_speed := 7000.0

# The target position of the cast
export var target_position := Vector2(0,100)

# Distance in pixels from the origin to start drawing and firing the laser.
export var start_distance := 0.0
# Base duration of the tween animation in seconds.
export var growth_time := 0.1
export var color := Color.white setget set_color

# If `true`, the laser is firing.
export var is_casting := false setget set_is_casting

# The lifetime of a laser lantern. If zero then it lives forever
var lifetime:= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)
	set_is_casting(is_casting)
	line_2d.points[0] = Vector2.ZERO * start_distance
	line_2d.points[1] = Vector2.ZERO
	line_2d.visible = false

	if mode == MODE.PATH:
		var base_tween_values = [Vector2(-path_length/2,0), Vector2(path_length/2,0)]
		if(orientation == Orientation.HORIZONTAL_LEFT_RIGHT):
			base_tween_values = [Vector2(-path_length/2,0), Vector2(path_length/2,0)]
			position_tween_values = [position + base_tween_values[0], position + base_tween_values[1]]
		elif(orientation == Orientation.HORIZONTAL_RIGHT_LEFT):
			base_tween_values = [Vector2(path_length/2,0), Vector2(-path_length/2,0)]
			position_tween_values = [position + base_tween_values[0], position + base_tween_values[1]]
		
		if Engine.is_editor_hint():
			# Draw a line in the editor to show the path
			# This doesn't work in sections
			position_line2d.clear_points()
			position_line2d.add_point(base_tween_values[0])
			position_line2d.add_point(base_tween_values[1])
		
		_start_position_tween()	
	
	if not Engine.is_editor_hint():
		# disable physics process so laser doesn't fire straight away
		set_physics_process(false)

	# A lifetime has been set for the lantern (in the boss level)
	if lifetime > 0:
		lifetime_timer.wait_time = lifetime
		lifetime_timer.start()
		

func _start_position_tween(): 
	if Engine.is_editor_hint():
		# Don't tween in the editor
		return
		
	var tween_time = path_length / speed
	position_tween.interpolate_property(self, "position", position_tween_values[0], position_tween_values[1], tween_time, Tween.TRANS_SINE)
	position_tween.start()	


func _on_PositionTween_tween_completed(object, key):
	position_tween_values.invert()
	_start_position_tween()


func _physics_process(delta: float) -> void:
	if raycast:
		raycast.cast_to = target_position
#		This isn't working
#		raycast.cast_to.y = move_toward(
#			target_position.y,
#			max_length,
#			cast_speed * delta
#		)

		var laser_end_position = target_position
		raycast.force_raycast_update()

		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is Player:
				# Laser has hit the player so kill the player
				collider.die()
			
			laser_end_position = to_local(raycast.get_collision_point())
			effect.position = laser_end_position

		line_2d.points[1] = laser_end_position
	
	
func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value

	set_physics_process(is_casting)

	if not line_2d:
		return

	if is_casting:
		var laser_start := Vector2.ZERO * start_distance
		line_2d.points[0] = laser_start
		line_2d.points[1] = laser_start
		appear()
	else:
		target_position = Vector2.ZERO
		disappear()

		
func appear() -> void:
	line_2d.visible = true
	effect.visible = true
	if tween and tween.is_active():
		tween.stop()
	tween.interpolate_property(line_2d, "width", 0.0, line_width, growth_time * 2.0)
	tween.start()


func disappear() -> void:
	if tween and tween.is_active():
		tween.stop()
	tween.interpolate_property(line_2d, "width", line_width, 0.0, growth_time)
	tween.interpolate_callback(self, 0.2, "hide_line")
	tween.start()


func hide_line():
	print("hide line")
	line_2d.visible = false
	effect.visible = false


func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color


func _on_Timer_timeout():
	set_is_casting(!is_casting)


func _on_LifetimeTimer_timeout():
	# Destroy the Laser Lantern
	# TODO: Add some animations or fading or something
	queue_free()

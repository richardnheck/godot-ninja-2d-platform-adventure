tool
extends Node2D

onready var line_2d: Line2D = $"%Line2D"
onready var line_width := line_2d.width
onready var tween := $Tween
onready var raycast := $RayCast2D

## Speed at which the laser extends when first fired, in pixels per second.
export var cast_speed := 7000.0

# The target position of the cast
export var target_position := Vector2(0,100)

## Distance in pixels from the origin to start drawing and firing the laser.
export var start_distance := 0.0
## Base duration of the tween animation in seconds.
export var growth_time := 0.1
export var color := Color.white setget set_color

## If `true`, the laser is firing.
export var is_casting := false setget set_is_casting


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)
	set_is_casting(is_casting)
	line_2d.points[0] = Vector2.ZERO * start_distance
	line_2d.points[1] = Vector2.ZERO
	line_2d.visible = false

	if not Engine.is_editor_hint():
		set_physics_process(false)

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

		line_2d.points[1] = laser_end_position
	
	
func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value

	set_physics_process(is_casting)

	if not line_2d:
		return

	if is_casting:
		var laser_start := Vector2.RIGHT * start_distance
		line_2d.points[0] = laser_start
		line_2d.points[1] = laser_start
		appear()
	else:
		target_position = Vector2.ZERO
		disappear()
		
func appear() -> void:
	line_2d.visible = true
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

func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color


func _on_Timer_timeout():
	set_is_casting(!is_casting)

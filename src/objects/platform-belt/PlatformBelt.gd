tool
extends Node2D

export(float) var distance_between_platforms = 100
export(float) var platform_speed = 50
export(Vector2) var platform_direction = Vector2.DOWN
export(int) var position_offset = 0

onready var spawn_timer:Timer = $SpawnTimer
onready var belt_region_collision_shape:= $BeltRegionArea2D/CollisionShape2D


func _ready():
	yield(get_tree().create_timer(0), "timeout")
	
	# prepopulate platforms in the belt region
	var region_length = _get_belt_region_length()
	var number_of_platforms = region_length / distance_between_platforms
	
	for i in range(0, number_of_platforms):
		if platform_direction == Vector2.DOWN:
			# spawn platforms from the top of the belt region
			_spawn_platform(Vector2(0, i * distance_between_platforms + position_offset))
		elif platform_direction == Vector2.UP:
			# spawn platforms from the bottom of the belt region
			_spawn_platform(Vector2(0, region_length - (i * distance_between_platforms) - position_offset))
	 
	#Start the spawner timer
	spawn_timer.wait_time = distance_between_platforms / platform_speed
	spawn_timer.start()
	
	
func _get_belt_region_length() -> float:
	return belt_region_collision_shape.shape.extents.y * 2


func _spawn_platform(pos:Vector2 = Vector2.ZERO):
	if Engine.editor_hint:
		return
		
	var platform:PlatformForBelt = preload("res://src/objects/platform-belt/Platform.tscn").instance()
	platform.position = position + pos
	get_parent().add_child(platform)		
	platform.set_direction(platform_direction)
	platform.set_speed(platform_speed)
	



func _on_SpawnTimer_timeout():
	if Engine.editor_hint:
		return
		
	if platform_direction == Vector2.DOWN:
		_spawn_platform(Vector2(0,position_offset))
	elif platform_direction == Vector2.UP:
		_spawn_platform(Vector2(0,_get_belt_region_length() - position_offset))
		
		
func _on_Area2D_body_exited(body):
	if body is PlatformForBelt:
		print("exitted")
		body.queue_free()
		

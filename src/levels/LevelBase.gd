extends Node2D
class_name LevelBase

onready var key = $InteractiveProps/KamonKey
onready var door = $InteractiveProps/Door
onready var endTimer = $EndTimer

onready var tilemapWorld:TileMap = $TileMapWorld
onready var tilemapTraps:TileMap = $TileMapTraps
onready var fadeScreenScene = preload("res://src/UI/FadeScreen/FadeScreen.tscn")

onready var player_spawn_position = get_node("PlayerSpawnPosition")
onready var temp_spawn_position = get_node("TempSpawnPosition");
onready var check_point:Area2D = get_node("InteractiveProps/CheckPoint")
onready var player_scene = preload("res://src/actors/player/Player.tscn")
onready var start_door = get_node("Props/DoorStart")

var player:KinematicBody2D
var fadeScreen:FadeScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LevelBase: ready()")
	
	# Spawn the player
	player = _spawn_player()
	
	# Connect signals
	player.connect("died", self, "_on_Player_died")
	player.connect("collided", self, "_on_Player_collided")
	key.connect("captured", self, "_on_Key_captured")
	door.connect("player_entered", self, "_on_Door_player_entered");
	if(check_point != null):
		check_point.connect("reached", self, "_on_CheckPoint_reached")
	
	fadeScreen = fadeScreenScene.instance()
	add_child(fadeScreen)
	
	tilemapTraps.add_to_group(Constants.GROUP_TRAP)
	
	set_player_camera_limits(player, tilemapWorld);

	door.close()

#func _get_configuration_warning():
#	if temp_spawn_position != null:
#		return 'Remove Temporary Spawn Position!!!'
#	else:
#		return ''
				
func _spawn_player() -> KinematicBody2D:
	var spawn_point = Vector2.ZERO
	if temp_spawn_position != null:
		spawn_point = temp_spawn_position.position
	elif LevelData.level_checkpoint_reached:
		spawn_point = check_point.position
	elif player_spawn_position != null:
		spawn_point = player_spawn_position.position
	elif start_door != null:
		spawn_point = start_door.position	
	
	var player_instance = player_scene.instance()
	player_instance.position = spawn_point
	player_instance.z_index = 10000
	add_child(player_instance)
	return player_instance


func goto_next_level() -> void:
	LevelData.goto_next_level();
		

func _on_Key_captured() -> void:
	door.open()
	
	
func _on_Door_player_entered() -> void:
	player.celebrate();
	yield(get_tree().create_timer(2), "timeout")
	goto_next_level()


func _on_Player_collided(collision: KinematicCollision2D) -> void:
	# Confirm the colliding body is a TileMap
	if collision.collider is TileMap:
		var tilemap = collision.collider
		if tilemap.is_in_group(Constants.GROUP_TRAP):
			# Player touched a trap so die
			player.die()


func _on_Player_died() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	fadeScreen.reload_scene()

func _on_CheckPoint_reached() -> void:
	print("reached checkpoint")
	LevelData.level_checkpoint_reached = true


#-------------------------------------------
# Helper Functions
#-------------------------------------------
 
func set_player_camera_limits(player: KinematicBody2D, tilemap:TileMap) -> void:
	var camera:Camera2D = player.get_node("Camera2D")
	var bounds:Rect2 = calculate_tilemap_bounds(tilemap);
	var size:= 0   # The size to extend the bounds
	camera.limit_left = bounds.position.x-size
	camera.limit_top = bounds.position.y-size
	camera.limit_right = bounds.end.x+size
	camera.limit_bottom = bounds.end.y # so that mobile buttons don't cover player ever when at the bottom of the screen
	
func calculate_tilemap_bounds(tilemap: TileMap) -> Rect2:
	var cell_bounds = tilemap.get_used_rect()
	# create transform
	var cell_to_pixel = Transform2D(Vector2(tilemap.cell_size.x * tilemap.scale.x, 0), Vector2(0, tilemap.cell_size.y * tilemap.scale.y), Vector2())
	# apply transform
	return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)


func get_collision_tile_name(collision: KinematicCollision2D) -> String:				
		if collision.collider is TileMap:
			var tilemap = collision.collider
		
			# Find the colliding tile position
			# Subtract the normal of the collision to get the actual tile it collided with
			var tile_pos = tilemap.world_to_map(collision.position - collision.normal)
			
			# Get the tile id
			var tile_id = tilemap.get_cellv(tile_pos)
			
			if tile_id > 0:
				var tile_name = tilemap.tile_set.tile_get_name(tile_id)
				print("tile_id=%d tile_name=%s" % [tile_id, tile_name])
				return tile_name
				
		return ""


func _on_Button_pressed() -> void:
	get_tree().reload_current_scene()

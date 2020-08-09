extends Node2D
class_name LevelBase

onready var key = $InteractiveProps/KamonKey
onready var door = $InteractiveProps/Door
onready var endTimer = $EndTimer
onready var player:KinematicBody2D = $Player
onready var tilemapWorld:TileMap = $TileMapWorld
onready var tilemapTraps:TileMap = $TileMapTraps
onready var fadeScreenScene = preload("res://src/UI/FadeScreen/FadeScreen.tscn")

var fadeScreen:FadeScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LevelBase: ready()")
	
	# Connect signals
	player.connect("died", self, "_on_Player_died")
	player.connect("collided", self, "_on_Player_collided")
	key.connect("captured", self, "_on_Key_captured")
	door.connect("player_entered", self, "_on_Door_player_entered");
	
	fadeScreen = fadeScreenScene.instance()
	add_child(fadeScreen)
	
	tilemapTraps.add_to_group(Constants.GROUP_TRAP)
	
	set_player_camera_limits(player, tilemapWorld);
	
	door.close()
	

func goto_next_level() -> void:
	LevelData.goto_next_level();
		

func _on_Key_captured() -> void:
	door.open()
	
	
func _on_Door_player_entered() -> void:
	print("door entered")
	# Disable player physics 
	player.set_physics_process(false)
	player.celebrate()
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

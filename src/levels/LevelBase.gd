extends Node2D
class_name LevelBase

onready var key = $InteractiveProps/KamonKey
onready var door = $InteractiveProps/Door
onready var endTimer = $EndTimer
onready var player = $Player
onready var tileMapWorld = $TileMapWorld

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_camera_limits(player, tileMapWorld);
	
	door.close()

func goto_next_level() -> void:
	LevelData.goto_next_level();


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

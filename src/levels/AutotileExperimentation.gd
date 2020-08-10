extends Node2D

const KEY = 6 
const DOOR = 7
const DOOR_START = 8
const PLAYER = 9
const CRUMBLING_PLATFORM = 10


onready var playerScene = preload("res://src/actors/Player.tscn")
onready var keyScene = preload("res://src/objects/KamonKey.tscn")
onready var doorScene = preload("res://src/objects/Door.tscn")
onready var doorStartScene = preload("res://src/objects/CaveDoorStart.tscn")
onready var crumblingPlatformScene = preload("res://src/objects/CrumblingPlatform.tscn")

onready var tilemap:TileMap = $TileMapObjects

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("setup_tiles")
	


func setup_tiles():
	var cells = tilemap.get_used_cells()
	for cell in cells:	
		var index = tilemap.get_cell(cell.x, cell.y)
		match index:
			PLAYER:
				create_instance_from_tilemap(cell, playerScene, self, 0, 0)	
			KEY:
				create_instance_from_tilemap(cell, keyScene, self, 0, 0)
			DOOR:
				create_instance_from_tilemap(cell, doorScene, self, 8, 16)
			DOOR_START:
				# Create start door and player
				create_instance_from_tilemap(cell, doorStartScene, self, 0,0)
				create_instance_from_tilemap(cell, playerScene, self, 0, 0)
			CRUMBLING_PLATFORM:
				create_instance_from_tilemap(cell, crumblingPlatformScene, self, 0,0)
				
			
				
func create_instance_from_tilemap(coord:Vector2, prefab: PackedScene, parent:Node2D, offsetX:int, offsetY:int):
	tilemap.set_cell(coord.x, coord.y, -1)
	var pf = prefab.instance()
	pf.position = tilemap.map_to_world(coord)
	pf.position.x += offsetX
	pf.position.y += offsetY
	parent.add_child(pf)	
		

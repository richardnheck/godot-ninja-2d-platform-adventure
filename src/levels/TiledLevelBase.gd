extends Node2D
class_name TiledLevelBase

onready var key = $Map/Key
onready var door = $Map/Door
onready var endTimer = $EndTimer

onready var tilemapWorld:TileMap = $Map/World
onready var fadeScreenScene = preload("res://src/UI/FadeScreen/FadeScreen.tscn")
onready var screenShakeScene = preload("res://src/objects/camera-effects/ScreenShake.tscn")
onready var intro_title_scene = preload("res://src/UI/Controls/LevelIntroTitle/LevelIntroTitle.tscn")

onready var player_spawn_position = get_node("Map/PlayerSpawnPosition")
onready var temp_spawn_position = get_node("TempSpawnPosition");
onready var player_scene = preload("res://src/characters/player/Player.tscn")
onready var start_door = get_node("Props/DoorStart")

onready var intro_title = null

var player:Player
var fadeScreen:FadeScreen
var screenShake:ScreenShake
var checkpoints:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("TiledLevelBase: ready()")
	 
	# Preload the world screen to prevent HTML5 audio stutter when transitioning
	preload("res://src/UI/WorldSelectScreen/WorldSelect.tscn")
	
	var current_level_path = get_tree().current_scene.filename
	var bgm = LevelData.get_level_bgm(current_level_path)
	if bgm != "":
		Game_AudioManager.play_bgm_by_node_name(bgm)
	
	Actions.use_normal_actions()		# Use normal input actions
	
	# Initialise checkpoints
	get_tree().call_group(Constants.GROUP_CHECKPOINT, "set_on", LevelData.level_checkpoint_reached)
	checkpoints = get_tree().get_nodes_in_group(Constants.GROUP_CHECKPOINT)
	for checkpoint in checkpoints:
		checkpoint.connect("reached", self, "_on_CheckPoint_reached")
		
	# Spawn the player
	player = _spawn_player()
	
	# Connect signals
	player.connect("start_die", self, "_on_Player_start_die")
	player.connect("died", self, "_on_Player_died")
	player.connect("collided", self, "_on_Player_collided")
	
	# Pass the player to the enemies
	get_tree().call_group("enemy", "set_player", player)
	
	if key: 
		key.connect("captured", self, "_on_Key_captured")
	if door:
		door.connect("player_entered", self, "_on_Door_player_entered");
	
	fadeScreen = fadeScreenScene.instance()
	add_child(fadeScreen)
	
	# Add the screen shake scene
	screenShake = screenShakeScene.instance()
	add_child(screenShake)
	
	set_player_camera_limits(player, tilemapWorld);

	if door:
		if LevelData.has_key:
			# The player has already grabbed the key so open the door and dont show the key
			door.open()
			if key:
				key.show_key(false)
		else: 
			door.close()
		
	
	if not LevelData.is_reload:
		var level_name = LevelData.get_level_name(current_level_path)
		if level_name != "":
			intro_title = intro_title_scene.instance()
			add_child(intro_title)
			intro_title.set_deferred("text", level_name)
			yield(intro_title, "finished")
			intro_title.queue_free()
		LevelData.is_reload = false
		

#func _get_configuration_warning():
#	if temp_spawn_position != null:
#		return 'Remove Temporary Spawn Position!!!'
#	else:
#		return ''
var player_instance = null			
func _spawn_player() -> KinematicBody2D:
	print("spawning at:")
	var spawn_point = Vector2.ZERO
	if temp_spawn_position != null and OS.is_debug_build():
		# Temp Spawn position is only allowed for debug builds
		print("temp spawn position")
		spawn_point = temp_spawn_position.position
	elif LevelData.level_checkpoint_reached != Constants.NO_CHECKPOINT:
		var checkpoint_id = LevelData.level_checkpoint_reached
		print("check point position:", checkpoint_id)
		var checkpoint = _get_checkpoint(checkpoint_id)
		print(checkpoint)
		spawn_point = checkpoint.position
	elif player_spawn_position != null:
		print("player spawn position")
		spawn_point = player_spawn_position.position
	elif start_door != null:
		print("start door position")
		spawn_point = start_door.position	
	
	player_instance = player_scene.instance()
	player_instance.position = spawn_point
	player_instance.z_index = 10000
	add_child(player_instance)
	return player_instance




func _on_Door_player_entered() -> void:
	Game_AudioManager.sfx_ui_level_clear.play()
	player.celebrate();
	yield(get_tree().create_timer(2), "timeout")
	_progress_player_and_goto_next_level()


func _on_EndArea_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		_progress_player_and_goto_next_level()
		
	
func _progress_player_and_goto_next_level() -> void:
	GameState.progress_current_level(LevelData.current_level_index + 1)
	goto_next_level()
	
	
func goto_next_level() -> void:
	LevelData.goto_next_level();
		
			
func _on_Key_captured() -> void:
	LevelData.has_key = true
	if door:
		door.open()
	
	
func _on_Player_collided(collision: KinematicCollision2D) -> void:
	# Confirm the colliding body is a TileMap
	if collision.collider is TileMap:
		var tilemap = collision.collider
		if tilemap.is_in_group(Constants.GROUP_TRAP):
			# Player touched a trap so die
			player.die()

# Called at the start of the die process
func _on_Player_start_die() -> void:
	screenShake.screen_shake(0.05, 8, 200)

# Called when player animation and stuff have finished
func _on_Player_died() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	fadeScreen.reload_scene()
	LevelData.reload_level()

# Called when a checkpoint has been reached by the player
func _on_CheckPoint_reached(checkpoint_id) -> void:
	print("Checkpoint reached: ", checkpoint_id)
	
	# Turn off all checkpoints first
	# NB: Need to specifically call in real time otherwise they are called deferred
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, Constants.GROUP_CHECKPOINT, "set_on", Constants.NO_CHECKPOINT)
	
	# Turn on the checkpoint just reached
	_get_checkpoint(checkpoint_id).set_on(checkpoint_id)
	
	# Remember which checkpoint has been reached
	LevelData.set_checkpoint_reached(checkpoint_id) 

# Get a checkpoint by its id
func _get_checkpoint(id:String)-> Checkpoint:
	for check_point in checkpoints:
		if check_point.id == id:
			return check_point
	return null

	
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



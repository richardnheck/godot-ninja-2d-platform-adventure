extends LevelBase

func _ready() -> void:
	print("LevelScene: ready()")
	
	
#func _process(delta: float) -> void:
#	var cpos = tileMapWorld.map_to_world(player.position)
#	print (str(cpos))


func _on_Key_captured() -> void:
	door.open()


func _on_Door_player_entered() -> void:
	# Disable player physics 
	player.set_physics_process(false)
	player.celebrate()
	endTimer.start()


func _on_EndTimer_timeout() -> void:
	goto_next_level()



func _on_Player_collided(collision: KinematicCollision2D) -> void:
	# Confirm the colliding body is a TileMap
	if collision.collider is TileMap:
		var tilemap = collision.collider
		if tilemap.is_in_group(Constants.GROUP_TRAP):
			# Player touched a trap so die
			player.die()
			yield(get_tree().create_timer(0.5), "timeout")
			fadeScreen.reload_scene()
	
				
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
			


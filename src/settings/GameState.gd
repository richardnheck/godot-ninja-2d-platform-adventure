extends Node

# Store the player progress
var progress = {
	"current_world" : LevelData.WORLD1,
	
	# Index in levelsArray of current level reached
	"current_level" : 0			
}
 
func set_current_world(world) -> void:
	progress["current_world"] = world
	
	
func set_current_level(level_index) -> void:
	progress["current_level"] = level_index


# Progress the players current level
# Only if the level index is greater than current level will it be set
func progress_current_level(level_index) -> void:
	if level_index > progress["current_level"]:
		set_current_level(level_index)


var prev_progress = null
func cheat(value):
	if value:
		print("Cheat enabled")
		# Set cheat progress settings which enables all levels
		prev_progress = progress.duplicate(true);
		print(prev_progress)
		set_current_world(LevelData.WORLD3)
		set_current_level(10)  
	else:
		print("Cheat disabled")
		print(prev_progress)		
		# Uncheat by restoring current progress
		progress = prev_progress.duplicate(true)

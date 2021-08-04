extends Node

const SAVE_FILE_PATH := "user://castle-yokai-game.save"

# Store the player progress
var progress = {
	"current_world" : LevelData.WORLD1,
	
	# Index in levelsArray of current level reached
	"current_level" : 0			
}

func _ready():
	print("GameState ready")
	
	# Load the save state
	load_save()
	
	
# Load data from game save file
func load_save() -> void:
	print("loading save file...") 
	# Read the save file
	var file := File.new()
	var status = file.open(SAVE_FILE_PATH, File.READ)
	if status == OK:
		# File opened successfully
		print("opened!")
		print(file.get_as_text()) 
		var data: Dictionary = str2var(file.get_as_text())
		file.close()
	
		# Apply the saved progress to the local progress
		progress = data["progress"]
	else:
		print("failed", status)

# Save the game state to file
func save() -> void:
	print("saving...")
	var save_data := {
		"progress" : progress
	}
	var data_as_string := var2str(save_data)
	print(data_as_string);
	
	var file := File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_string(data_as_string)
	file.close()
	print("done")
 
func set_current_world(world) -> void:
	progress["current_world"] = world
	
	
func set_current_level(level_index) -> void:
	progress["current_level"] = level_index


# Progress the players current level
# Only if the level index is greater than current level will it be set
func progress_current_level(level_index) -> void:
	if level_index > progress["current_level"]:
		# Set the current level
		set_current_level(level_index)
		
	# Save the updated game state to file
	save()		


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

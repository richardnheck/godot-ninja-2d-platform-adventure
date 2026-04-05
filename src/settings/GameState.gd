extends Node

const SAVE_FILE_PATH := "user://castle-yokai-game.save"

const KEY_CURRENT_LEVEL = "current_level"
const KEY_WATCH_INTRO = "has_watched_story_intro"
const KEY_IDENTIFIER = "identifier"


# Store the player progress
# Set the default values to start with
var progress = {	
	# Index in levelsArray of current level reached
	KEY_CURRENT_LEVEL : 0,
	
	# Indicates whether user has watched the story intro
	KEY_WATCH_INTRO : false	
}

var user:User = null


func _ready():
	print("GameState ready")
	
	# Load the save state
	load_save()
	
	
# Load data from game save file
func load_save() -> void:
	print("Loading Game State from file...") 
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
		print("progress state", progress)
		
		# Apply the saved player details
		if data.has("user"):
			user = User.from_dictionary(data["user"])
		else:
			user = User.new("")
		
		print("Loaded user", user)
		
		# Handle new state additions that weren't part of first save
		progress[KEY_WATCH_INTRO] = data["progress"].get(KEY_WATCH_INTRO, false)
		
		# Apply progress to games operational level data
		LevelData.current_level_index = progress[KEY_CURRENT_LEVEL]
		
		print("Has completed game?", has_completed_game())
	else:
		print("failed", status)

# Save the game state to file
func save() -> void:
	print("Saving Game State...")
	var save_data := {
		"progress" : progress,
		"user" : user.to_var()
	}
	var data_as_string := var2str(save_data)
	print(data_as_string);
	
	var file := File.new()
	#warning-ignore:return_value_discarded
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_string(data_as_string)
	file.close()
	print("done")
	
# Get the unique player identifier (used for analytics and leaderboards)	
func get_player_identifier() -> String:
	return user.identifier
	
# Set the player identifier
func set_player_identifier(identifier:String) -> void:
	user.identifier = identifier
	
# Set the current level based on its index in the levels array
func set_current_level(level_index) -> void:
	progress[KEY_CURRENT_LEVEL] = level_index

# Progress the players current level
# Only if the level index is greater than current level will it be set
func progress_current_level(level_index) -> void:
	if level_index > progress[KEY_CURRENT_LEVEL]:
		# Set the current level
		set_current_level(level_index)
		
	# Save the updated game state to file
	save()		

# Determine if the player has completed the game
func has_completed_game() -> bool:
	return progress[KEY_CURRENT_LEVEL] >= LevelData.levelsArray.size() - 1

# Set whether player has watched the story intro
func set_has_watched_story_intro(watched) -> void:
	progress[KEY_WATCH_INTRO] = watched
	save()
	
# Get whether player has watched the story intro
func get_has_watched_story_intro() -> bool:
	return progress[KEY_WATCH_INTRO]
	

var prev_progress = null
func cheat(value):
	if value:
		print("Cheat enabled")
		# Set cheat progress settings which enables all levels
		prev_progress = progress.duplicate(true);
		
		print("Previous progress", prev_progress)
		
		# Set level to the maximum
		set_current_level(LevelData.get_levels().size() - 1)  
	
		print("Current progress", progress)
	else:
		print("Cheat disabled")
		print(prev_progress)		
		# Uncheat by restoring current progress
		progress = prev_progress.duplicate(true)


class User:
	var identifier:String
	
	func _init(identifier:String):
		self.identifier = identifier

	static func from_dictionary(dict:Dictionary) -> User:
		var identifier = dict.identifier if dict.has("identifier") else null
		return User.new(identifier)
		
	func to_var():
		return { 
			"identifier": identifier
		}

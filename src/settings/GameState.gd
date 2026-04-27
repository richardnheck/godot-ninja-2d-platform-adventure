extends Node

# Game save state saved in
# C:\Users\richa\AppData\Roaming\Godot\app_userdata\Castle Yokai
# when running locally
# When run in the browser, it is saved in a virtual filesystem stored within your browser's internal database
# In Chrome, go to developer tools storage -> IndexedDB -> FILE_DATA to find the key.  It is not possible to view the actual data as it is displayed as an array of bytes
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
var level_results:LevelResults = null

# This is for remembering the latest level time so it can be displayed in a different scene
# This is required when there is no pause between the end of the level and the transition to a cutscene
# which occurs at the end of Level 6's and at the end of the Boss levels.  So we need to grab these
# value in order to show the time to the user at the start of the cutscene
var latest_level_time_formatted:String = ""
var latest_level_time_status:String = ""


func _ready():
	print("GameState ready")
	
	# Load the save state
	load_save()

# Load data from game save file
func load_save() -> void:
	DebugLog.log("Loading Game State from file...") 
	
	# Read the save file
	var file := File.new()
	var status = file.open(SAVE_FILE_PATH, File.READ)
	if status == OK:
		DebugLog.log("Loading save file success")
		# File opened successfully
		var data_variant = str2var(file.get_as_text())
		var data:Dictionary = {}
		if typeof(data_variant) == TYPE_DICTIONARY:
			# successfully contains data to be converted to a dictionary
			data = data_variant
			
		DebugLog.log(JSON.print(data))
		
		file.close()
	
		# Apply the saved progress to the local progress
		if data.has("progress"):
			progress = data["progress"]
			# Handle new state additions that weren't part of first save
			progress[KEY_WATCH_INTRO] = data["progress"].get(KEY_WATCH_INTRO, false)
		
			# Apply progress to games operational level data
			LevelData.current_level_index = progress[KEY_CURRENT_LEVEL]
		
		# Apply the saved player details
		if data.has("user"):
			user = User.from_dictionary(data["user"])
		else:
			user = User.new("")
		
		# Apply the saved level results
		if data.has("level_results"):
			level_results = LevelResults.from_dictionary(data["level_results"])
		else:
			# If there are no level results then this is likely to be from an old demo
			# build, so we want to also ensure that the player starts from the beginning
			# again in order to build up a complete level result history, especially since
			# the game completion event gets time by adding up all level times
			level_results  = LevelResults.new()
			progress[KEY_CURRENT_LEVEL] =  0
			progress[KEY_WATCH_INTRO] = false
			LevelData.current_level_index = 0
			
	else:
		DebugLog.log("Loading save file failed: err = $s" % [status])
		# NB: progress isn't a class and is already created and initialised
		user = User.new("")
		level_results  = LevelResults.new()
		

# Save the game state to file
func save() -> void:
	print("Saving Game State...")
	var save_data := {
		"progress" : progress,
		"user" : user.to_var(),
		"level_results" : level_results.to_var()
	}
	var data_as_string := var2str(save_data)
	
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
	
# Get the player display name (used for analytics and leaderboards)	
func get_player_display_name() -> String:
	return user.display_name
	
# Set the player display_name
func set_player_display_name(display_name:String) -> void:
	print("set player display naem", display_name)
	user.display_name = display_name	
	
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

# Update local level result 
# This will be called when a player completes a level
func update_level_result(level_index:int, completion_time:float, deaths:int) -> LevelResult:
	var updated_level_result = level_results.update_level_result(level_index, completion_time, deaths)
	save()
	return updated_level_result

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

func reset_progress() -> void:
	set_has_watched_story_intro(false)
	set_current_level(0)
	level_results  = LevelResults.new()
	save()
	

class User:
	var identifier:String
	var display_name:String
	
	func _init(identifier:String, display_name:String = "Unknown"):
		self.identifier = identifier
		self.display_name = display_name

	static func from_dictionary(dict:Dictionary) -> User:
		var identifier = dict.identifier if dict.has("identifier") else null
		var display_name = dict.display_name if dict.has("display_name") else "Unknown"
		return User.new(identifier, display_name)
		
	func to_var():
		return { 
			"identifier": identifier,
			"display_name" : display_name
		}
	
	func to_string() -> String:
		return JSON.print(self.to_var())

class LevelResults:
	var levels:Array	# Array<LevelResult>
	
	func _init(levels:Array = []):
		if levels:
			self.levels = levels
		else:
			# Initialise empty results for all the playable levels
			for level_index in range (LevelData.get_playable_level_count()):
				self.levels.append(LevelResult.new())
	
	static func from_dictionary(dict:Dictionary) -> LevelResults:
		var levels:Array = []  # Array<LevelResult>
		var levels_from_dict:Array = dict.levels if dict.has("levels") else null
		
		if levels_from_dict:
			for level in levels_from_dict:
				var completion_time:float = level.completion_time if "completion_time" in level else 0.0
				var timestamp:int = level.timestamp if "timestamp" in level else 0
				var deaths:int = level.deaths if "deaths" in level else 0
				var previous_completion_time:float = level.previous_completion_time if "previous_completion_time" in level else 0.0
				var previous_timestamp:int = level.previous_timestamp if "previous_timestamp" in level else 0
				var previous_deaths:int = level.previous_deaths if "previous_deaths" in level else 0
				var latest_completion_time:float = level.latest_completion_time if "latest_completion_time" in level else 0.0
				var latest_timestamp:int = level.latest_timestamp if "latest_timestamp" in level else 0
				var latest_deaths:int = level.latest_deaths if "latest_deaths" in level else 0
				levels.append(LevelResult.new(completion_time, timestamp, deaths, previous_completion_time, previous_timestamp, latest_deaths, latest_timestamp, latest_deaths))
			return LevelResults.new(levels)
		else:	
			return LevelResults.new()
		
	func to_var():
		var levels_var_array = []
		for level in levels:
			levels_var_array.append(level.to_var())
		return { 
			"levels": levels_var_array
		}
			
	func update_level_result(level_index:int, completion_time:float, deaths:int) -> LevelResult:
		if level_index >= levels.size(): return null
		var level_result:LevelResult = levels[level_index]	
		level_result.update(completion_time, deaths)
		return level_result
		
	func get_level_result(level_index:int) -> LevelResult:
		if level_index >= levels.size(): return null
		return levels[level_index]
	
	func get_total_completion_time() -> float:
		var completion_time = 0.0
		for level in levels:
			completion_time = completion_time + level.completion_time
		return completion_time
	
	func get_total_deaths() -> int:
		var deaths = 0
		for level in levels:
			deaths = deaths + level.deaths
		return deaths	

class LevelResult:
	# Best current result
	var completion_time:float   # completion time of level in seconds
	var timestamp:int			# unix timestamp in msecs (compatible with Talo analytics)
	var deaths:int				# number of deaths for the level
	
	# Previous best result.  Will get set when a better result is updated
	var previous_completion_time:float
	var previous_timestamp:int
	var previous_deaths:int
	
	# Players latest (i.e most recent) result
	var latest_completion_time:float
	var latest_timestamp:int
	var latest_deaths:int
	
	func _init(completion_time:float = 0, timestamp:int = 0, deaths:int = 0, previous_completion_time:float = 0, previous_timestamp:int = 0, previous_deaths:int = 0, latest_completion_time:float = 0, latest_timestamp:int = 0, latest_deaths:int = 0):
		self.completion_time = completion_time
		self.timestamp = timestamp
		self.deaths = deaths
		self.previous_completion_time = previous_completion_time
		self.previous_timestamp = previous_timestamp
		self.previous_deaths = previous_deaths
		self.latest_completion_time = latest_completion_time
		self.latest_timestamp = latest_timestamp
		self.latest_deaths = latest_deaths
		
	# Update the result
	# Returns true if a better result, false otherwise
	func update(completion_time:float = 0, deaths:int = 0) -> bool:
		# Always record the latest result
		self.latest_completion_time = completion_time
		self.latest_timestamp = _get_timestamp_msec()
		self.latest_deaths = deaths
		
		if self.completion_time == 0.0 or (completion_time > 0 and completion_time <= self.completion_time):
			# Update the record since this is a better result (i.e. faster)
			# First the current record as the previous
			self.previous_completion_time = self.completion_time
			self.previous_timestamp = self.timestamp
			self.previous_deaths = self.deaths
			
			# Now update the new result
			self.completion_time = completion_time
			self.timestamp = _get_timestamp_msec()
			self.deaths = deaths
			return true
		else:
			# level result wasn't updated with a better time
			return false
	
	# Return the time difference between latest result and best result
	func get_completion_time_diff():
		if self.latest_completion_time == self.completion_time:
			# latest time was the best time
			return self.latest_completion_time - self.previous_completion_time if self.previous_completion_time > 0 else 0
		else:
			# latest time wasn't the best time
			return self.latest_completion_time - self.completion_time
	
	func is_completed() -> bool:
		return completion_time > 0;
	
	func to_var():
		return {
			"completion_time": completion_time,
			"timestamp" : timestamp,
			"deaths" :deaths,
			"previous_completion_time": previous_completion_time,
			"previous_timestamp" : previous_timestamp,
			"previous_deaths" : previous_deaths,
			"latest_completion_time": latest_completion_time,
			"latest_timestamp" : latest_timestamp,
			"latest_deaths" : latest_deaths
		}

	static func from_dictionary(dict:Dictionary) -> LevelResult:
		var completion_time = dict.completion_time if dict.has("completion_time") else 0.0
		var timestamp = dict.timestamp if dict.has("timetamp") else 0
		var deaths = dict.deaths if dict.has("deaths") else 0
		var previous_completion_time = dict.previous_completion_time if dict.has("previous_completion_time") else 0.0
		var previous_timestamp = dict.previous_timestamp if dict.has("previous_timetamp") else 0
		var previous_deaths = dict.previous_deaths if dict.has("previous_deaths") else 0
		var latest_completion_time = dict.previous_completion_time if dict.has("latest_completion_time") else 0.0
		var latest_timestamp = dict.previous_timestamp if dict.has("latest_timetamp") else 0
		var latest_deaths = dict.previous_deaths if dict.has("latest_deaths") else 0
		return LevelResult.new(completion_time, timestamp, deaths, previous_completion_time, previous_timestamp, previous_deaths, latest_completion_time, latest_timestamp, latest_deaths)

	# Get the current timestamp in unix msecs (compatible with Taol analytics)
	func _get_timestamp_msec() -> int:
		return int(ceil(Time.get_unix_time_from_system()) * 1000)	

extends Node
signal key_status_changed

const WORLD1 = 1	# World1 - Beneath the castle (cave levels)
const WORLD2 = 2	# World2 - Within the Wals
const WORLD3 = 3    # World3 - Inside the Tower
const GAME_END = 4

const CAVE_LEVELS_PATH = "res://src/levels/CaveLevels/CaveLevel"
const WORLD2_LEVELS_PATH = "res://src/levels/World2Levels/World2Level_"
const WORLD3_LEVELS_PATH = "res://src/levels/World3Levels/World3Level_"

# The name of the AudioStreamPlayer node of the background music in AudioManager
const CAVE_LEVEL_BGM = "Bgm_CaveLevelTheme"
const LEVEL_SELECT_SCREENS_PATH = "res://src/UI/LevelSelectScreens/"

# Game save state saved in
# C:\Users\richa\AppData\Roaming\Godot\app_userdata\Castle Yokai

var worldsArray = [
	{ "world": WORLD1, "level_select_scene": LEVEL_SELECT_SCREENS_PATH + "CaveLevelSelect.tscn"},
	{ "world": WORLD2, "level_select_scene": LEVEL_SELECT_SCREENS_PATH + "World2LevelSelect.tscn"},
	{ "world": WORLD3, "level_select_scene": LEVEL_SELECT_SCREENS_PATH + "World3LevelSelect.tscn"},
	{ "world": GAME_END, "level_select_scene": "res://src/UI/CutScenes/GameEndCutscene/GameEndCutScene.tscn"},
]

var levelsArray = [
	# World 1
	# Had to reduce number of levels down to 6 to make game finishable
	{"world": WORLD1, "name" : "Time to learn young Grasshopper",  "scene_path" : CAVE_LEVELS_PATH + "LearningMechanics.tscn", "bgm" : CAVE_LEVEL_BGM },
	{"world": WORLD1, "name" : "Master thyself and Jump" , "scene_path" : CAVE_LEVELS_PATH + "ArtOfJumping.tscn", "bgm" : CAVE_LEVEL_BGM },
	#{"world": WORLD1, "name" : "Across the Abyss", "scene_path" : CAVE_LEVELS_PATH + "AcrossTheAbyss.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Those rocks don't look solid", "scene_path" : CAVE_LEVELS_PATH + "CrumblingRocksLevel2.tscn", "bgm" : CAVE_LEVEL_BGM},
	#{"world": WORLD1, "name" : "Oh so many spikey things", "scene_path" : CAVE_LEVELS_PATH + "ShortAndSpikey.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Sliding slowly down the Wall", "scene_path" : CAVE_LEVELS_PATH + "OfWallAndSlide.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Death from Above", "scene_path" : CAVE_LEVELS_PATH + "DeathFromAbove.tscn", "bgm" : CAVE_LEVEL_BGM},
	#{"world": WORLD1, "name" : "Crumble me Crazy", "scene_path" : CAVE_LEVELS_PATH + "CrabAppleCrumble.tscn", "bgm" : CAVE_LEVEL_BGM},
	
	# TODO: Not sure 100% which is the final level
	#{"world": WORLD1, "name" : "ThundercrushC", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns1.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Claustrophobic Caverns", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns2.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "", "scene_path" : "res://src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/CaveLevel/BossClearCutScene.tscn"},
	
	# World 2
	{"world": WORLD2, "name" : "Level1", "scene_path" : WORLD2_LEVELS_PATH + "Level1.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "Level2", "scene_path" : WORLD2_LEVELS_PATH + "Level2.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "Level3", "scene_path" : WORLD2_LEVELS_PATH + "Level3.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "Level4", "scene_path" : WORLD2_LEVELS_PATH + "Level4.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "Level5", "scene_path" : WORLD2_LEVELS_PATH + "Level5.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "Level6", "scene_path" : WORLD2_LEVELS_PATH + "Level6.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD2, "name" : "", "scene_path" :  "res://src/UI/CutScenes/World2/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/World2/BossClearCutScene.tscn"},

	# World 3
	{"world": WORLD3, "name" : "Level1", "scene_path" : WORLD3_LEVELS_PATH + "Level1.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "Level2", "scene_path" : WORLD3_LEVELS_PATH + "Level2.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "Level3", "scene_path" : WORLD3_LEVELS_PATH + "Level3.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "Level4", "scene_path" : WORLD3_LEVELS_PATH + "Level4.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "Level5", "scene_path" : WORLD3_LEVELS_PATH + "Level5.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "Level6", "scene_path" : WORLD3_LEVELS_PATH + "Level6.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD3, "name" : "", "scene_path" :  "res://src/UI/CutScenes/World3/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/World3/BossClearCutScenePart1.tscn"},
	
	# GAME END
	{"world": GAME_END, "name" : "The end", "scene_path" : "res://src/UI/CutScenes/GameEndCutscene/GameEndCutScene.tscn", "bgm" : CAVE_LEVEL_BGM},
];


# An identifier of the checkpoint reached, empty string if no checkpoints reached
var level_checkpoint_reached = Constants.NO_CHECKPOINT
var checkpoint_reached_with_key = false

var current_level_index = 0;

var is_reload = false

var has_key: = false setget set_has_key

# Get all levels
func get_levels() -> Array:
	return levelsArray
	
# Get the index of the boss level within the level data	
func get_boss_level_index(world):
	for i in range(0, levelsArray.size()):
		var level = levelsArray[i]
		if level.has("is_boss") and level.is_boss and level.world == world:
			return i
	return -1
	
# Goto the boss level
func goto_boss_level(world, changeScene = true) -> String:
	var boss_level_index = get_boss_level_index(world)
	if boss_level_index > -1:
		return goto_level(boss_level_index, changeScene)
	return ""

# Goto the cutscene after beating the boss
func goto_boss_clear_cutscene(world, changeScene = true) -> String:
	var boss_level_index = get_boss_level_index(world)
	if boss_level_index > -1:
		var boss_level = levelsArray[boss_level_index]
		if changeScene:
			#warning-ignore:return_value_discarded
			get_tree().change_scene(boss_level.boss_clear_scene_path)
		return boss_level.boss_clear_scene_path
	return ""
	
# Goto the level specified by its index 
func goto_level(levelIndex, changeScene = true) -> String:
	var level = get_levels()[levelIndex]
	current_level_index = levelIndex
	
	# Reset flags
	level_checkpoint_reached = Constants.NO_CHECKPOINT
	has_key = false
	checkpoint_reached_with_key = false
	is_reload = false
	
	if changeScene:
		#warning-ignore:return_value_discarded
		get_tree().change_scene(level.scene_path)
	return level.scene_path
 
# Goto the next level
func goto_next_level() -> void:
	print("goto_next_level")
	if current_level_index < levelsArray.size() - 1:	
		current_level_index += 1
	
	print("current_level_index = " + String(current_level_index))
	
	# Reset flags
	level_checkpoint_reached = Constants.NO_CHECKPOINT
	has_key = false
	checkpoint_reached_with_key = false
	is_reload = false
	#warning-ignore:return_value_discarded
	get_tree().change_scene(levelsArray[current_level_index].scene_path)

# Reload the level
func reload_level() -> void:
	is_reload = true
	
	if level_checkpoint_reached == Constants.NO_CHECKPOINT and has_key:
		# Clear the key status if the player did not reach a checkpoint with the key
		has_key = false
	elif level_checkpoint_reached != Constants.NO_CHECKPOINT and has_key and not checkpoint_reached_with_key:
		# Player has a key and has hit a checkpoint, but they did not have the key for that checkpoint
		# So on reload they do not have the key
		has_key = false
		
# Set the checkpoint that has been reached
func set_checkpoint_reached(checkpoint_id:String) -> void:
	level_checkpoint_reached = checkpoint_id
	checkpoint_reached_with_key = has_key
	
# Get the background music (bgm) for the specified level
func get_level_bgm(level_scene_path) -> String:
	for i in range(0, levelsArray.size()):
		if levelsArray[i]["scene_path"] == level_scene_path:
			return levelsArray[i]["bgm"]
	return ""
	
# Get the name for the specified level
func get_level_name(level_scene_path) -> String:
	for i in range(0, levelsArray.size()):
		if levelsArray[i]["scene_path"] == level_scene_path:
			return levelsArray[i]["name"]
	return ""	
	
func set_has_key(value:bool) -> void:
	has_key = value
	emit_signal("key_status_changed", has_key)

# Get the Level Select Scene for the current world
func get_current_world_level_select_scene() -> String:
	var current_level = get_levels()[current_level_index]
	var current_world = current_level["world"]
	for i in range(0, worldsArray.size()):
		if worldsArray[i]["world"] == current_world:
			return worldsArray[i]["level_select_scene"]
	return ""

# Get the world based on the specified level index
func get_world(level_index) -> int:
	var level = get_levels()[level_index]
	return level["world"]

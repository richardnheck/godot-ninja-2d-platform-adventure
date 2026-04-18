extends Node
signal key_status_changed

const WORLD1 = 1	# World1 - Beneath the castle (cave levels)
const WORLD2 = 2	# World2 - Within the Wals
const WORLD3 = 3    # World3 - Inside the Tower
const GAME_END = 4

const LEVELS_PER_WORLD = 7

const WORLD1_LEVELS_PATH = "res://src/levels/CaveLevels/World1Level_"
const WORLD2_LEVELS_PATH = "res://src/levels/World2Levels/World2Level_"
const WORLD3_LEVELS_PATH = "res://src/levels/World3Levels/World3Level_"

# The name of the AudioStreamPlayer node of the background music in AudioManager
const CAVE_LEVEL_BGM = "Bgm_CaveLevelTheme"
const WORLD2_LEVEL_BGM = "Bgm_World2LevelTheme"
const WORLD3_LEVEL_BGM = "Bgm_World3LevelTheme"
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
	# World 1 (start level index = 0)
	# Had to reduce number of levels down to 6 to make game finishable
	{"world": WORLD1, "name" : "Time to learn young gakusei",  "scene_path" : WORLD1_LEVELS_PATH + "Level1.tscn", "bgm" : CAVE_LEVEL_BGM },
	{"world": WORLD1, "name" : "Jump did you say? Sensei?" , "scene_path" : WORLD1_LEVELS_PATH + "Level2.tscn", "bgm" : CAVE_LEVEL_BGM },
	{"world": WORLD1, "name" : "Unstable ishi", "scene_path" : WORLD1_LEVELS_PATH + "Level3.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Kabe sliding all the way", "scene_path" : WORLD1_LEVELS_PATH + "Level4.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Shiver me shi", "scene_path" : WORLD1_LEVELS_PATH + "Level5.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Deadly dokutsu", "scene_path" : WORLD1_LEVELS_PATH + "Level6.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "World1 Boss", "scene_path" : "res://src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/CaveLevel/BossClearCutScene.tscn"},
	#{"world": WORLD1, "name" : "Across the Abyss", "scene_path" : WORLD1_LEVELS_PATH + "AcrossTheAbyss.tscn", "bgm" : CAVE_LEVEL_BGM},
	#{"world": WORLD1, "name" : "Oh so many spikey things", "scene_path" : WORLD1_LEVELS_PATH + "ShortAndSpikey.tscn", "bgm" : CAVE_LEVEL_BGM},
	#{"world": WORLD1, "name" : "Crumble me Crazy", "scene_path" : WORLD1_LEVELS_PATH + "CrabAppleCrumble.tscn", "bgm" : CAVE_LEVEL_BGM},
	#{"world": WORLD1, "name" : "ThundercrushC", "scene_path" : WORLD1_LEVELS_PATH + "ClaustrophicCaverns1.tscn", "bgm" : CAVE_LEVEL_BGM},
	
	# World 2  (start index = 7)
	{"world": WORLD2, "name" : "Hold your Hori", "scene_path" : WORLD2_LEVELS_PATH + "Level1.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "Klimb that Kuruwa", "scene_path" : WORLD2_LEVELS_PATH + "Level2.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "My My Maru", "scene_path" : WORLD2_LEVELS_PATH + "Level3.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "Uh Oh Ote-mon", "scene_path" : WORLD2_LEVELS_PATH + "Level4.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "Help! Help! Hori!", "scene_path" : WORLD2_LEVELS_PATH + "Level5.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "Towards the Tenshu", "scene_path" : WORLD2_LEVELS_PATH + "Level6.tscn", "bgm" : WORLD2_LEVEL_BGM},
	{"world": WORLD2, "name" : "World2 Boss", "scene_path" :  "res://src/UI/CutScenes/World2/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/World2/BossClearCutScene.tscn", "boss_scene_path": "res://src/levels/World2Levels/World2Level_Boss.tscn"},

	# World 3 (start index = 14)
	{"world": WORLD3, "name" : "Taste the Tenshu", "scene_path" : WORLD3_LEVELS_PATH + "Level1.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "Obake Kaidan", "scene_path" : WORLD3_LEVELS_PATH + "Level2.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "Master my Mushin", "scene_path" : WORLD3_LEVELS_PATH + "Level3.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "Heya, heya and heya", "scene_path" : WORLD3_LEVELS_PATH + "Level4.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "No yuka...no cry", "scene_path" : WORLD3_LEVELS_PATH + "Level5.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "Saigo no nobori", "scene_path" : WORLD3_LEVELS_PATH + "Level6.tscn", "bgm" : WORLD3_LEVEL_BGM},
	{"world": WORLD3, "name" : "World3 Boss", "scene_path" :  "res://src/UI/CutScenes/World3/BossintroCutScene.tscn", "is_boss" : true, "boss_clear_scene_path" : "res://src/UI/CutScenes/World3/BossClearCutScenePart1.tscn", "boss_scene_path": "res://src/levels/World3Levels/World3Level_Boss.tscn"},
	
	# GAME END (index = 21)
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
	
# Get the actual number of playable levels
func get_playable_level_count():
	return levelsArray.size() - 1	# -1 to exlude the game ending as it is a cutscene
	
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
	if current_level_index < levelsArray.size() - 1:	
		current_level_index += 1
	
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
	
# Determine whether a level is a boss level	
func is_boss_level(level_scene_path) -> bool:
	for i in range(0, levelsArray.size()):
		var level = levelsArray[i]
		if level.has("boss_scene_path") and level["boss_scene_path"] == level_scene_path:
			return level.has("is_boss") and level.is_boss
	return false
	
# Get the name for the specified level
func get_level_name(level_scene_path:String) -> String:
	for i in range(0, levelsArray.size()):
		if levelsArray[i]["scene_path"] == level_scene_path:
			return levelsArray[i]["name"]
	return ""	

# Get the name of the level given the index	
func get_level_name_by_index(level_index:int) -> String:
	var level = _get_level_by_index(level_index)
	return level.name	
	
func get_level(level_index):
	return _get_level_by_index(level_index)

func get_current_level():
	return _get_level_by_index(current_level_index)
		
# Get the scene file name of the level given the index	
func get_level_scene_by_index(level_index:int) -> String:
	var level = _get_level_by_index(level_index)
	return level.scene_path.get_file()

func _get_level_by_index(level_index:int):
	var max_index = levelsArray.size() - 1
	var index = level_index if level_index <= max_index else max_index
	return get_levels()[index]
	
func set_has_key(value:bool) -> void:
	has_key = value
	emit_signal("key_status_changed", has_key)

# Get the Level Select Scene for the current world
func get_current_world_level_select_scene() -> String:
	var max_index = levelsArray.size() - 1
	var index = current_level_index if current_level_index <= max_index else max_index
	var current_level = get_levels()[index]
	var current_world = current_level["world"]
	for i in range(0, worldsArray.size()):
		if worldsArray[i]["world"] == current_world:
			return worldsArray[i]["level_select_scene"]
	return ""

# Get the world based on the specified level index
func get_world(level_index) -> int:
	var max_index = levelsArray.size() - 1
	var index = level_index if level_index <= max_index else max_index
	var level = get_levels()[index]
	return level["world"]

func get_levels_for_world(world:int) -> Array:
	var levels = []
	for i in range(0, levelsArray.size()):
		if levelsArray[i]["world"] == world:
			levels.append(levelsArray[i])
	return levels

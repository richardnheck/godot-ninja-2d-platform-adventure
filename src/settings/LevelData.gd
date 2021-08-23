extends Node

const WORLD1 = 1	# Cave Levels
const WORLD2 = 2
const WORLD3 = 3

const CAVE_LEVELS_PATH = "res://src/levels/CaveLevels/CaveLevel"

# The name of the AudioStreamPlayer node of the background music in AudioManager
const CAVE_LEVEL_BGM = "Bgm_CaveLevelTheme"


var levelsArray = [
	{"world": WORLD1, "name" : "Time to learn young Grasshopper",  "scene_path" : CAVE_LEVELS_PATH + "LearningMechanics.tscn", "bgm" : CAVE_LEVEL_BGM },
	{"world": WORLD1, "name" : "Master thyself and Jump" , "scene_path" : CAVE_LEVELS_PATH + "ArtOfJumping.tscn", "bgm" : CAVE_LEVEL_BGM },
	{"world": WORLD1, "name" : "Across the Abyss", "scene_path" : CAVE_LEVELS_PATH + "AcrossTheAbyss.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Those rocks don't look solid", "scene_path" : CAVE_LEVELS_PATH + "CrumblingRocksLevel2.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Oh so many spikey things", "scene_path" : CAVE_LEVELS_PATH + "ShortAndSpikey.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Sliding slowly down the Wall", "scene_path" : CAVE_LEVELS_PATH + "OfWallAndSlide.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Death from Above", "scene_path" : CAVE_LEVELS_PATH + "DeathFromAbove.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Crumble me Crazy", "scene_path" : CAVE_LEVELS_PATH + "CrabAppleCrumble.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Claustrophobic Caverns", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns1.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "Now I'm getting Claustrophobic", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns2.tscn", "bgm" : CAVE_LEVEL_BGM},
	{"world": WORLD1, "name" : "", "scene_path" : "res://src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn", "is_boss" : true}
];


var level_checkpoint_reached = false

var current_level_index = 0;

var is_reload = false

# Get all levels
func get_levels() -> Array:
	return levelsArray
	
# Get levels by world
func get_levels_by_world(world) -> Array:
	if world == WORLD1:
		return ArrayUtil.filter(levelsArray, funcref(self, "is_world1_level"))
	else:
		return []


# Filter func to return only world one levels
func is_world1_level(levelObj) -> bool:
	return levelObj["world"] == WORLD1
	

# Goto the boss level
func goto_boss_level(changeScene = true) -> String:
	for i in range(0, levelsArray.size()):
		if levelsArray[i].has("is_boss"):
			return goto_level(i, changeScene)
	return ""
	
# Goto the level specified by its index 
func goto_level(levelIndex, changeScene = true) -> String:
	var level = LevelData.get_levels()[levelIndex]
	current_level_index = levelIndex
	level_checkpoint_reached = false
	is_reload = false
	if changeScene:
		get_tree().change_scene(level.scene_path)
	return level.scene_path
 
# Goto the next level
func goto_next_level() -> void:
	print("goto_next_level")
	if current_level_index < levelsArray.size() - 1:	
		current_level_index += 1
	else:
		current_level_index = 0
	
	print("current_level_index = " + String(current_level_index))
	
	level_checkpoint_reached = false
	get_tree().change_scene(levelsArray[current_level_index].scene_path)


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
	
# https://gdscript.com/how-to-save-and-load-godot-game-data
# func save():
#	var file = File.new()
#	file.open(FILE_NAME, File.WRITE)
#	file.store_string(to_json(player))
#	file.close()
#
#func load():
#	var file = File.new()
#	if file.file_exists(FILE_NAME):
#		file.open(FILE_NAME, File.READ)
#		var data = parse_json(file.get_as_text())
#		file.close()
#		if typeof(data) == TYPE_DICTIONARY:
#			player = data
#		else:
#			printerr("Corrupted data!")
#	else:
#		printerr("No saved data!")
		

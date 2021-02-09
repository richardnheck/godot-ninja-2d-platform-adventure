extends Node

const CAVE_LEVELS_PATH = "res://src/levels/CaveLevels/CaveLevel"

var levelsArray = [
	{ "name" : "Learning Mechanics",  "scene_path" : CAVE_LEVELS_PATH + "LearningMechanics.tscn" },
	{ "name" : "Art Of Jumping" , "scene_path" : CAVE_LEVELS_PATH + "ArtOfJumping.tscn" },
	{ "name" : "Across the Abyss", "scene_path" : CAVE_LEVELS_PATH + "AcrossTheAbyss.tscn"},
	{ "name" : "", "scene_path" : CAVE_LEVELS_PATH + "CrumblingRocksLevel2.tscn"},
	{ "name" : "Short and Spikey", "scene_path" : CAVE_LEVELS_PATH + "ShortAndSpikey.tscn"},
	{ "name" : "Of Wall and Slide", "scene_path" : CAVE_LEVELS_PATH + "OfWallAndSlide.tscn"},
	{ "name" : "Crab Apple Crumble", "scene_path" : CAVE_LEVELS_PATH + "CrabAppleCrumble.tscn"},
	{ "name" : "Death from Above", "scene_path" : CAVE_LEVELS_PATH + "DeathFromAbove.tscn"},
	{ "name" : "Claustrophic Caverns #1", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns1.tscn"},
	{ "name" : "Claustrophic Caverns #2", "scene_path" : CAVE_LEVELS_PATH + "ClaustrophicCaverns2.tscn"},
	{ "name" : "Cave Level Boss", "scene_path" : "res://src/UI/CutScenes/CaveLevel/BossintroCutScene.tscn", "is_boss" : true}
];

	
var levelsArray2 = [
	CAVE_LEVELS_PATH + "LearningMechanics.tscn",
	CAVE_LEVELS_PATH + "ArtOfJumping.tscn",
	CAVE_LEVELS_PATH + "GoAheadJump.tscn",
	CAVE_LEVELS_PATH + "CrumblingRocksLevel2.tscn",
	CAVE_LEVELS_PATH + "ShapeLikeSWithSpikeyRocks.tscn",
	CAVE_LEVELS_PATH + "CrabAppleCrumble.tscn",
	CAVE_LEVELS_PATH + "OfWallAndSlide.tscn",
	CAVE_LEVELS_PATH + "StairwayOfTrouble.tscn",
	CAVE_LEVELS_PATH + "ClaustrophicCaverns.tscn",
	CAVE_LEVELS_PATH + "BossScene.tscn",
	
	CAVE_LEVELS_PATH + "LearnWallJumpImproved.tscn",
	CAVE_LEVELS_PATH + "LearnCrumblingRocks.tscn",
	CAVE_LEVELS_PATH + "CrumblingRocksLevel.tscn",
	"res://src/levels/TmpSpikeyRocksLevel.tscn",
	"res://src/levels/TmpBambooSpikesLevel.tscn",
	CAVE_LEVELS_PATH + "Platforms1.tscn",
	CAVE_LEVELS_PATH + "1.tscn",
	CAVE_LEVELS_PATH + "ClaustrophobicClimb.tscn",
	
	
	#"res://src/levels/Level2CuteCavesTheme.tscn",
	#"res://src/levels/Level2.tscn",
	#"res://src/levels/Level3.tscn",
	#"res://src/levels/WallJumpTestLevel.tscn"
]

var level_checkpoint_reached = false

var current_level_index = 0;

func get_levels() -> Array:
	return levelsArray

func goto_boss_level() -> void:
	for i in range(0, levelsArray.size()):
		if levelsArray[i].has("is_boss"):
			goto_level(i)
	 
func goto_level(levelIndex) -> void:
	var level = LevelData.get_levels()[levelIndex]
	current_level_index = levelIndex
	level_checkpoint_reached = false
	get_tree().change_scene(level.scene_path)


func goto_next_level() -> void:
	if current_level_index < levelsArray.size() - 1:
		current_level_index += 1
	else:
		current_level_index = 0
			
	level_checkpoint_reached = false
	get_tree().change_scene(levelsArray[current_level_index].scene_path)

	
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
		

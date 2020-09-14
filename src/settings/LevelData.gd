extends Node

const CAVE_LEVELS_PATH = "res://src/levels/CaveLevels/CaveLevel"

var levelsArray = [
	CAVE_LEVELS_PATH + "1.tscn",
	CAVE_LEVELS_PATH + "LearnWallJumpImproved.tscn",
	CAVE_LEVELS_PATH + "LearnCrumblingRocks.tscn",
	CAVE_LEVELS_PATH + "CrumblingRocksLevel.tscn",
	CAVE_LEVELS_PATH + "CrumblingRocksLevel2.tscn",
	"res://src/levels/TmpSpikeyRocksLevel.tscn",
	"res://src/levels/TmpBambooSpikesLevel.tscn",
	CAVE_LEVELS_PATH + "ShapeLikeSWithSpikeyRocks.tscn",
	CAVE_LEVELS_PATH + "Platforms1.tscn",
	CAVE_LEVELS_PATH + "CrabAppleCrumble.tscn",
	CAVE_LEVELS_PATH + "ClaustrophobicClimb.tscn",
	CAVE_LEVELS_PATH + "StairwayOfTrouble.tscn",
	CAVE_LEVELS_PATH + "BossScene.tscn",
	#"res://src/levels/Level2CuteCavesTheme.tscn",
	#"res://src/levels/Level2.tscn",
	#"res://src/levels/Level3.tscn",
	#"res://src/levels/WallJumpTestLevel.tscn"
]

var level_checkpoint_reached = false

var current_level_index = 0;

func get_levels() -> Array:
	return levelsArray
	

func goto_level(levelIndex) -> void:
	var levelPath = LevelData.get_levels()[levelIndex]
	current_level_index = levelIndex
	level_checkpoint_reached = false
	get_tree().change_scene(levelPath)


func goto_next_level() -> void:
	if current_level_index < levelsArray.size() - 1:
		current_level_index += 1
	else:
		current_level_index = 0
			
	level_checkpoint_reached = false
	get_tree().change_scene(levelsArray[current_level_index])

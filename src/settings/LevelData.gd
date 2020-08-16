extends Node

const CAVE_LEVELS_PATH = "res://src/levels/CaveLevels/CaveLevel"

var levelsArray = [
	CAVE_LEVELS_PATH + "1.tscn",
	CAVE_LEVELS_PATH + "2.tscn",
	"res://src/levels/TmpSpikeyRocksLevel.tscn",
	"res://src/levels/CrumblingRocksLevel.tscn",
	"res://src/levels/CrumblingRocksLevel2.tscn",
	
	#"res://src/levels/Level2CuteCavesTheme.tscn",
	#"res://src/levels/Level2.tscn",
	#"res://src/levels/Level3.tscn",
	#"res://src/levels/WallJumpTestLevel.tscn"
]

var current_level_index = 0;

func goto_next_level() -> void:
	print("goto next level")
	if current_level_index < levelsArray.size() - 1:
		current_level_index += 1
	else:
		current_level_index = 0
			
	get_tree().change_scene(levelsArray[current_level_index])

extends Node

var levelsArray = [
	"res://src/levels/Level1.tscn",
	"res://src/levels/Level2.tscn",
	"res://src/levels/Level3.tscn",
	"res://src/levels/WallJumpTestLevel.tscn"
]

var current_level_index = 0;

func goto_next_level() -> void:
	print("goto next level")
	if current_level_index < levelsArray.size() - 1:
		current_level_index += 1
	else:
		current_level_index = 0
			
	get_tree().change_scene(levelsArray[current_level_index])

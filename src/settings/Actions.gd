extends Node

# These actions must match the Input maps defined
const JUMP = "jump"
const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"

# These actions are specifically for moving player during cutscenes
# Even though they are not mapped to any input devices they must still be 
# defined in the Project Settings InputMap
const JUMP_CUTSCENE = "jump_cutscene"
const MOVE_LEFT_CUTSCENE = "move_left_cutscene"
const MOVE_RIGHT_CUTSCENE = "move_right_cutscene"

# Set to true to essentially disable input to use the specific cutscene
# actions so the player can be controlled programatically in a cutscene
# NB: I couldn't figure out how to disable user input whilst still being able
# to emit programmatic events in order to move player in cutscenes, so this is
# my own solution
var cutscene_actions_enabled = false

func use_cutscene_actions()->void:
	cutscene_actions_enabled = true
	
func use_normal_actions()->void:
	cutscene_actions_enabled = false	

func get_action_jump() -> String:
	return self.JUMP if not cutscene_actions_enabled else self.JUMP_CUTSCENE
	
func get_action_move_left() -> String:
	return self.MOVE_LEFT if not cutscene_actions_enabled else self.MOVE_LEFT_CUTSCENE

func get_action_move_right() -> String:
	return self.MOVE_RIGHT if not cutscene_actions_enabled else self.MOVE_RIGHT_CUTSCENE


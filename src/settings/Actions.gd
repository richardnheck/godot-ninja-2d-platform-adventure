extends Node

# These actions must match the Input maps defined
const JUMP = "jump"
const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"

# These actions are specifically for moving player during cutscenes
const JUMP_CUTSCENE = "jump_cutscene"
const MOVE_LEFT_CUTSCENE = "move_left_cutscene"
const MOVE_RIGHT_CUTSCENE = "move_right_cutscene"


func get_action_jump() -> String:
	return self.JUMP
	
func get_action_move_left() -> String:
	return self.MOVE_LEFT

func get_action_move_right() -> String:
	return self.MOVE_RIGHT

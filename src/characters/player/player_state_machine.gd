extends "res://src/utility/state_machine/state_machine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"wall_slide" : $WallSlide,
		"wall_jump" : $WallJump,
		"die" : $Die,
		"celebrate" : $Celebrate,
		"air_jump" : $AirJump,
		"talk" : $Talk
	}

var jumpPressedRemember = 0

func _change_state(state_name:String, spring_impulse:Vector2 = Vector2.ZERO):
	print("change_state: " + state_name)
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if current_state == $Die:
		return
		
	if state_name in ["jump"]:
		states_stack.push_front(states_map[state_name])
	
	if state_name == "jump":# and current_state == $Move:
		$Jump.initialize($Move.speed, $Move.velocity, spring_impulse)
	if state_name == "move" and current_state == $Jump:
		$Move.initialize($Jump.jumpPressedRemember)
	if state_name == "idle" and current_state == $Jump:
		$Idle.initialize($Jump.jumpPressedRemember)
	if state_name == "air_jump" and current_state == $Jump:
		$AirJump.initialize($Jump.speed, $Jump.velocity)	
	._change_state(state_name)


func _input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
#	if event.is_action_pressed("attack"):
#		if current_state in [$Attack, $Stagger]:
#			return
#		_change_state("attack")
#		return
	current_state.handle_input(event)




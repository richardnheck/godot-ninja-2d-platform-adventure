extends "../motion.gd"

func enter():
	if owner.is_on_floor():
		# This is entered when player starts moving on the ground
		# TODO: animate a start run burst of dust
		pass
		


#var groundedRememberTime = 0.2
#var groundedRemember = 0
#var jumpPressedRememberTime = 0.2
#var jumpPressedRemember = 0
#
#func handle_input(event):
#	if event.is_action_pressed(Actions.JUMP):
#		jumpPressedRemember = jumpPressedRememberTime
#
#	return .handle_input(event)
#
#
#func update(_delta):
#	jumpPressedRemember -= _delta
#	groundedRemember -= _delta
#
#	if owner.is_on_floor():
#		groundedRemember = groundedRememberTime
#
#	if (jumpPressedRemember > 0) and (groundedRemember > 0):
#		# Transition to jump state
#		jumpPressedRemember = 0
#		groundedRemember = 0
#		emit_signal("finished", "jump")

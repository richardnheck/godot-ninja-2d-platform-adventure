extends "res://src/utility/state_machine/state.gd"
# Collection of important methods to handle direction and animation.

export(float) var horizontal_speed = 125

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector2()

func handle_input(event):
	pass
	#if event.is_action_pressed("simulate_damage"):
	#	emit_signal("finished", "stagger")


func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength(Actions.MOVE_RIGHT) - Input.get_action_strength(Actions.MOVE_LEFT)
	#input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#	if Input.is_action_just_pressed(Actions.JUMP) and (owner.is_on_floor()):  #????or next_to_wall()):# I can jump when I'm on floor or next to the wall
#		input_direction.y = -1.0
#	else:
#		input_direction.y =  1.0

	return input_direction


func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
		
	# Handle sprite direction
	var sprite = owner.get_node("AnimatedSprite")
	if direction.x == 1:
		sprite.flip_h = false
	elif direction.x == -1:
		sprite.flip_h = true

func apply_gravity():
	velocity.y += 15;

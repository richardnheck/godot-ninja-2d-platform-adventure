extends "on_ground.gd"

#export(float) var max_walk_speed = 450
#export(float) var max_run_speed = 700
var just_landed = false
var on_ground = true
var particles_move:CPUParticles2D = null
var input_direction = 1

func enter():
	.enter()
	just_landed = false
	particles_move = owner.get_node("ParticlesMove")
	
	speed = 0.0
	velocity = Vector2()

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimatedSprite").play("run")

func exit():
	_show_move_particles(false)

func initialize(_jumpPressedRemember):
	jumpPressedRemember = _jumpPressedRemember


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	input_direction = get_input_direction()
	
	update_look_direction(input_direction)
	apply_gravity()

	speed = horizontal_speed
	velocity.x = speed * input_direction.x
	move(velocity)
	
	if owner.is_on_floor():
		if not on_ground:
			just_landed = true
			on_ground = true
		else:
			just_landed = false
			
		owner.get_node("AnimatedSprite").play("run")
		
		_show_move_particles(true)
	else:
		on_ground = false
		owner.get_node("AnimatedSprite").play("jump_down")
		
#	
	if just_landed:
		owner.do_landing()	
		
		
	if owner.is_on_floor() and !input_direction:
		_show_move_particles(false)
		emit_signal("finished", "idle")
		
	detect_and_transition_to_jump(_delta)
	detect_and_transition_to_wall_slide()

func _show_move_particles(show:bool):
	if show:
		particles_move.emitting = true
		particles_move.scale.x = input_direction.x
		particles_move.position.x = -6 * input_direction.x
	else:
		particles_move.emitting = false
		particles_move.restart()

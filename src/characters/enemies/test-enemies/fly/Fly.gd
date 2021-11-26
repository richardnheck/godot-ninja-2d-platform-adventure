extends KinematicBody2D

var direction = 1
var velocity = Vector2()
var counter = 0
var amp = 1/15.0
var vert_speed = 100
var counter_threshold = 500
const SPEED = 50

var can_check = true

func _physics_process(delta):

	# Move in cos wave pattern 
	velocity.y = cos(position.x * amp) * vert_speed * direction 
	velocity.x = SPEED * direction
	
	# Control direction 
	if direction == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	# Switch directions if at threshold or next to wall 
	if can_check and is_on_wall() || counter > counter_threshold:
		can_check = false
		$Timer.start()
		direction *= -1
		counter = 0
	
	counter += 1	
	velocity = move_and_slide(velocity)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.die()


func _on_Timer_timeout() -> void:
	can_check = true

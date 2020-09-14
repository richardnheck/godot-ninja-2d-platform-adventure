extends KinematicBody2D

var velocity = Vector2(40,0)
var speed = 40
var direction = 1
var vertical_direction = 1
var vertical_speed = 200

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velx = speed * direction
	var vely = vertical_speed * vertical_direction
	velocity.x = velx
	velocity.y = vely
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)

	if is_on_ceiling() or is_on_floor():
		vertical_direction = vertical_direction * -1;
	
	if is_on_floor():
		get_parent().get_node("ScreenShake").screen_shake(0.5,2,100)	
#	if is_on_wall():
#    if direction == left:
#        direction = right
#    elif direction == right:
#        direction = left

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


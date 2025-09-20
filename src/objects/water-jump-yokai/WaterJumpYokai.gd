extends RigidBody2D

export var max_impulse := 2000.0

var direction := Vector2.RIGHT setget set_direction
var impulse := 1000.0 setget set_impulse

var falling := false
onready var _sprite := $AnimatedSprite

var splash_scene = preload("res://src/objects/water-splash/WaterSplash.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 5
	print("gravity scale", gravity_scale)

func _physics_process(delta):
	
	if linear_velocity.y > 50:
		# when linear velocity is positive the fish is falling down
		falling = true
			
	if falling:	
		# when falling rotate the sprite so it is heading in the right direction
		_sprite.rotation_degrees = 180
		

func _on_body_entered(body: Node) -> void:
	print("body entered")
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("hit player")
		body.die()
#	else:
#		


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction


func set_impulse(new_impulse: float) -> void:
	apply_central_impulse(direction * new_impulse)


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# Area2D is used for detection of water trap
func _on_Area2D_body_entered(body):
	# Add a splash when leaving and hitting the water
	var splash_instance = splash_scene.instance()
	splash_instance.global_position = global_position + Vector2(0,0)
	get_parent().add_child(splash_instance)
	
	if linear_velocity.y > 0:
		# falling back in to water so remove
		queue_free()
	

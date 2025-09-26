extends Gun

onready var _sprite = $AnimatedSprite
onready var _blast = $AnimatedSprite/CanonBlastAnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_blast.visible = false
	
	# TODO: Not sure why this doesn't work
	#_sprite.rotate(direction.angle())
	#print_debug(name + " " + str(_sprite.rotation))
	
	# NB: I have no idea why just this code works
	if direction == Vector2(-1,0):
		_sprite.rotation_degrees = 180

func _shoot():
	._shoot()
	set_sprite_animation("shoot")
	_doBlast()
	
func set_sprite_animation(animation) -> void:
	if is_instance_valid(_sprite):
		_sprite.animation = animation
		_sprite.play(animation)

func _on_AnimatedSprite_animation_finished():
	set_sprite_animation("default")

func _doBlast():
	if is_instance_valid(_blast):
		_blast.visible = true
		_blast.play()

func _on_CanonBlastAnimatedSprite_animation_finished():
	_blast.stop()
	_blast.frame = 0
	_blast.visible = false

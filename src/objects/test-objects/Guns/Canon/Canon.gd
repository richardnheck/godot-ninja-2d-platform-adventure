extends Gun

onready var _sprite = $AnimatedSprite
onready var _blast = $AnimatedSprite/CanonBlastAnimatedSprite
onready var visibility_notifier := $VisibilityNotifier2D
onready var sfx_shoot_sound: AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_blast.visible = false
	
	sfx_shoot_sound = Game_AudioManager.sfx_env_canon_shoot.duplicate()
	add_child(sfx_shoot_sound)
	
	# TODO: Not sure why this doesn't work
	#_sprite.rotate(direction.angle())
	#print_debug(name + " " + str(_sprite.rotation))
	
	# NB: I have no idea why just this code works
	if direction == Vector2(-1,0):
		_sprite.rotation_degrees = 180

func _shoot():
	# Shoot the bullet (this still needs to happen when off screen
	# as it sets the timers and everything
	._shoot()
	
	# Only animate the canon and blast if on screen
	if is_instance_valid(visibility_notifier) and visibility_notifier.is_on_screen():
		sfx_shoot_sound.play()
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


func _on_VisibilityNotifier2D_screen_entered():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	pass

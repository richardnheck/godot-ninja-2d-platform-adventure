extends KinematicBody2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var animatedSprite: = $AnimatedSprite
onready var animationPlayer: = $AnimationPlayer

var gravity: = 20

var triggered:bool = false
var crashed:bool = false
var vel:Vector2 = Vector2.ZERO

var fire_yokai:FireYokai = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if triggered:
		vel.y += gravity
		vel = move_and_slide(vel)
		if vel.y == 0:
			if !crashed:
				crashed = true
				# spike has landed so destroy
				# set_collision_mask_bit(Constants.MASK_PLAYER, false)
				Game_AudioManager.sfx_env_falling_spike.stop()
				Game_AudioManager.sfx_env_crumbling_platform_explode.play()
				animatedSprite.play("explode")
				yield(animatedSprite, "animation_finished")
				queue_free()


func trigger() -> void:
	# Trigger the fire yokai to fly off
	if is_instance_valid(fire_yokai): 
		fire_yokai.trigger()
	
	# Shake the spike
	animationPlayer.play("shake")
	yield(animationPlayer,"animation_finished")
	
	Game_AudioManager.sfx_env_falling_spike.play()
	triggered = true	
	
func _on_TriggerZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Player has entered the trigger zone so make it fall
		trigger()

func _on_HitZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("HIT!!!")
		body.die()

func _on_AddFireYokaiTimer_timeout() -> void:
	_add_fire_yokai()

func _add_fire_yokai() -> void:
	fire_yokai = preload("res://src/objects/fire-yokai/FireYokai.tscn").instance()
	fire_yokai.global_position = Vector2(global_position.x, global_position.y - 12)
	get_parent().add_child(fire_yokai)		
	

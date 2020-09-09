extends KinematicBody2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var animatedSprite: = $AnimatedSprite
onready var animationPlayer: = $AnimationPlayer

var gravity: = 20

var triggered:bool = false
var vel:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if triggered:
		vel.y += gravity
		vel = move_and_slide(vel)
		if vel.y == 0:
			# spike has landed so destroy
			# set_collision_mask_bit(Constants.MASK_PLAYER, false)
			animatedSprite.play("explode")
			yield(animatedSprite, "animation_finished")
			queue_free()
	
	
func _on_TriggerZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Player has entered the trigger zone so make it fall
		print("player triggerd")
		animationPlayer.play("shake")
		yield(animationPlayer,"animation_finished")
		triggered = true	

func _on_HitZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("HIT!!!")
		body.die()

extends KinematicBody2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var explosion: = $AnimatedSpriteExplosion
onready var animationPlayer: = $AnimationPlayer
onready var explodeSound:= $ExplodeSound
onready var crumbleSound:= $CrumbleSound

export var gravity: = 50

var triggered:bool = false
var vel:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	
func _on_TriggerZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Player has entered the trigger zone so make it fall
		crumbleSound.play()
		print("player triggerd")
		animationPlayer.play("shake")
		yield(animationPlayer,"animation_finished")
		triggered = true	
		explodeSound.play()
		explosion.play("explode")
		yield(explosion, "animation_finished")
		queue_free()

func _on_HitZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("HIT!!!")
		body.die()

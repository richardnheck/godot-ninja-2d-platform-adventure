extends KinematicBody2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var animatedSprite: = $AnimatedSprite
onready var animationPlayer: = $AnimationPlayer

var gravity: = 10

var triggered:bool = false
var crashed:bool = false
var vel:Vector2 = Vector2.ZERO

onready var fire_yokai:FireYokai = $FireYokai

var sfx_falling_spike:AudioStreamPlayer2D = null
var sfx_candle_explosion: AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_falling_spike = Game_AudioManager.sfx_env_falling_spike.duplicate()
	add_child(sfx_falling_spike)
	sfx_candle_explosion = Game_AudioManager.sfx_env_candle_explosion.duplicate()
	add_child(sfx_candle_explosion)
	

func _physics_process(delta: float) -> void:
	if triggered:
		vel.y += gravity
		vel = move_and_slide(vel)
		if vel.y == 0:
			if !crashed:
				crashed = true
				# spike has landed so destroy
				sfx_falling_spike.stop()
				sfx_candle_explosion.play()
				_trigger_fire_yokai()
				animatedSprite.play("explode")
				yield(animatedSprite, "animation_finished")
				queue_free()

func _trigger_fire_yokai():
	# Trigger the fire yokai to fly off
	# But first reparent it so it doesn't move with this spike
	if is_instance_valid(fire_yokai): 
		self.remove_child(fire_yokai)
		self.get_tree().current_scene.call_deferred("add_child",fire_yokai)
		fire_yokai.global_position = Vector2(global_position.x, global_position.y - 11)
		fire_yokai.call_deferred("trigger")

func trigger() -> void:
	sfx_falling_spike.play()
	triggered = true	

func _on_HitZone_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _on_AddFireYokaiTimer_timeout() -> void:
	pass #_add_fire_yokai()
	

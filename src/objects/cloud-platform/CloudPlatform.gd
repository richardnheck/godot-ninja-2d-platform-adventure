extends KinematicBody2D

onready var spike_collision_shape: CollisionShape2D = $CollisionShape2D
onready var explosion: = $AnimatedSpriteExplosion
onready var animationPlayer: = $AnimationPlayer
onready var explodeSound:= Game_AudioManager.sfx_env_crumbling_platform_explode
onready var crumbleSound:= Game_AudioManager.sfx_env_crumbling_platform_crumble

onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var respawn_timer: Timer = $RespawnTimer
onready var respawn_backoff_timer: Timer = $RespawnBackOffTimer
onready var cloud_area: Area2D = $CloudArea2D

export var gravity: = 50

var is_respawning = false
var player_in_cloud_area = false

var triggered:bool = false
var vel:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	
func _on_TriggerZone_body_entered(body: Node) -> void:
	# The cloud is not respawning so trigger its disappearance as usual
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Player has entered the trigger zone so make it fall
		crumbleSound.play()
		print("player triggerd")
		animationPlayer.play("shake")
		yield(get_tree().create_timer(0.7), "timeout")
		crumbleSound.stop()
		triggered = true	
		explodeSound.play()
		explosion.play("explode")
		yield(explosion, "animation_finished")
		_show_cloud(false)
		explosion.play("idle")
		respawn_timer.start()
		
		
func _show_cloud(show: bool) -> void:
	self.visible = show
	collision_shape.set_deferred("disabled", !show)
	if show:
		yield(get_tree().create_timer(0.3), "timeout")
		animationPlayer.stop()

func _on_RespawnTimer_timeout() -> void:
	_respawn_when_clear_of_player()	
	

func _on_RespawnBackOffTimer_timeout() -> void:
	_respawn_when_clear_of_player()

func _respawn_when_clear_of_player() -> void:
	if not player_in_cloud_area:
		# Reshow the cloud only if the player isn't in its area
		_show_cloud(true)
	else:
		# Player in cloud area so back off a little bit and try again
		respawn_backoff_timer.start()

func _on_CloudArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		print("player in cloud area")
		player_in_cloud_area = true

func _on_CloudArea2D_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		player_in_cloud_area = false
		print("player NOT in cloud area")

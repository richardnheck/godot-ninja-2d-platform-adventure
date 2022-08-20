extends RigidBody2D

onready var animation_player:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	mode = RigidBody2D.MODE_STATIC	# So the platform doesn't fall initially

func _on_TriggerArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# player has touched the platform so start falling after a short period
		animation_player.play("shake")
		yield(get_tree().create_timer(0.1), "timeout")
		set_deferred("mode", RigidBody2D.MODE_RIGID)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

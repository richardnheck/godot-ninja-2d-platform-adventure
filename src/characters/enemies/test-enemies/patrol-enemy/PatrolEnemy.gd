# Basic enemi that make a simple left to right patrol
extends Enemy2

onready var Physics2D: Physics2D = $Physics2D
var jump_count := 0


func _ready() -> void:
	# signals
	$AnimationPlayer.connect("animation_finished", self, "_on_Animation_finished")
	$HitBox.connect("body_entered", self, "_on_HitBox_body_entered")
	
	# state change
	._initialize_state("Patrol")


func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("die"):
			body.die()


func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)



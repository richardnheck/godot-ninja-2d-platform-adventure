extends Area2D

var triggered:bool = false

func _on_body_entered(body: Node) -> void:
	if not triggered:
		print("Transition Area2D: entered")
		if body.is_in_group(Constants.GROUP_PLAYER):
			# Get the boss and goto the next phase
			var boss = get_parent().get_node("Wanyudo")
			if boss and boss.has_method("goto_next_phase"):
				boss.goto_next_phase()
				triggered = true

extends Area2D


func _on_body_entered(body: Node) -> void:
	print("Transition Area2D: entered")
	if body.is_in_group(Constants.GROUP_BOSS):
		if body.has_method("goto_next_phase"):
			body.goto_next_phase()

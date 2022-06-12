extends Node2D

# Remove all projectiles
func remove_all() -> void:
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

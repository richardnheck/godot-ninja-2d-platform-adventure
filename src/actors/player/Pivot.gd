extends Position2D

onready var parent = $'..'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#update_pivot_angle()


func _physics_process(delta: float) -> void:
	pass
	#update_pivot_angle()


func update_pivot_angle():
	rotation = parent.look_direction.angle()
	



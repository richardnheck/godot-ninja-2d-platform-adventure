extends Motion

export (float) var PATROL_SPEED := 80.0
export (float) var PATROL_ACCELERATION := 0.25

var direction: int = 1


func enter(host: Enemy2) -> void:
	host.get_node("AnimationPlayer").play("Patrol")
	host.speed = PATROL_SPEED
	host.acceleration = PATROL_ACCELERATION


#warning-ignore:unused_argument
func update(host: Enemy2, delta: float) -> void:
	if not $RayCastFloor.is_colliding() or $RayCastWall.is_colliding():
		direction *= -1
	var direction_vector := Vector2(direction, 0)
	update_look_direction(host, direction_vector)
	move(host, direction_vector, PATROL_SPEED, PATROL_ACCELERATION)

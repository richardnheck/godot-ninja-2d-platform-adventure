extends RigidBody2D

onready var cooloff_timer:= $CoolOffTimer
onready var initial_delay_timer: = $InitialDelayTimer

var falling:bool = true
var in_ground_hit_cooloff = false
var rise_velocity = 50;
var max_gravity_scale = 6;
var player = null

export var initial_delay:float = 0.0

func _ready() -> void:
	fall(false)
	if initial_delay > 0:
		initial_delay_timer.start()
	else:
		fall(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:		
	linear_velocity.x = 0
	if !in_ground_hit_cooloff and abs(linear_velocity.y) < 5:
		if player:
			player.die()
		
#	if !falling:
#		#linear_velocity = Vector2(0, -rise_velocity)
#		gravity_scale = max_gravity_scale
#	else:
#		gravity_scale = -max_gravity_scale
#		#applied_force = Vector2.ZERO
	

func _on_CrushingRock_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
			player = body
			if body.position.y > position.y:
				body.die()
			return
	
	if !in_ground_hit_cooloff:
		print("ground hit")
		falling = !falling
		gravity_scale = -gravity_scale
		in_ground_hit_cooloff = true
		cooloff_timer.start();


func _on_InitialDelayTimer_timeout() -> void:
	fall(true)
	

func _on_CoolOffTimer_timeout() -> void:
	in_ground_hit_cooloff = false

func fall(value:bool) -> void:
	gravity_scale = max_gravity_scale if value else 0

extends Area2D

onready var tween = $Tween
onready var spikeCollisionShape = $CollisionShape2D
onready var sprite = $CollisionShape2D/Sprite
onready var initialDelayTimer = $InitialDelayTimer
onready var sound = $AudioStreamPlayer2D
onready var tween_values = [Vector2(0,8), Vector2(0,-6)]

# Delay between trigger and spike appearing
const TRIGGER_DELAY:float = 0.7

# The time that a spike is up once triggered
const SPIKE_UPTIME:float = 1.5		

func _ready():
	_show_spike(false)

# Trigger the trap
func _trigger_trap() -> void:
	yield(get_tree().create_timer(TRIGGER_DELAY), "timeout")
	sound.play()
	_show_spike(true)
	yield(get_tree().create_timer(SPIKE_UPTIME), "timeout")
	sound.play()
	_show_spike(false)
	
func _show_spike(show:bool) -> void:
	spikeCollisionShape.set_deferred("disabled", not show)
	spikeCollisionShape.visible = show;

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _on_TriggerPadArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		_trigger_trap()

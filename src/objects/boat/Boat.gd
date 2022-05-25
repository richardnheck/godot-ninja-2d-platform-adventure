extends Node2D

# Boat speed (playback speed of animation player)
export(float, 0.01, 1, 0.01) var boat_speed:float = 0.0 setget _set_boat_speed

onready var animation_player = $AnimationPlayer


func _set_boat_speed(value) -> void:
	boat_speed = value
	
		
func _ready() -> void:
	animation_player.playback_speed = boat_speed
	

# Handle when the player lands in the boat
func _on_StartArea2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Start moving the boat
		animation_player.play("PingPongPathFollow")

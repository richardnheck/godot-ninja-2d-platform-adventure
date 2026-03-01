extends RigidBody2D
class_name Tofu

var sfx_land:AudioStreamPlayer2D = null
var _landed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sfx_land = Game_AudioManager.sfx_env_tofu_land.duplicate()
	add_child(sfx_land)


func _on_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# Tofu has hit player so kill player
		body.die()
	elif body is TileMap:
		# Tofu has hit ground so remove
		sfx_land.play()
		_landed = true
		

extends Node2D

signal player_entered

onready var audioPlayer = $AudioStreamPlayer2D
onready var sprite = $Sprite

var door_open_image = preload("res://assets/art/props/door/door-open.png")
var door_closed_image = preload("res://assets/art/props/door/door.png")

export var is_open = false


func open() -> void:
	is_open = true
	sprite.set_texture(door_open_image) 

func close() -> void:
	is_open = false
	sprite.set_texture(door_closed_image) 

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has come in contact with the door
		if is_open:
			emit_signal("player_entered")
			audioPlayer.play()
			set_physics_process(false)


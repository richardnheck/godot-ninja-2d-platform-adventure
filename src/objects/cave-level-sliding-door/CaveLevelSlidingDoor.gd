extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

export var is_locked = true

var opened = false

func _ready() -> void:
	pass

func open() -> void:
	is_locked = false
	

func close() -> void:
	is_locked = true


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has come in contact with the door
		if !is_locked and !opened:
			opened = true
			# Play door open animation
			animation_player.play("open")
			

extends Node2D

export var messageIndex:int = -1

onready var label:Label = $Label

var helpMessages = [
	"Press ^ to jump",
	"Press ^ twice to double jump",
	"Need a key to open door"
];

func _ready() -> void:
	label.set_deferred("visible", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		if messageIndex >= 0 and messageIndex < helpMessages.size():
			label.text = helpMessages[messageIndex]
			label.visible = true
		

func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		label.visible = false

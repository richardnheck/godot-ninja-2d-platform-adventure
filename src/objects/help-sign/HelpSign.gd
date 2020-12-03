extends Node2D

export var messageIndex:int = -1

onready var label:RichTextLabel = $Label
onready var panelsNode = $Panels

var helpMessages = [
	"Press ^ to jump",
	"Press ^ twice\nto double jump",
	"Need a key to open door",
	"Hold ^ against a wall\n and press arrow away\n from wall to walljump",
	"Walljump off one wall only"
];

func _ready() -> void:
	var panels = panelsNode.get_children()
	print(panels)
	for panel in panels:
		panel.set_deferred("visible", false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _show_help_panel(show):
	if messageIndex >= 0 and messageIndex < helpMessages.size():
		var panel = panelsNode.get_child(messageIndex)	
		panel.visible = show
	

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		_show_help_panel(true)
		

func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		_show_help_panel(false)

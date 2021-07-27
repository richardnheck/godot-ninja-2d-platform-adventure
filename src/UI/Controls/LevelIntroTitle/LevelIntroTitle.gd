extends CanvasLayer

signal finished

var _text: String = "text"
onready var label:Label = $ColorRect/Label

# Any initialization of a variable most be done before setget.
var text setget text_set, text_get

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func text_set(value):
	_text = value
	label.text = _text	

func text_get():
	 return _text


func _on_Timer_timeout() -> void:
	emit_signal("finished")

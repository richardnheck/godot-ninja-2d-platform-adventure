extends CanvasLayer

signal finished

var _text: String = ""
var _finished:bool = false

onready var rect:ColorRect = $ColorRect
onready var label:Label = $ColorRect/HBoxContainer/Label
onready var tween:Tween = $Tween

var colors = [Color(1, 1, 1, 0), Color(1, 1, 1, 1)]

# Any initialization of a variable most be done before setget.
var text setget text_set, text_get

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.modulate.a = 0
	_tween_opacity()

func text_set(value):
	_text = value
	label.text = _text	

func text_get():
	 return _text

func _tween_opacity() -> void:
	tween.interpolate_property(rect, "modulate", colors[0], colors[1] , 1,Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
func _on_Timer_timeout() -> void:
	_finished = true
	colors.invert()
	_tween_opacity()
	
func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if _finished:
		emit_signal("finished")

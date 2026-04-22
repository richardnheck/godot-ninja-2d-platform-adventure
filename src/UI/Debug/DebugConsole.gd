extends Control

signal on_close

onready var console := $Console
onready var input_container := $Console/InputContainer

func _ready():
	print("DebugConsole ready")
	GameState.connect("on_log", self, "_on_log_print")
	
	# Since GameState runs before this we need to get the console message history	
	console.log_raw(GameState.get_console_history())

func _on_CloseButton_pressed():
	emit_signal("on_close")

func _on_log_print(message):
	console.log_raw(message)

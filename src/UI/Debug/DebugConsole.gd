extends Control

signal on_close

onready var console := $Console
onready var input_container := $Console/InputContainer

func _ready():
	print("DebugConsole ready")
	
func _on_CloseButton_pressed():
	emit_signal("on_close")

func _on_DebugConsole_visibility_changed():
	if is_visible_in_tree():
		print("her")
		console.clear_console()
		console.log_raw("Is mobile: %s" % [ Settings.is_mobile()])
		console.log_raw("Has touchscreen: %s" % [ Settings.has_touchscreen()])
		console.log_raw("Is html5 build: %s" % [ Settings.is_html5_build()])
		
		# Get the log history and print it
		console.log_raw(DebugLog.get_console_log_history())	

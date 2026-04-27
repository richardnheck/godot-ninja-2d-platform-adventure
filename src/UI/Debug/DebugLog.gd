extends Node

# This is a history of the console messages made so it can be obtained from
# the debug console component.  GameState is an Autoload that runs before
# the debug console is created, so it cannot rely on signals at the start
var _console_log_history = ""

func log(message:String) -> void:
	_console_log_history += message + "\n"

func get_console_log_history() -> String:
	return _console_log_history

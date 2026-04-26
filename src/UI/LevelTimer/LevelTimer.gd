class_name LevelTimer
extends Control

onready var timer_label:Label = $"%TimerLabel"
onready var time_status_label:Label = $"%TimeStatusLabel"

var Red = Color("#901b00")		
var Green = Color("#00d100")

func _ready():
	visible = _enabled()
	
	# time status is always hidden by default until explicit status is set
	time_status_label.visible = false

# Set the time status message
func set_status(message:String) -> void:
	var better_time:bool = message.substr(0, 1) == "-"	 # a better time is has a negative sign at the start, a worse time has a + sign	
	time_status_label.text = message
	time_status_label.visible = true
	
	# set the colour of the text. Green for better time, Red for worse time
	var color:Color = Red 	# Red by default
	if better_time:
		color = Green
	
	time_status_label.add_color_override("font_color", color)
	

func _enabled() -> bool:
	return Settings.get_show_level_timer_enabled()

func _process(_delta: float) -> void:
	if _enabled():
		timer_label.text = Stopwatch.get_elapsed_time_as_formatted_string(Stopwatch.TimeFormat)

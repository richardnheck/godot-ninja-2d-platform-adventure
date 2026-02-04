#####################
# Tutorial Panels
#####################
extends Node

onready var mobile_tutorial_panel = $ControlsMobile
onready var keyboard_tutorial_panel = $ControlsKeyboard 


func _ready():
	mobile_tutorial_panel.visible = Settings.get_touch_screen_controls_visible()
	keyboard_tutorial_panel.visible = !mobile_tutorial_panel.visible 

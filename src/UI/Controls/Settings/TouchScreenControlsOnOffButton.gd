extends Button

onready var icon_atlas = preload("settings-button-icons.png")
var on_icon_texture:AtlasTexture
var off_icon_texture:AtlasTexture

var on = true

func _ready() -> void:
	# Get the current value from the settings
	on = Settings.touch_screen_controls_visible
	
	on_icon_texture = AtlasTexture.new()
	on_icon_texture.atlas = icon_atlas
	on_icon_texture.region = Rect2(0,30,14,14)
	
	off_icon_texture = AtlasTexture.new()
	off_icon_texture.atlas = icon_atlas
	off_icon_texture.region = Rect2(14,30,14,14) 
	
	_update_icon()

	
func _on_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	on = not on
	
	# Change the settings
	Settings.touch_screen_controls_visible = on
	
	_update_icon()

func _update_icon():
	if on:
		self.icon = on_icon_texture
	else:
		self.icon = off_icon_texture




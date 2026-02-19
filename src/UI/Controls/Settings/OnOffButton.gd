extends Button

signal button_pressed(on)


onready var icon_atlas = preload("settings-button-icons.png")
var on_icon_texture:AtlasTexture
var off_icon_texture:AtlasTexture

var _on = false

func set_on(value) -> void:
	_on = value
	_update_icon()
	

func _ready() -> void:	
	on_icon_texture = AtlasTexture.new()
	on_icon_texture.atlas = icon_atlas
	on_icon_texture.region = Rect2(0,30,14,14)
	
	off_icon_texture = AtlasTexture.new()
	off_icon_texture.atlas = icon_atlas
	off_icon_texture.region = Rect2(14,30,14,14) 
	
	_update_icon()

	
func _on_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	_on = not _on
	
	emit_signal("button_pressed", _on)
	
	_update_icon()

func _update_icon():
	if _on:
		self.icon = on_icon_texture
	else:
		self.icon = off_icon_texture




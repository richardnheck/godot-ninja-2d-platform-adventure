extends Button

onready var icon_atlas = preload("settings-button-icons.png")
var muted_icon_texture:AtlasTexture
var normal_icon_texture:AtlasTexture


func _ready() -> void:
	normal_icon_texture = AtlasTexture.new()
	normal_icon_texture.atlas = icon_atlas
	normal_icon_texture.region = Rect2(0,15,14,14)
	
	muted_icon_texture = AtlasTexture.new()
	muted_icon_texture.atlas = icon_atlas
	muted_icon_texture.region = Rect2(14,15,14,14) 
	
	_update_icon()


func _on_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	Game_AudioManager.toggle_music()
	_update_icon()

func _update_icon():
	if not Game_AudioManager.is_music_muted():
		self.icon = normal_icon_texture
	else:
		self.icon = muted_icon_texture

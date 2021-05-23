extends TextureButton

export var NORMAL_TEXTURE ="res://assets/art/ui/sound-button1.png"
export var NORMAL_PRESSED_TEXTURE ="res://assets/art/ui/sound-button2.png"
export var MUTED_TEXTURE ="res://assets/art/ui/sound-button3.png"
export var MUTED_PRESSED_TEXTURE ="res://assets/art/ui/sound-button4.png"

func _ready() -> void:
	if not Game_AudioManager.is_sound_fx_muted():
		self.texture_normal = load(NORMAL_TEXTURE)
	else:
		self.texture_normal = load(MUTED_TEXTURE)


func _on_button_up() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	Game_AudioManager.toggle_sound_fx()
	if not Game_AudioManager.is_sound_fx_muted():
		self.texture_normal = load(NORMAL_TEXTURE)
	else:
		self.texture_normal = load(MUTED_TEXTURE)
	
func _on_button_down() -> void:
	if not Game_AudioManager.is_sound_fx_muted():
		self.texture_pressed = load(NORMAL_PRESSED_TEXTURE)
	else:
		self.texture_pressed = load(MUTED_PRESSED_TEXTURE)

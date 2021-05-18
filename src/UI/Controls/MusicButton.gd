extends TextureButton

const NORMAL_TEXTURE ="res://assets/art/ui/music-button1.png"
const NORMAL_PRESSED_TEXTURE ="res://assets/art/ui/music-button2.png"
const MUTED_TEXTURE ="res://assets/art/ui/music-button3.png"
const MUTED_PRESSED_TEXTURE ="res://assets/art/ui/music-button4.png"

func _ready() -> void:
	if not Game_AudioManager.is_music_muted():
		self.texture_normal = load(NORMAL_TEXTURE)
	else:
		self.texture_normal = load(MUTED_TEXTURE)


func _on_button_up() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	Game_AudioManager.toggle_music()
	if not Game_AudioManager.is_music_muted():
		self.texture_normal = load(NORMAL_TEXTURE)
	else:
		self.texture_normal = load(MUTED_TEXTURE)
	
func _on_button_down() -> void:
	if not Game_AudioManager.is_music_muted():
		self.texture_pressed = load(NORMAL_PRESSED_TEXTURE)
	else:
		self.texture_pressed = load(MUTED_PRESSED_TEXTURE)

extends TextureButton


func _ready() -> void:
	pass # Replace with function body.


func _on_button_up() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	Game_AudioManager.toggle_sound_fx()
	
	

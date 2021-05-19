tool
extends TextureButton
class_name BackButton

export(String, FILE) var next_scene_path:String = ""
export(String) var sound:String = ""

func _on_button_up() -> void:

	get_tree().paused = false
	
	if self.sound != "":
		var player = Game_AudioManager.get_node(self.sound)
		player.play()	
	else:
		Game_AudioManager.sfx_ui_basic_blip_select.play()
			
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next_scene_path must be set" if next_scene_path == "" else ""

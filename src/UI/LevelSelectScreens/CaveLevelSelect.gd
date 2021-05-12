extends CanvasLayer


onready var buttonContainer = $Control/LevelButtonsContainer

export(String, FILE) var intro_scene_path:String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_AudioManager.play_bgm_main_theme_skip_start()
	
	var levelsCount = LevelData.get_levels().size()
	levelsCount = levelsCount - 1;	 # Don't use boss scene
	for levelIndex in range(0, levelsCount):
		var button = Button.new()
		button.text = str(levelIndex + 1)
		button.connect("button_up", self, "_level_button_pressed", [levelIndex])
		#button.set_size(Vector2(40,18));  #doesn't work
		buttonContainer.add_child(button)
		
	
func _level_button_pressed(levelIndex):
	Game_AudioManager.sfx_ui_general_select.play()
	LevelData.goto_level(levelIndex)


func _on_BossButton_button_up() -> void:
	LevelData.goto_boss_level()


func _on_IntroButton_button_up() -> void:
	Game_AudioManager.sfx_ui_general_select.play()
	get_tree().change_scene(intro_scene_path)

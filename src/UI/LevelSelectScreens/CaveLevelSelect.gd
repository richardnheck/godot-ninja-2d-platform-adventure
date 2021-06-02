extends CanvasLayer


onready var buttonContainer = $Control/LevelButtonsContainer
onready var boss_button = $Control/BossButton

export(String, FILE) var intro_scene_path:String = ""

# This is the level select for world 1 (cave levels)
const this_world = LevelData.WORLD1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_AudioManager.play_bgm_main_theme_skip_start()
	
	# Get the current progress of the game
	var current_world = GameState.progress["current_world"]
	var current_level = GameState.progress["current_level"]

	# Create all the level buttons
	var worldLevels = LevelData.get_levels_by_world(LevelData.WORLD1)
	var levelsCount = worldLevels.size()

	for levelIndex in range(0, levelsCount - 1):   # Don't include boss scene
		var button = Button.new()
		button.disabled = true
		if current_world >= this_world and levelIndex <= current_level:
			button.disabled = false
		button.text = str(levelIndex + 1)
		button.connect("pressed", self, "_level_button_pressed", [levelIndex])
		#button.set_size(Vector2(40,18));  #doesn't work
		buttonContainer.add_child(button)
		
	# Determine if the boss button is enabled
	if current_world > this_world:
		# current world is greater than this one so boss is beaten
		boss_button.disabled = false
	else:
		boss_button.disabled = current_level < levelsCount - 1
	
func _level_button_pressed(levelIndex):
	Game_AudioManager.sfx_ui_general_select.play()
	LevelData.goto_level(levelIndex)


func _on_BossButton_button_up() -> void:
	LevelData.goto_boss_level()


func _on_IntroButton_button_up() -> void:
	Game_AudioManager.sfx_ui_general_select.play()
	get_tree().change_scene(intro_scene_path)

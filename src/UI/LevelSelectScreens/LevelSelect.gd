class_name LevelSelect
extends Control


onready var buttonContainer = $Control/LevelButtonsContainer
onready var boss_button = $"%BossButton"
onready var loading_indicator = $Control/LoadingIndicator
onready var fadeScreen = $FadeScreen
onready var boss_clear_cutscene_button = $"%BossClearCutsceneButton"

export(String, FILE) var intro_scene_path:String = ""

# This is the specific world
export(int, 1,3, 1) var this_world:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Preload the world select to prevent HTML5 audio stutter when transitioning
	preload("res://src/UI/WorldSelectScreen/WorldSelect.tscn")
	
	loading_indicator.visible = false
	
	Game_AudioManager.play_bgm_main_theme_skip_start()
	
	# Get the current player progress of the game
	var current_level = GameState.progress["current_level"]
	var current_world = LevelData.get_world(current_level)
	print(">>>current_world", current_world)
	# Create all the level buttons
	var levels = LevelData.get_levels()
	var levelsCount = levels.size()

	var levelNumber = 0;
	for levelIndex in range(0, levelsCount):   # NB: range second param is the upper limit of the sequence (exclusive).
		#print_debug(str(levelIndex) + ": " + str(levels[levelIndex].world))
		# Don't include boss scene
		var isBossLevel = levels[levelIndex].has("is_boss") and levels[levelIndex].is_boss
		
		if levels[levelIndex].world == self.this_world and not isBossLevel:
			
			var button:Button = Button.new()
			
			button.disabled = true
			
			if current_world >= this_world and levelIndex <= current_level:
				button.disabled = false
			button.text = str(levelNumber + 1)
		
			button.connect("pressed", self, "_level_button_pressed", [levelIndex])
			buttonContainer.add_child(button)
			button.set_custom_minimum_size(Vector2(22,22))	
			levelNumber = levelNumber + 1
		
	# Determine if the boss button is enabled
	var boss_level_index = LevelData.get_boss_level_index(this_world)
	boss_button.disabled = current_level < boss_level_index
		
	# Determine if the boss clear cutscene button is visible
	boss_clear_cutscene_button.visible = current_level > boss_level_index
	
func _level_button_pressed(levelIndex):
	Game_AudioManager.sfx_ui_confirm.play()
	
	if Settings.is_html5_build():
		# Prevent HTML5 Audio stutter by stopping background music before transitioning
		# to the level
		Game_AudioManager.stop_bgm()
		loading_indicator.visible = true  				# Show loading message on this screen so it doesn't appear that game freezes when background music stops
		yield(get_tree().create_timer(1), "timeout")	# Need to wait otherwise it still has a quiet clicking stutter	
		_fade_goto_scene(levelIndex, true)				# Show additional loading message on the fadescreen because on slow devices it looks like nothing is happening	
	else:
		_fade_goto_scene(levelIndex, false)	

func _fade_goto_scene(levelIndex, show_loading_message) -> void:
	var scene_path = LevelData.goto_level(levelIndex, false)
	fadeScreen.go_to_scene(scene_path, show_loading_message)


func _on_BossButton_button_up() -> void:
	print("Goto boss for world", self.this_world)
	Game_AudioManager.sfx_ui_confirm.play()
	var scene_path = LevelData.goto_boss_level(self.this_world, false)
	fadeScreen.go_to_scene(scene_path)


func _on_IntroButton_button_up() -> void:
	Game_AudioManager.sfx_ui_general_select.play()
	fadeScreen.go_to_scene(intro_scene_path)


func _on_BossClearCutsceneButton_button_up():
	var scene_path = LevelData.goto_boss_clear_cutscene(self.this_world, false)
	fadeScreen.go_to_scene(scene_path)

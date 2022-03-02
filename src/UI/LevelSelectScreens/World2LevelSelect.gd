extends CanvasLayer


onready var buttonContainer = $Control/LevelButtonsContainer
onready var boss_button = $Control/BossButton
onready var loading_indicator = $Control/LoadingIndicator
onready var fadeScreen = $FadeScreen

export(String, FILE) var intro_scene_path:String = ""

# This is the level select for world 1 (cave levels)
const this_world = LevelData.WORLD2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Preload the world select to prevent HTML5 audio stutter when transitioning
	preload("res://src/UI/WorldSelectScreen/WorldSelect.tscn")
	
	loading_indicator.visible = false
	
	Game_AudioManager.play_bgm_main_theme_skip_start()
	
	# Get the current progress of the game
	var current_world = GameState.progress["current_world"]
	var current_level = GameState.progress["current_level"]

	# Create all the level buttons
	var worldLevels = LevelData.get_levels_by_world(LevelData.WORLD2)
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
	var scene_path = LevelData.goto_boss_level(false)
	fadeScreen.go_to_scene(scene_path)


func _on_IntroButton_button_up() -> void:
	Game_AudioManager.sfx_ui_general_select.play()
	get_tree().change_scene(intro_scene_path)

extends CanvasLayer

onready var main_play_button := $Control/VBoxContainer/MainPlayButton
onready var quit_button := $Control/VBoxContainer/QuitButton
onready var title = $"%TitleScreenText"
onready var title_tween = $TitleTween
onready var tween_values = [null, null]
onready var settings = $"%Settings"
onready var leaderboard_screen = $"%GameLeaderboardScreen"
onready var progress_screen = $"%ProgressScreen"
onready var user_screen = $"%UserScreen"
onready var overlay = $"%OverlayColorRect"
onready var debug_console = $"%DebugConsole"
onready var debug_button = $"%DebugButton"
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	overlay.visible = false
	settings.visible = false
	leaderboard_screen.visible = false
	user_screen.visible = false
	progress_screen.visible = false
	quit_button.visible = not Settings.is_html5_build()
	debug_console.visible = false
	debug_button.visible = true   #TODO set to false
	
	# The main screen could be reloaded by navigating back from
	# some functionality from the Extras tab in the Settings.
	# Restore the Settings back in this case
	settings.visible = MainScreenState.settings_open
	settings.set_current_tab(MainScreenState.settings_current_tab_index)
	
	
	
	if GameState.get_has_watched_story_intro():
		# If user has watched the story intro then show the world select screen
		main_play_button.next_scene_path = "res://src/UI/WorldSelectScreen/WorldSelect.tscn";
	else:
		# User hasn't watched the story intro so show it
		main_play_button.next_scene_path = "res://src/UI/CutScenes/StoryIntroScreen/StoryIntro.tscn";		
			
	
	Game_AudioManager.play_bgm_main_theme_skip_start()

	_start_tween()
	
	

func _start_tween():
	if tween_values[0] == null:
		tween_values = [title.position, Vector2(title.position.x, title.position.y - 8)]
	title_tween.interpolate_property(title, "position", tween_values[0], tween_values[1], 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	title_tween.start()


func _on_SettingsButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	settings.visible = true
	overlay.visible = true
	MainScreenState.settings_open = true 


func _on_Settings_on_closed():
	settings.visible = false
	overlay.visible = false
	MainScreenState.settings_open = false
	print("cheat mode set", Settings.cheat_mode)
	debug_button.visible = Settings.cheat_mode


func _on_Settings_on_tab_changed(tab_index:int):
	MainScreenState.settings_current_tab_index = tab_index 


func _on_TitleTween_tween_completed(object: Object, key: NodePath) -> void:
	tween_values.invert()
	_start_tween()


func _on_QuitButton_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_LeaderboardButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	leaderboard_screen.visible = true
	
func _on_LeaderboardScreen_on_closed():
	leaderboard_screen.visible = false

func _on_ProgressButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	var level = LevelData.get_current_level()
	var current_world = level.world
	progress_screen.world = current_world
	progress_screen.visible = true

func _on_ProgressScreen_on_closed():
	progress_screen.visible = false

func _on_UserButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	user_screen.visible = true
	overlay.visible = true

func _on_UserScreen_on_closed():
	user_screen.visible = false
	overlay.visible = false

func _on_DebugButton_pressed():
	debug_console.visible = true


func _on_DebugConsole_on_close():
	debug_console.visible = false


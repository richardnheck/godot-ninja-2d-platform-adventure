extends CanvasLayer

onready var title = $TitleScreenText
onready var title_tween = $TitleTween
onready var tween_values = [null, null]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Settings.visible = false
	Game_AudioManager.play_bgm_main_theme_skip_start()

	_start_tween()

func _start_tween():
	if tween_values[0] == null:
		tween_values = [title.global_position, Vector2(title.global_position.x, title.global_position.y - 8)]
	title_tween.interpolate_property(title, "position", tween_values[0], tween_values[1], 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	title_tween.start()


func _on_SettingsButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	$Settings.visible = true 


func _on_TitleTween_tween_completed(object: Object, key: NodePath) -> void:
	tween_values.invert()
	_start_tween()


func _on_QuitButton_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

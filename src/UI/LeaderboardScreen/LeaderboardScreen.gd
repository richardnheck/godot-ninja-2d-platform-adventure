#------------------------------
# LeaderboardScreen
#------------------------------
extends Control

signal on_closed

onready var item_list = $ItemList

onready var cut_scene_base:CutSceneBase = $"%CutSceneBase"

onready var list_container = $"%VBoxContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#Load the ItemList by stepping through it and adding each item.
	pass
	
func _load_entries() -> void:
	var normal_theme = load("res://assets/themes/settings/settings_normal_theme.tres")
	
	var entries_page = yield(Analytics.get_level_leaderboard_entries(), "completed")
	for entry in entries_page.entries:
		var display_name = entry.player_display_name
		var label = "%s  %s   %s" % [entry.position + 1, display_name, Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat)]
		item_list.add_item(label,null,true)
		
		var labelItem:Label = Label.new()
		labelItem.text = label
		labelItem.theme = normal_theme
		list_container.add_child(labelItem)
	
	
func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

		
func _on_LoadButton_pressed():
	_load_entries()

#------------------------------
# LeaderboardScreen
#------------------------------
extends Control

signal on_closed

onready var item_list = $ItemList

onready var cut_scene_base:CutSceneBase = $"%CutSceneBase"

var ItemListContent = ["We shall go this way","We shall go that way","which way shall we go?","I think we're lost"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#Load the ItemList by stepping through it and adding each item.
	pass
	
func _load_entries() -> void:
	var entries_page = yield(Analytics.get_level_leaderboard_entries(), "completed")
	for entry in entries_page.entries:
		var label = "%s  %s   %s" % [entry.position + 1, entry.player_alias, Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat)]
		item_list.add_item(label,null,true)
	
	
func _on_CloseButton_pressed() -> void:
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

		
func _on_LoadButton_pressed():
	_load_entries()

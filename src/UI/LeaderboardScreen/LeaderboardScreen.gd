#------------------------------
# LeaderboardScreen
#------------------------------
extends Control

signal on_closed

onready var item_list = $ItemList

onready var cut_scene_base:CutSceneBase = $"%CutSceneBase"

onready var list_container = $"%VBoxContainer"
onready var tree = $"%Tree"
var tree_root = null
var game_entries_page = null
var level_entries_page = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_init_tree()
	_load_game_entries()
	
func _init_tree() -> void:
	#tree.set_anchors_and_margins_preset(Control.PRESET_WIDE) # Occupy scene
	tree.set_column_title(0, "Rank")
	tree.set_column_min_width(0, 30)
	tree.set_column_expand(0, false)
	
	tree.set_column_title(1, "Name")
	tree.set_column_min_width(1, 150)
	tree.set_column_expand(1, false)
	
	tree.set_column_title(2, "Time")
	tree.set_column_title(3, "Deaths")
	
	tree_root = tree.create_item()


func _load_game_entries() -> void:
	game_entries_page = yield(Analytics.get_game_leaderboard_entries(), "completed")	
	_populate_tree(game_entries_page)
		
func _load_level_entries() -> void:
	level_entries_page = yield(Analytics.get_level_leaderboard_entries(), "completed")	
	_populate_tree(level_entries_page)
	
func _populate_tree(entries_page) -> void:
	_clear_tree()
	if entries_page:
		for entry in entries_page.entries:
			add_entry_to_tree(entry)

func _clear_tree() -> void:
	tree.clear()
	tree_root = tree.create_item()
	
		
func add_entry_to_tree(entry) -> void:
	var display_name = entry.player_display_name
	var item = tree.create_item(tree_root)
	item.set_text(0, str(entry.position + 1))
	item.set_text(1, display_name)
	item.set_text(2, Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat))
	item.set_text(3, str(entry.get_prop("deaths").value))
			
func _on_LoadButton_pressed():
	_load_game_entries()


func _on_CloseTextureButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")


func _on_LevelButton_pressed():
	_load_level_entries()


func _on_GameButton_pressed():
	_load_game_entries()

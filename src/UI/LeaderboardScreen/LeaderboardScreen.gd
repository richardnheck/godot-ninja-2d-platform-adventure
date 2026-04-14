#------------------------------
# LeaderboardScreen
#------------------------------
extends Control

signal on_closed

onready var item_list = $ItemList

onready var cut_scene_base:CutSceneBase = $"%CutSceneBase"

onready var list_container = $"%VBoxContainer"
onready var tree = $"%Tree"
onready var loading_label = $"%Loading"
onready var level_option_button = $"%LevelOptionButton"

var loading = false
var tree_root = null
var game_entries_page = null
var level_entries_page = null

var show_game_scores = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_init_tree()
	_load_game_entries()
	_populate_level_option_button()
	
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
	level_option_button.visible = false
	_clear_tree()
	_show_loading(true)
	game_entries_page = yield(Analytics.get_game_leaderboard_entries(), "completed")	
	show_game_scores = true	
	_show_loading(false)
	_populate_tree(game_entries_page)
		
func _load_level_entries() -> void:
	level_option_button.visible = true
	_clear_tree()
	_show_loading(true)
	level_entries_page = yield(Analytics.get_level_leaderboard_entries(), "completed")
	show_game_scores = false	
	_show_loading(false)
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


func _show_loading(loading:bool) -> void:
	self.loading = loading
	loading_label.visible = loading
	
func _on_CloseTextureButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

func _on_LevelButton_pressed():
	if loading: 
		return
	_load_level_entries()

func _on_GameButton_pressed():
	if loading:
		return
	_load_game_entries()

func _populate_level_option_button() -> void:
	for level_index in range(0, LevelData.get_playable_level_count() - 1):
		var level = LevelData.levelsArray[level_index]
		level_option_button.add_item(level.name, level_index)

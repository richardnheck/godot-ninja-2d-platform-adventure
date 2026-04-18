#------------------------------
# ProgressScreen
#------------------------------
extends Control
class_name ProgressScreen

signal on_closed

# Specify the world(stage) for which to show the levels
export(int,1,3) var world = 1

onready var game_tree = $"%GameProgressTree"
onready var level_tree = $"%LevelProgressTree"
onready var stage_option_button = $"%StageOptionButton"
onready var control = $Control

var game_tree_root = null
var level_tree_root = null

func _ready() -> void:
	_populate_stage_option_button()
	_init_game_tree()
	_init_level_tree()
	
	for child in game_tree.get_children():
		print(child)
		if child is VScrollBar:
			child.value = 0
			child.visible = false
			
			child.mouse_filter = Control.MOUSE_FILTER_STOP

func _process(delta):
	pass

# Handle when the scene becomes visible
func _on_visibility_changed():
	if is_visible_in_tree():
		_initialize()	
			
func _initialize() -> void:
	_populate_game_tree()
	_populate_level_tree()
	
func _init_game_tree() -> void:
	game_tree.set_column_title(0, "Completion Time")
	game_tree.set_column_min_width(0, 90)
	game_tree.set_column_expand(0, true)
	
	game_tree.set_column_title(1, "Deaths")
	game_tree.set_column_min_width(1, 40)
	game_tree.set_column_expand(1, true)
	
	game_tree.set_column_title(2, "Date")
	game_tree.set_column_min_width(2, 40)
	game_tree.set_column_expand(2, true)
	
	game_tree_root = game_tree.create_item()
	
func _init_level_tree() -> void:
	level_tree.set_column_title(0, "Level")
	level_tree.set_column_min_width(0, 49)
	level_tree.set_column_expand(0, false)
	
	level_tree.set_column_title(1, "Completion Time")
	level_tree.set_column_min_width(1, 90)
	level_tree.set_column_expand(1, false)
	
	level_tree.set_column_title(2, "Deaths")
	level_tree.set_column_min_width(2, 40)
	level_tree.set_column_expand(2, false)
	
	level_tree.set_column_title(3, "Date")
	level_tree.set_column_expand(3, true)
	
	level_tree_root = level_tree.create_item()

func _populate_game_tree() -> void:
	game_tree_root = _clear_tree(game_tree)
	var item = game_tree.create_item(game_tree_root)
	item.set_text(0, Stopwatch.get_time_as_formatted_string(0, Stopwatch.TimeFormat))
	item.set_text(1, "0")
	item.set_text(2, str("0000-00-00").left(10))  # Grab only date part without time e.g. 2026-04-18

	# Disable tooltips on hover
	item.set_tooltip(0," ")
	item.set_tooltip(1," ")
	item.set_tooltip(2," ")
	
func _populate_level_tree() -> void:
	level_tree_root = _clear_tree(level_tree)
	for level_index in LevelData.get_levels_for_world(1).size():
		var item = level_tree.create_item(level_tree_root)
		item.set_text(0, str(level_index+1))
		item.set_text(1, Stopwatch.get_time_as_formatted_string(0, Stopwatch.TimeFormat))
		item.set_text(2, "0")
		item.set_text(3, str("0000-00-00").left(10))  # Grab only date part without time e.g. 2026-04-18

		# Disable tooltips on hover
		item.set_tooltip(0," ")
		item.set_tooltip(1," ")
		item.set_tooltip(2," ")
	
func _clear_tree(tree:Tree) -> TreeItem:
	tree.clear()
	return tree.create_item()   # create and return the root


static func add_entry_to_level_tree(tree:Tree, tree_root:TreeItem, entry) -> void:
	var display_name = entry.player_display_name
	var item = tree.create_item(tree_root)
#	item.set_text(0, str(entry.position + 1))
#	item.set_text(1, display_name)
#	item.set_text(2, Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat))
#	item.set_text(3, str(entry.get_prop("deaths").value))
#	item.set_text_align(3, TreeItem.ALIGN_CENTER)
#	item.set_text(4, str(entry.updated_at).left(10))  # Grab only date part without time e.g. 2026-04-18
#
#	# Disable tooltips on hover
#	item.set_tooltip(0," ")
#	item.set_tooltip(1," ")
#	item.set_tooltip(2," ")
#	item.set_tooltip(3," ")
#	item.set_tooltip(4," ")
		
# Populate the stage option button with all the levels for the specified world
func _populate_stage_option_button() -> void:
	stage_option_button.add_item("Stage 1")
	stage_option_button.add_item("Stage 2")
	stage_option_button.add_item("Stage 3")

func _on_CloseButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

func _on_StageOptionButton_item_selected():
	pass # Replace with function body.

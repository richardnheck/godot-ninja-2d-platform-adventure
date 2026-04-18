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

const NO_TIME = "        -"
const NO_SUBMITTED_DATE = "            -"

var game_tree_root = null
var level_tree_root = null
var current_world = 1

func _ready() -> void:
	_populate_stage_option_button()
	_init_game_tree()
	_init_level_tree()
	

func _process(delta):
	pass

# Handle when the scene becomes visible
func _on_visibility_changed():
	if is_visible_in_tree():
		_initialize()	
			
func _initialize() -> void:
	current_world = world
	stage_option_button.select(current_world - 1)
	
	_populate_game_tree()
	_populate_level_tree()
	
func _init_game_tree() -> void:
	var index = 0
	game_tree.hide_folding = true
	game_tree.set_column_title(index, "Completed")
	game_tree.set_column_min_width(index, 60)
	game_tree.set_column_expand(index, false)
	index = index + 1
	game_tree.set_column_title(index, "Time")
	game_tree.set_column_min_width(index, 70)
	game_tree.set_column_expand(index, false)
	index = index + 1
	game_tree.set_column_title(index, "   Deaths")
	game_tree.set_column_min_width(index, 50)
	game_tree.set_column_expand(index, false)
	index = index + 1
	game_tree.set_column_title(index, "Submitted")
	game_tree.set_column_min_width(index, 40)
	game_tree.set_column_expand(index, true)
	index = index + 1
	game_tree_root = game_tree.create_item()
	
func _init_level_tree() -> void:
	level_tree.set_column_title(0, "Level")
	level_tree.set_column_min_width(0, 35)
	level_tree.set_column_expand(0, false)
	
	level_tree.set_column_title(1, "Time")
	level_tree.set_column_min_width(1, 80)
	level_tree.set_column_expand(1, false)
	
	level_tree.set_column_title(2, "   Deaths")
	level_tree.set_column_min_width(2, 50)
	level_tree.set_column_expand(2, false)
	
	level_tree.set_column_title(3, "Submitted")
	level_tree.set_column_expand(3, true)
	
	level_tree_root = level_tree.create_item()

func _populate_game_tree() -> void:
	var completed_game = GameState.has_completed_game()
	var total_deaths = GameState.level_results.get_total_deaths()
	var total_time = GameState.level_results.get_total_completion_time()
	game_tree_root = _clear_tree(game_tree)
	var item = game_tree.create_item(game_tree_root)
	item.set_text(0, "Yes" if completed_game else "No")
	item.set_text_align(0, TreeItem.ALIGN_CENTER)
	
	var time = Stopwatch.get_time_as_formatted_string(total_time, Stopwatch.TimeFormat)
	var submitted = _get_iso_date_from_msecs(total_time) if completed_game else NO_SUBMITTED_DATE
	
	item.set_text(1, time)
	item.set_text(2, str(total_deaths))
	item.set_text_align(2, TreeItem.ALIGN_CENTER)
	item.set_text(3, submitted) 

	# Disable tooltips on hover
	item.set_tooltip(0," ")
	item.set_tooltip(1," ")
	item.set_tooltip(2," ")
	
func _populate_level_tree() -> void:
	print("Populated level for world: ", current_world)
	level_tree_root = _clear_tree(level_tree)

	var num_levels = LevelData.get_levels_for_world(current_world).size()
	var start_index = (current_world - 1) * LevelData.LEVELS_PER_WORLD
	for index in num_levels:
		var level_index = start_index + index
		print("level_index", level_index)
		var level_result = GameState.level_results.get_level_result(level_index)
		print(level_result)
		var item = level_tree.create_item(level_tree_root)
		item.set_text(0, str(index+1) if index < num_levels - 1 else "Boss" )
		item.set_text_align(0, TreeItem.ALIGN_CENTER)
		
		var completed_level = level_result.completion_time > 0.0
		var time = Stopwatch.get_time_as_formatted_string(level_result.completion_time, Stopwatch.TimeFormat) if completed_level else NO_TIME
		var deaths = str(level_result.deaths) if completed_level else "-"
		var submitted = _get_iso_date_from_msecs(level_result.timestamp) if completed_level else NO_SUBMITTED_DATE
		item.set_text(1, time)
		item.set_text(2, deaths)
		item.set_text_align(2, TreeItem.ALIGN_CENTER)
		item.set_text(3, submitted)  # Grab only date part without time e.g. 2026-04-18

		# Disable tooltips on hover
		item.set_tooltip(0," ")
		item.set_tooltip(1," ")
		item.set_tooltip(2," ")
	
func _clear_tree(tree:Tree) -> TreeItem:
	tree.clear()
	return tree.create_item()   # create and return the root

# Populate the stage option button with all the levels for the specified world
func _populate_stage_option_button() -> void:
	stage_option_button.add_item("Stage 1", LevelData.WORLD1)
	stage_option_button.add_item("Stage 2", LevelData.WORLD2)
	stage_option_button.add_item("Stage 3", LevelData.WORLD3)

func _on_CloseButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

func _on_StageOptionButton_item_selected(index):
	current_world = stage_option_button.get_item_id(index)
	_populate_level_tree()

func _get_iso_date_from_msecs(msecs: int) -> String:
	# 1. Convert milliseconds to seconds
	var seconds = msecs / 1000
	
	# 2. Get the date/time dictionary from the timestamp
	var dt = OS.get_datetime_from_unix_time(seconds)
	
	# 3. Format into ISO 8601 string: YYYY-MM-DD
	var iso_string = "%04d-%02d-%02d" % [
		dt.year, dt.month, dt.day
	]
	
	return iso_string

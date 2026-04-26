#------------------------------
# ProgressScreen
#------------------------------
extends Control
class_name ProgressScreen

signal on_closed

# Specify the world(stage) for which to show the levels
export(int,1,3) var world = 1

onready var game_grid = $"%GameProgressGrid"
onready var level_grid = $"%LevelProgressGrid"
onready var stage_option_button = $"%StageOptionButton"
onready var control = $Control
onready var game_header_panel = $Control/GameProgressHeaderPanel
onready var level_header_panel = $Control/LevelProgressHeaderPanel
onready var game_header_labels = [
	$Control/GameProgressHeaderPanel/GameProgressHeader/CompletedLabel,
	$Control/GameProgressHeaderPanel/GameProgressHeader/TimeLabel,
	$Control/GameProgressHeaderPanel/GameProgressHeader/DeathsLabel,
	$Control/GameProgressHeaderPanel/GameProgressHeader/SubmittedLabel
]
onready var level_header_labels = [
	$Control/LevelProgressHeaderPanel/LevelProgressHeader/LevelLabel,
	$Control/LevelProgressHeaderPanel/LevelProgressHeader/TimeLabel,
	$Control/LevelProgressHeaderPanel/LevelProgressHeader/DeathsLabel,
	$Control/LevelProgressHeaderPanel/LevelProgressHeader/SubmittedLabel
]

const NO_TIME = "        -"
const NO_SUBMITTED_DATE = "            -"
const DATA_CELL_BG_ALPHA = 0.35

const GAME_COLUMN_WIDTHS = [60, 70, 50, 40]
const LEVEL_COLUMN_WIDTHS = [35, 80, 50, 40]

var current_world = 1
var data_cell_stylebox: StyleBoxFlat = null

func _ready() -> void:
	_configure_data_cell_stylebox()
	_apply_header_style()
	_populate_stage_option_button()

func _configure_data_cell_stylebox() -> void:
	data_cell_stylebox = StyleBoxFlat.new()
	data_cell_stylebox.bg_color = Color(0, 0, 0, DATA_CELL_BG_ALPHA)
	data_cell_stylebox.content_margin_left = 2
	data_cell_stylebox.content_margin_right = 2
	data_cell_stylebox.content_margin_top = 0
	data_cell_stylebox.content_margin_bottom = 0

func _apply_header_style() -> void:
	# Get the same header style from the tree component used in leaderboards
	var tree_style = control.theme.get_stylebox("title_button_normal", "Tree")
	if tree_style:
		game_header_panel.add_stylebox_override("panel", tree_style)
		level_header_panel.add_stylebox_override("panel", tree_style)

	var tree_title_font = control.theme.get_font("title_button_font", "Tree")
	for label in game_header_labels:
		_style_header_label(label, tree_title_font)
	for label in level_header_labels:
		_style_header_label(label, tree_title_font)

func _style_header_label(label: Label, header_font: Font) -> void:
	if header_font:
		label.add_font_override("font", header_font)
	label.add_color_override("font_color", Color.white)
	label.add_color_override("font_color_shadow", Color.black)
	label.add_constant_override("shadow_offset_x", 0)
	label.add_constant_override("shadow_offset_y", 1)
	

func _process(delta):
	pass

# Handle when the scene becomes visible
func _on_visibility_changed():
	if is_visible_in_tree():
		_initialize()	
			
func _initialize() -> void:
	current_world = world
	stage_option_button.select(current_world - 1)
	
	_populate_game_grid()
	_populate_level_grid()

func _populate_game_grid() -> void:
	var completed_game = GameState.has_completed_game()
	var total_deaths = GameState.level_results.get_total_deaths()
	var total_time = GameState.level_results.get_total_completion_time()
	_clear_grid(game_grid)
	
	var time = Stopwatch.get_time_as_formatted_string(total_time, Stopwatch.TimeFormat)
	var submitted = _get_iso_date_from_msecs(total_time) if completed_game else NO_SUBMITTED_DATE

	_add_grid_cell(game_grid, "Yes" if completed_game else "No", GAME_COLUMN_WIDTHS[0], true)
	_add_grid_cell(game_grid, time, GAME_COLUMN_WIDTHS[1], false)
	_add_grid_cell(game_grid, str(total_deaths), GAME_COLUMN_WIDTHS[2], true)
	_add_grid_cell(game_grid, submitted, GAME_COLUMN_WIDTHS[3], false, true)

func _populate_level_grid() -> void:
	print("Populated level for world: ", current_world)
	_clear_grid(level_grid)

	var num_levels = LevelData.get_levels_for_world(current_world).size()
	var start_index = (current_world - 1) * LevelData.LEVELS_PER_WORLD
	for index in num_levels:
		var level_index = start_index + index
		print("level_index", level_index)
		var level_result = GameState.level_results.get_level_result(level_index)
		print(level_result)
		_add_grid_cell(level_grid, str(index + 1) if index < num_levels - 1 else "Boss", LEVEL_COLUMN_WIDTHS[0], true)
		
		var completed_level = level_result.completion_time > 0.0
		var time = Stopwatch.get_time_as_formatted_string(level_result.completion_time, Stopwatch.TimeFormat) if completed_level else NO_TIME
		var deaths = str(level_result.deaths) if completed_level else "-"
		var submitted = _get_iso_date_from_msecs(level_result.timestamp) if completed_level else NO_SUBMITTED_DATE
		_add_grid_cell(level_grid, time, LEVEL_COLUMN_WIDTHS[1], false)
		_add_grid_cell(level_grid, deaths, LEVEL_COLUMN_WIDTHS[2], true)
		_add_grid_cell(level_grid, submitted, LEVEL_COLUMN_WIDTHS[3], false, true)

func _clear_grid(grid: GridContainer) -> void:
	while grid.get_child_count() > 0:
		var child = grid.get_child(0)
		grid.remove_child(child)
		child.queue_free()

func _add_grid_cell(grid: GridContainer, text: String, width: int, centered: bool = false, expand: bool = false) -> void:
	var cell = Panel.new()
	cell.rect_min_size = Vector2(width, 13)
	if expand:
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if data_cell_stylebox:
		cell.add_stylebox_override("panel", data_cell_stylebox)
	cell.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var label = Label.new()
	label.text = text
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.margin_left = 2.0
	label.margin_right = -2.0
	label.add_color_override("font_color", Color.white)
	label.add_color_override("font_color_shadow", Color.black)
	label.add_constant_override("shadow_offset_x", 0)
	label.add_constant_override("shadow_offset_y", 1)
	if centered:
		label.align = Label.ALIGN_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cell.add_child(label)
	grid.add_child(cell)

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
	_populate_level_grid()

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

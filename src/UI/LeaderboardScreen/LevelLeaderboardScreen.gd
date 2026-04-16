#------------------------------
# LevelLeaderboardScreen
#------------------------------
extends Control
class_name LevelLeaderBoardScreen

signal on_closed

# Specify the world for which to show the levels
export(int,1,3) var world = 1

onready var tree = $"%Tree"
onready var loading_label = $"%Loading"
onready var level_option_button = $"%LevelOptionButton"

var loading = false
var tree_root = null
var entries_page = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Handle when the scene becomes visible
func _on_visibility_changed():
	if is_visible_in_tree():
		_initialize()	
			
func _initialize() -> void:
	_populate_level_option_button()
	
	tree_root = LeaderboardUtils.init_tree(tree)
	_load_selected_level()

func _load_selected_level() -> void:
	var selected_level_index = level_option_button.get_selected_id()
	_load_level_entries(selected_level_index)			
		
func _load_level_entries(level_index:int) -> void:
	_show_loading(true)
	entries_page = yield(Analytics.get_level_leaderboard_entries_for_level(level_index), "completed")
	_show_loading(false)
	LeaderboardUtils.populate_tree(tree, tree_root, entries_page)

func _show_loading(loading:bool) -> void:
	self.loading = loading
	loading_label.visible = loading
	
# Populate the level option button with all the levels for the specified world
func _populate_level_option_button() -> void:
	var levels = LevelData.get_levels_for_world(world)
	var start_index = (world - 1) * LevelData.LEVELS_PER_WORLD
	for index in range(0, levels.size() - 1): 
		var level = levels[index]
		var level_index = start_index + index
		level_option_button.add_item("%s. %s" % [index + 1, level.name], level_index)

func _on_CloseTextureButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

func _on_LevelOptionButton_item_selected(index):
	_load_selected_level()

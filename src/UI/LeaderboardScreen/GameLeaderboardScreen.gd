#------------------------------
# GameLeaderboardScreen
#------------------------------
extends Control

signal on_closed

onready var tree = $"%Tree"
onready var loading_label = $"%Loading"

var loading:bool = false
var tree_root:TreeItem = null
var entries_page = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass

# Handle when the scene becomes visible
func _on_visibility_changed():
	if is_visible_in_tree():
		_initialize()	

func _initialize() -> void:
	tree_root = LeaderboardUtils.init_tree(tree)
	_load_game_entries()

func _load_game_entries() -> void:
	_show_loading(true)
	entries_page = yield(Analytics.get_game_leaderboard_entries(), "completed")	
	_show_loading(false)
	LeaderboardUtils.populate_tree(tree, tree_root, entries_page)

func _show_loading(loading:bool) -> void:
	self.loading = loading
	loading_label.visible = loading
	
func _on_CloseButton_pressed():
	Game_AudioManager.sfx_ui_basic_blip_select.play()
	emit_signal("on_closed")

class_name LeaderboardUtils

static func init_tree(tree:Tree) -> TreeItem:
	tree.set_column_title(0, "Rank")
	tree.set_column_min_width(0, 30)
	tree.set_column_expand(0, false)
	
	tree.set_column_title(1, "Name")
	tree.set_column_min_width(1, 150)
	tree.set_column_expand(1, false)
	
	tree.set_column_title(2, "Time")
	tree.set_column_title(3, "Deaths")
	
	return tree.create_item()

static func clear_tree(tree:Tree) -> TreeItem:
	tree.clear()
	return tree.create_item()   # create and return the root

static func populate_tree(tree, tree_root, entries_page) -> void:
	clear_tree(tree)
	if entries_page:
		for entry in entries_page.entries:
			add_entry_to_tree(tree, tree_root, entry)	 

static func add_entry_to_tree(tree:Tree, tree_root:TreeItem, entry:TaloLeaderboardEntry) -> void:
	var display_name = entry.player_display_name
	var item = tree.create_item(tree_root)
	item.set_text(0, str(entry.position + 1))
	item.set_text(1, display_name)
	item.set_text(2, Stopwatch.get_time_as_formatted_string(entry.score, Stopwatch.TimeFormat))
	item.set_text(3, str(entry.get_prop("deaths").value))

#-------------------------
# Analytics
#-------------------------
# This is for Talo Analytics but since there is no plugin available
# for Godot 3, it is using the API instead (with some code ported from the Godot 4 plugin)

extends Node

const talo_base_url = "https://api.trytalo.com/v1/"

var alias_identifier = null
var player_alias_id = null
var player_id = null

const STAT_DEATHS = "deaths"
const STAT_LEVELS_COMPLETED = "levels-completed"
const STAT_GAME_COMPLETIONS = "game-completions"

const EVENT_LEVEL_COMPLETED = "level-completed"		# fired when user completes a level
const EVENT_LEVEL_ATTEMPTED = "level-attempted"		# fired when user attempts the level but dies
const EVENT_GAME_COMPLETED  = "game-completed"		# fire when user completes the game

const LEADERBOARD_LEVEL_HIGH_SCORE = "level-high-score"
const LEADERBOARD_GAME_HIGH_SCORE = "game-high-score"

func _ready():
	print("Initializing Analytics...")
	
	var existing_player = true if GameState.get_player_identifier() else false
	if existing_player:
		print("Existing player")
		# Get the player identifier from the game save state
		alias_identifier = GameState.get_player_identifier()
	else:
		# No player exists yet so create a unique identifier
		print("New player")
		alias_identifier = _generate_identifier()
				
	yield(_identify_player(alias_identifier), "completed")
	if not existing_player:
		# Also set a generated display name for the user to start with
		var display_name = UsernameGenerator.new().generate_username()
		print("Generating display name= ", display_name)
		update_player_display_name(display_name)

# Determine if Talo analytics is enabled
func _is_enabled() -> bool:
	return Env.talo_access_key != ""
	
# Update the player display name
func update_player_display_name(name:String) -> void:
	var props = [
		TaloProp.new("display_name", name)
	]
	
	var success = yield(_update_player_props(props),"completed")
	if success:
		# Display name was successfully updated so save it to game state
		GameState.set_player_display_name(name)	
		GameState.save()	
	
# Track player deaths
func track_deaths():
	_track_stat(STAT_DEATHS)

# Track levels completed
func track_levels_completed():
	_track_stat(STAT_LEVELS_COMPLETED)

# Track game completions
func track_game_completions():
	_track_stat(STAT_GAME_COMPLETIONS)

# Track a level completed event
func track_event_level_completed(current_level_index:int, level_completion_time:String):
	var props = _build_meta_props() + _build_level_base_props(current_level_index) + [
		TaloProp.new("completion_time", level_completion_time)
	]
	
	var event = {
		"name": EVENT_LEVEL_COMPLETED,
		"timestamp": _get_timestamp_msec(),   # nb: api docs say unix timestamp but that is incorrect
		"props" :  TaloPropUtils.serialise_props(props)
	}
	
	_track_event(event)
	
# Track a level attempted event
func track_event_level_attempted(current_level_index:int, elapsed_time:String, player_death_position:String):
	var props = _build_meta_props() + _build_level_base_props(current_level_index) + [
		TaloProp.new("death_position", player_death_position),
		TaloProp.new("elapsed_time", elapsed_time)
	]
	
	var event = {
		"name": EVENT_LEVEL_ATTEMPTED,
		"timestamp": _get_timestamp_msec(),   # nb: api docs say unix timestamp but that is incorrect
		"props" :  TaloPropUtils.serialise_props(props)
	}
	
	_track_event(event)

func track_event_game_completed() -> void:
	var props = _build_meta_props() 
	var event = {
		"name": EVENT_GAME_COMPLETED,
		"timestamp": _get_timestamp_msec(),   # nb: api docs say unix timestamp but that is incorrect
		"props" :  TaloPropUtils.serialise_props(props)
	}
	
	_track_event(event)

func add_level_leaderboard_entry(current_level_index: int, score: float) -> void:
	var props =  _build_level_base_props(current_level_index)
	_add_leaderboard_entry(LEADERBOARD_LEVEL_HIGH_SCORE, score, props)

func add_game_leaderboard_entry(score: float, deaths:int) -> void:
	var props = [
		TaloProp.new("deaths", deaths)
	]
	_add_leaderboard_entry(LEADERBOARD_GAME_HIGH_SCORE, score, props)

func get_game_leaderboard_entries(page:int = 0) -> EntriesPage:
	DebugLog.log("Getting game leaderboard entries...")
	return _get_leaderboard_entries(LEADERBOARD_GAME_HIGH_SCORE, page)

func get_level_leaderboard_entries(page:int = 0) -> EntriesPage:
	return _get_leaderboard_entries(LEADERBOARD_LEVEL_HIGH_SCORE, page)

func get_level_leaderboard_entries_for_level(level_index:int, page:int = 0) -> EntriesPage:
	DebugLog.log("Getting level leaderboard entries for level: %s" % [level_index])
	var filter_prop = TaloProp.new("level_index", level_index)
	return _get_leaderboard_entries(LEADERBOARD_LEVEL_HIGH_SCORE, page, filter_prop)

func get_players_by_display_name(display_name:String) -> Array:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var base_url = talo_base_url + "players/search"
	var params = "query="+ display_name.http_escape()
	var url = base_url + "?" + params
	http_request.request(url, _get_base_headers(), true, HTTPClient.METHOD_GET)
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	return response.players

# Identify the player
func _identify_player(identifier):
	if !_is_enabled(): return
	print("Identifying player: " + identifier)
	DebugLog.log("Identifying player: %s" % [identifier])
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var base_url = talo_base_url + "players/identify"
	var params = "identifier="+identifier+"&service=username"
	var url = base_url + "?" + params
	http_request.request(url, _get_base_headers(), true, HTTPClient.METHOD_GET)
	var result = yield(_build_response(http_request),"completed")
	
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		print("Player identified: ", response)
		DebugLog.log("Player identified!")
		DebugLog.log(JSON.print(response))
		# remember player alias id as this is required in subsequent requests
		if response.has("alias"):
			player_alias_id = response.alias.id
			player_id = response.alias.player.id   # this player id is required for updating player props
			# player has been successfully identified so save the identifier in the game state
			GameState.set_player_identifier(response.alias.identifier)	
			GameState.save()
	else:
		var error_response = result.response if result.body else ""
		print("Error identifying player: ", error_response, result.response_code)
		DebugLog.log("Error identifying player: %s, %s" % [error_response, result.response_code])
	http_request.queue_free()

func _update_player_props(props:Array) -> bool:
	if !_is_enabled(): return false
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var url = talo_base_url + "players/%s" % player_id
		
	var data = {
		"props" : TaloPropUtils.serialise_props(props)
	}
	http_request.request(url, _get_base_headers(), true, HTTPClient.METHOD_PATCH, JSON.print(data))
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		print("Player props updated: ", response)
		http_request.queue_free()
		return true
	else:
		print("Error updating player props: ", response, result.response_code)
		http_request.queue_free()
		return false
	


func _build_level_base_props(current_level_index:int):
	return  [
		TaloProp.new("level_index", current_level_index),
		TaloProp.new("level_scene", LevelData.get_level_scene_by_index(current_level_index)),
		TaloProp.new("deaths", LevelMetrics.deaths)
	]

func _track_event(event):
	if !_is_enabled(): return
	var url = talo_base_url + "events"
	var headers = _get_base_headers()
	
	var data = {
		"events" : [
			event
		]
	}
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, JSON.print(data))
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		pass
	else:
		print("Track event error: ", response, result.response_code)
	http_request.queue_free()

## Add an entry to a leaderboard. The props (key-value pairs) parameter is used to store additional data with the entry.
func _add_leaderboard_entry(internal_name: String, score: float, props: Array = []) -> void:
	if !_is_enabled(): return
	var url = talo_base_url + "leaderboards/%s/entries" % internal_name
	var headers = _get_base_headers()
	
	var data = {
		"score" : score,
		"props" : TaloPropUtils.serialise_props(props)
	}
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, JSON.print(data))
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		pass
	else:
		print("Add leaderboard entry error: ", response, result.response_code)
	http_request.queue_free()

func _get_leaderboard_entries(internal_name: String, page: int = 0, prop: TaloProp = null) -> EntriesPage:
	if !_is_enabled(): return null
	var url = talo_base_url + "leaderboards/%s/entries?%s" % [internal_name, page]
	if prop:
		url += "&propKey=%s&propValue=%s" % [prop.key, prop.value]
		
	var headers = _get_base_headers()
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request(url, headers, true, HTTPClient.METHOD_GET)
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	var entries_page = null
	match result.response_code:
		200: 
			var talo_entries: Array 
			for entry in response.entries:
				var talo_entry := TaloLeaderboardEntry.new(entry)
				talo_entries.append(talo_entry)
			entries_page = EntriesPage.new(talo_entries, response.count, response.itemsPerPage, response.isLastPage)
			DebugLog.log("Success: Entries count = %s" % [entries_page.entries.size()])
		_:
			DebugLog.log("Error: %s $s" % [response, result.response_code])
			emit_signal("on")
		
	http_request.queue_free()
	return entries_page

func _get_base_headers() -> Array:
	var base_headers = [
		"Content-Type: application/json",
		"Accept: application/json",
		"Authorization: Bearer " + Env.talo_access_key,
		"X-Talo-Dev-Build: %s" % ("1" if OS.is_debug_build() else "0"),
		"X-Talo-Include-Dev-Data: %s" % ("1" if OS.is_debug_build() else "0"),
	]
	
	if player_alias_id:
		base_headers.append("X-Talo-Alias: " + str(player_alias_id))
		
	return base_headers
	

# Track a stat
func _track_stat(stat_name:String):
	if !_is_enabled(): return
	var url = talo_base_url + "game-stats/" + stat_name
	var headers = _get_base_headers()
	
	var data = { "change" : 1 }	  # increment by 1
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request(url, headers, true, HTTPClient.METHOD_PUT, JSON.print(data))
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		pass
	else:
		print("Track stat error: ", result.response, result.response_code)
	http_request.queue_free()

## Get an ISO 8601 datetime string (YYYY-MM-DDTHH:MM:SS) from the current time.
func _get_current_datetime_string() -> String:
	return Time.get_datetime_string_from_unix_time(int(Time.get_unix_time_from_system()))

## Get the current time in milliseconds.
func _get_timestamp_msec() -> int:
	return int(ceil(Time.get_unix_time_from_system()) * 1000)


func _build_response(http_request: HTTPRequest) -> TaloClientResponse:
	var res = yield(http_request, "request_completed")
	return TaloClientResponse.new(res[0], res[1], res[2], res[3])

func _get_window_mode() -> String:
	if OS.window_fullscreen:
		return "Fullscreen window"
	
	if OS.window_borderless:
		return "Borderless window"
	else:
		return "Bordered window"
	
func _get_game_version() -> String:
	return ProjectSettings.get_setting("application/config/version")

func _build_meta_props() -> Array:
	return [
		TaloProp.new("META_OS", OS.get_name()),
		TaloProp.new("META_GAME_VERSION", _get_game_version()),
		TaloProp.new("META_WINDOW_MODE", _get_window_mode()),
		TaloProp.new("META_SCREEN_WIDTH", str(OS.get_real_window_size().x)),
		TaloProp.new("META_SCREEN_HEIGHT", str(OS.get_real_window_size().y)),
		TaloProp.new("META_DEBUG_BUILD", OS.is_debug_build())
	]
	
## Generate a mostly-unique identifier.
func _generate_identifier() -> String:
	var time_hash = str(_get_timestamp_msec()).sha256_text()
	var size := 12
	var split_start := RandomNumberGenerator.new().randi_range(0, time_hash.length() - size)
	return time_hash.substr(split_start, size)
	
class TaloClientResponse:
	var result: int
	var response_code: int
	var headers: PoolStringArray
	var body: PoolByteArray

	func _init(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
		# web builds return RESULT_NO_RESPONSE (6) + status 0 for HTTP 204 responses
		if result == HTTPRequest.RESULT_NO_RESPONSE and response_code == 0:
			self.result = HTTPRequest.RESULT_SUCCESS
			self.response_code = HTTPClient.RESPONSE_NO_CONTENT
		else:
			self.result = result
			self.response_code = response_code

		self.headers = headers
		self.body = body


class EntriesPage:
	var entries: Array
	var count: int
	var items_per_page: int
	var is_last_page: bool

	func _init(entries: Array, count: int, items_per_page: int, is_last_page: bool) -> void:
		self.entries = entries
		self.count = count
		self.items_per_page = items_per_page
		self.is_last_page = is_last_page

class AddEntryResult:
	var entry: TaloLeaderboardEntry
	var updated: bool

	func _init(entry: TaloLeaderboardEntry, updated: bool) -> void:
		self.entry = entry
		self.updated = updated

class GetEntriesOptions:
	var page: int = 0
	var alias_id: int = -1
	var player_id: String = ""
	var include_archived: bool = false
	var prop_key: String = ""
	var prop_value: String = ""
	var start_date: String = ""
	var end_date: String = ""
	var alias_service: String = ""

class GetCachedEntriesOptions:
	var alias_id: int = -1
	var player_id: String = ""
	var alias_service: String = ""

#-------------------------
# Analytics
#-------------------------
extends Node

const talo_base_url = "https://api.trytalo.com/v1/"

var player_identifier = "unique_player_id"
var player_alias_id = null

const STAT_DEATHS = "deaths"
const STAT_LEVELS_COMPLETED = "levels-completed"

const EVENT_LEVEL_COMPLETED = "level-completed"

func _ready():
	# TODO: Generate a unique player id 
	identify_player(player_identifier)

# Determine if Talo analytics is enabled
func _is_enabled() -> bool:
	return Env.talo_access_key != ""

# Identify the player
func identify_player(identifier):
	if !_is_enabled(): return
	print("Identifying player: " + identifier)
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
		# Save the alias id as this is required in subsequent requests
		player_alias_id = response.alias.id
	else:
		print("Error identifying player: ", result.response, result.response_code)
	http_request.queue_free()
	
# Track player deaths
func track_deaths():
	_track_stat(STAT_DEATHS)

# Track levels completed
func track_levels_completed():
	_track_stat(STAT_LEVELS_COMPLETED)

# Track a level completed event
func track_event_level_completed(current_level_index:int):
	var event = {
		"name": EVENT_LEVEL_COMPLETED,
		"timestamp": _get_timestamp_msec(),   # nb: api docs say unix timestamp but that is incorrect
		"props" : [
			{ 
				"key" : "level_index", 
				"value" : current_level_index 
			},
			{	
				"key": "level_name", 
				"value": LevelData.get_level_name_by_index(current_level_index) 
			},
			{	
				"key": "level_world", 
				"value": LevelData.get_world(current_level_index) 
			},
			{	
				"key": "deaths", 
				"value": LevelMetrics.deaths
			}
		]
	}
	_track_event(event)

func _track_event(event):
	if !_is_enabled(): return
	var url = talo_base_url + "events"
	var headers = _get_base_headers().duplicate() 
	headers.append("x-talo-alias: " + str(player_alias_id))
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
		print("Track event: ", response)
	else:
		print("Track event error: ", result.response, result.response_code)
	http_request.queue_free()


func _get_base_headers() -> Array:
	return [
		"Content-Type: application/json",
		"Authorization: Bearer " + Env.talo_access_key
	]

# Track a stat
func _track_stat(stat_name:String):
	if !_is_enabled(): return
	var url = talo_base_url + "game-stats/" + stat_name
	var headers = _get_base_headers().duplicate() 
	headers.append("x-talo-alias: " + str(player_alias_id))
	
	var data = { "change" : 1 }	  # increment by 1
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request(url, headers, true, HTTPClient.METHOD_PUT, JSON.print(data))
	var result = yield(_build_response(http_request),"completed")
	var response = JSON.parse(result.body.get_string_from_utf8()).result
	if result.response_code == 200:
		print("Track stat: ", response)
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

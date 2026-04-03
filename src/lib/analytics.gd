#-------------------------
# Analytics
#-------------------------
extends Node

var http_request:HTTPRequest

const talo_base_url = "https://api.trytalo.com/v1/"

var player_identifier = "unique_player_id"
var player_alias_id = null

const STAT_DEATHS = "deaths"
const STAT_LEVELS_COMPLETED = "levels-completed"

func _ready():
	# Create an HTTP request node and connect its completion signal.
	# This is for all requests except for the identify as we need to handle the response
	# specifically for that request
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_http_request_completed")
	
	# TODO: Generate a unique player id 
	identify_player(player_identifier)

# Identify the player
func identify_player(identifier):
	print("Identifying player: " + identifier)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_identify_player_request_completed")

	var base_url = talo_base_url + "players/identify"
	var params = "identifier="+identifier+"&service=username"
	var url = base_url + "?" + params
	http_request.request(url, _get_base_headers(), true, HTTPClient.METHOD_GET)

# Track player deaths
func track_deaths():
	_track_stat(STAT_DEATHS)

# Track levels completed
func track_levels_completed():
	_track_stat(STAT_LEVELS_COMPLETED)

func _get_base_headers() -> Array:
	return [
		"Content-Type: application/json",
		"Authorization: Bearer " + Env.talo_access_key
		#"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjE0NDUsImFwaSI6dHJ1ZSwiaWF0IjoxNzc1MTkwNDQ2fQ.fIaX-9efsweEmRN6kdo5MfkK9fi2ntA_dmgXuo0cWJA"
	]

# Track a stat
func _track_stat(stat_name:String):
	var url = talo_base_url + "game-stats/" + stat_name
	var headers = _get_base_headers().duplicate() 
	headers.append("x-talo-alias: " + String(player_alias_id))
	
	var data = { "change" : 1 }	  # increment by 1
	http_request.request(url, headers, true, HTTPClient.METHOD_PUT, JSON.print(data))

func _on_identify_player_request_completed(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		print("Player identified: ", response)
		# Save the alias id as this is required in subsequent requests
		player_alias_id = response.alias.id
	else:
		print("Error identifying player: ", response, response_code)

func _on_http_request_completed(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8()).result
	if response_code == 200:
		print("Talo Analytics Response: ", response)
	else:
		print("Talo Analytics Error: ", response, response_code)


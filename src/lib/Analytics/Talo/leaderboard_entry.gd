class_name TaloLeaderboardEntry extends TaloEntityWithProps

enum LeaderboardSortMode {
	ASC,
	DESC
}

var id: int
var position: int
var score: float
var player_alias: String
var leaderboard_name: String
var leaderboard_internal_name: String
var leaderboard_sort_mode: int   # LeaderboardSortMode
var created_at: String
var updated_at: String
var deleted_at: String

var player_display_name: String
var deaths: int	

func _init(data: Dictionary):
	var taloProps:Array = []
	for prop in data.props:
		taloProps.append(TaloProp.new(prop.key, prop.value))
	._init(taloProps)

	id = data.id
	position = data.position
	score = data.score
	player_alias = str(data.playerAlias.id)#TaloPlayerAlias.new(data.playerAlias)
	
	# Get the player display name from the player props
	player_display_name = "UnknownMaster"
	var player_props = data.playerAlias.player.props
	for prop in player_props:
		if prop.key == "display_name":
			player_display_name = prop.value
			break

	
	leaderboard_name = data.leaderboardName
	leaderboard_internal_name = data.leaderboardInternalName
	leaderboard_sort_mode = LeaderboardSortMode.ASC if data.leaderboardSortMode.to_lower() == 'asc' else LeaderboardSortMode.DESC

	created_at = data.createdAt
	updated_at = data.updatedAt
	if data.deletedAt:
		deleted_at = data.deletedAt

extends Node

export var look_at_player_enabled:bool = true

onready var area2D:Area2D = $Area2D
onready var animatedSprite:AnimatedSprite = $AnimatedSprite
onready var player:Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	area2D.connect("body_entered", self, "_on_body_entered")
	
	# Start animation at a random time
	var t = rand_range(0,2)
	yield(get_tree().create_timer(t),"timeout")
	animatedSprite.playing = true
	
	_find_player()

func _process(delta: float) -> void:
	if look_at_player_enabled:
		_look_at_player()
	

# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()

func _find_player() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _look_at_player() -> void:
	if player:
		animatedSprite.flip_h = player.global_position < self.global_position

extends KinematicBody2D
class_name NpcBase

export var look_at_player_enabled:bool = true

# Determines whether npc can move
export var can_move:bool = true

# Determines whether npc is affected by gravity i.e does it fall
export var affected_by_gravity:bool = false

export var gravity:int = 15
var speed = 0.0
var velocity = Vector2()

onready var area2D:Area2D = $Pivot/Area2D
onready var animatedSprite:AnimatedSprite = $Pivot/AnimatedSprite
onready var tween:Tween = $Tween

# Reference to the player
onready var player:Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	# Listen for the player entering
	area2D.connect("body_entered", self, "_on_body_entered")
	
	# Start animation at a random time so all npc's do not have synchronised animations
	var t = rand_range(0,2)
	yield(get_tree().create_timer(t),"timeout")
	animatedSprite.playing = true
	
	# Get a reference to the player
	_find_player()
	

func _process(delta: float) -> void:
	if look_at_player_enabled:
		_look_at_player()
	
	if can_move:
		if affected_by_gravity:
			_apply_gravity()
		_move(velocity)

# Handle when a body enters the object
func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The body is the player so the player dies
		body.die()

# Find the player in the scene based on its group
func _find_player() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

# Make the npc look in the direction of the player
func _look_at_player() -> void:
	if player:
		animatedSprite.flip_h = player.global_position < self.global_position

# Apply gravity
func _apply_gravity() -> void:
	velocity.y += gravity;
	
func _move(vel):	
	velocity = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			owner.emit_signal('collided', collision)
	return velocity

tool
extends Area2D
class_name TofuKozo

enum Direction {
	LEFT = -1,		# Towards Screen left
	RIGHT = 1		# Towards Screen right
}

# The initial direction that tofu kozu faces
export(Direction) var direction = Direction.RIGHT

# Follow the player when set to true. This means it will change directions to follow the player
export(bool) var follow_player = true

onready var throw_timer = $ThrowTimer
onready var tofu_position = $TofuPosition2D


var throw := false
var player_in_range := false
var tofu:Tofu = null
var rng = RandomNumberGenerator.new()

const throw_impulse_strength := 240
const throw_x_amount := 0.15

var player:Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	# update the character to face the correct direction
	_update_character()
	
	# Add some tofu
	yield(get_tree().create_timer(0.1), "timeout")
	_add_tofu()
	

func set_player(player: Player):
	self.player = player


func _process(delta):
	_turn_to_player()


func _physics_process(delta):
	if Engine.editor_hint:
		return
		
	if throw:
		if tofu:
			var throw_direction = Vector2(throw_x_amount*direction, -1)		
			var impulse_strength_variant: int = rng.randi_range(-20, 20) 
			tofu.apply_impulse(Vector2.ZERO, throw_direction * (throw_impulse_strength + impulse_strength_variant))
			tofu = null
			throw = false

# Turn in the direction of the player
func _turn_to_player() -> void:
	if !follow_player:
		return
		
	if player and player_in_range:
		direction = -1 if player.global_position < self.global_position else 1
		_update_character()


func _update_character():
	self.scale.x = direction		


func _on_TofuKozo_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_ThrowTimer_timeout():
	_throw_tofu()
	
	
func _add_tofu() -> void:
	if Engine.editor_hint:
		return
		
	var instance:Tofu = preload("res://src/characters/enemies/tofu-kozo/Tofu.tscn").instance()
	instance.global_position = tofu_position.global_position
	get_parent().get_tree().current_scene.add_child(instance)
	tofu = instance

	
func _throw_tofu() -> void:
	if tofu:
		# Tofu exists so throw it
		if player_in_range:
			throw = true
	else:
		# Tofu doesn't exist so add some tofu and throw it
		_add_tofu()
		if player_in_range:
			throw = true


func _on_PlayerDetectionArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		if !player_in_range:
			player_in_range = true
			_throw_tofu()
			throw_timer.start()
		
		


func _on_PlayerDetectionArea2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		player_in_range = false

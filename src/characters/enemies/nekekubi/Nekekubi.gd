extends Node2D
class_name Nekekubi

onready var head = $Head
onready var tween = $Tween
onready var chase_timer:Timer = $ChaseTimer
onready var head_sprite = $Head/AnimatedSpriteHead

# Reference to the player
onready var player:Player = null

const speed = 100
var velocity = Vector2()

var is_head_chasing = false
var is_player_in_range = false

onready var tween_values = [Vector2.ZERO, Vector2.ZERO]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wait for player to be added to the scene and in order to get the player reference
	yield(get_tree().create_timer(0.5), "timeout")	
	_find_player()
	
	tween.connect("tween_completed", self, "_on_tween_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print_debug(str(head.position))
	pass

	
	# Find the player in the scene based on its group
func _find_player() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _start_tween():
	if !player:
		return 
		
	if(tween_values[0] == Vector2.ZERO):
		tween_values = [to_local(global_position), to_local(Vector2(player.global_position.x+16, player.global_position.y+16))]
	
	var tween_time = 0 
	var distance = 0 
	if is_head_chasing:
		# calculate distance between head and player
		distance = head.global_position.distance_to(player.global_position)
	else:
		# head is returning back to body so calculate distance back to the body
		distance = head.global_position.distance_to(self.global_position)
	tween_time = distance / speed	
	tween.interpolate_property(head, "position", tween_values[0], tween_values[1], tween_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()	

func _on_tween_completed(object: Object, key: NodePath) -> void:
	if is_head_chasing:
		is_head_chasing = false
		tween_values.invert()
		_start_tween()
	else:
		# Head is back at body so reset the tween and restart the chase timer
		tween_values = [Vector2.ZERO, Vector2.ZERO]
		if is_player_in_range:
			chase_timer.start()
		else: 
			head_sprite.play("idle")

# Handle when a body enters the object
func _on_head_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The body is the player so the player dies
		body.die()

func _on_body_Area2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The body is the player so the player dies
		body.die()

func _is_head_on_body():
	return head.position == Vector2(0,0)

func _on_ChaseTimer_timeout():
	chase_timer.stop()
	_chase_player()
	
func _chase_player():
	is_head_chasing = true
	_start_tween()
	
func _return_to_body():
	pass


func _on_PlayerDetectionArea2D_body_entered(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has entered the range to be chased
		head_sprite.play("active")
		is_player_in_range = true
		if _is_head_on_body():
			chase_timer.start()


func _on_PlayerDetectionArea2D_body_exited(body):
	if body.is_in_group(Constants.GROUP_PLAYER):
		# The player has exitted the attack range so stop chasing
		is_player_in_range = false
		chase_timer.stop()
		if _is_head_on_body():
			head_sprite.play("idle")

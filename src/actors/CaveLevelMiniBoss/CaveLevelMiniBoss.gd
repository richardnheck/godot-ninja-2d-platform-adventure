#------------------
# CaveLevelMiniBoss
#------------------
extends KinematicBody2D


# Exports
export var gravity = 7
export var jump_power = 200

export(int) var vertical_direction = 1

onready var jump_timer = $JumpTimer
onready var pause_timer = $PauseTimer
onready var main_sprite = $SpriteMain

var velocity = Vector2(40,0)

var vertical_speed = 200

# Jump state settings
var do_jump = false
var landing = false

# Up down state settings
var paused = false

enum State { 
	UP_DOWN = 0,
	JUMP = 1
}

enum Dir {
	UP = -1,
	DOWN = 1
}

export(State) var current_state = State.JUMP

var state_changed = false


var player:KinematicBody2D = null
var ground_global_position:Vector2 = Vector2.ZERO

var MiniBossSlamBlastScene = preload("res://src/actors/CaveLevelMiniBoss/MiniBossSlamBlast.tscn")

var slam_sound:AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Mini Boss Ready")
	slam_sound =  Game_AudioManager.sfx_env_cave_mini_boss_slam.duplicate()
	add_child(slam_sound)
	
	ground_global_position = global_position
		
	if current_state == State.JUMP:
		do_jump = true
		jump_timer.start()


func set_state(state):
	current_state = state


func set_player(player_ref):
	player = player_ref;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		State.UP_DOWN:
			if not paused:
				if vertical_direction == 1:
					# Moving down
					vertical_speed = 250
				else:
					# Moving up
					vertical_speed = 100
				var vely = vertical_speed * vertical_direction
				
				velocity.x = 0
				velocity.y = vely
				velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
		
		
				if is_on_ceiling() or is_on_floor():
					paused = true
					pause_timer.start()
					vertical_direction = vertical_direction * -1;
					if is_on_floor():
						_on_land()
				
		
		State.JUMP:
			if do_jump:
				velocity.y = -jump_power
				jump_timer.start()
				do_jump = false
				landing = true	
			
			velocity.x = 0
			
			velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
			velocity.y += gravity
			
			if is_on_floor():
				if landing:
					_on_land()
					landing = false

func _on_land():
	slam_sound.play()
	_flash_sprite()
	_shake_screen()
	_spawn_slam_blast()
	
	
func _shake_screen() -> void:
	var screen_shake_node = get_parent().get_node("ScreenShake")
	if screen_shake_node:
		screen_shake_node.screen_shake(0.5,2,100)		


func _spawn_slam_blast() -> void:
	# Rightwards blast
	var instance = MiniBossSlamBlastScene.instance() 
	instance.scale = Vector2(0.5,0.5)
	instance.global_position = global_position + Vector2(0,-1)
	(instance as MiniBossSlamBlast).set_direction(1)  # rightwards
	get_parent().add_child(instance)		
	
	# Leftwards blast
	var instance2 = MiniBossSlamBlastScene.instance()
	instance2.scale = Vector2(0.5,0.5)
	instance2.global_position = global_position + Vector2(-32,-1)
	get_parent().add_child(instance2)		
	(instance2 as MiniBossSlamBlast).set_direction(-1) # leftwards
	
func _flash_sprite():
	main_sprite.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	main_sprite.show()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()


func _on_JumpTimer_timeout() -> void:
	do_jump = true


func _on_PauseTimer_timeout() -> void:
	paused = false

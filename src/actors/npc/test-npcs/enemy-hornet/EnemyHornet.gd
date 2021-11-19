extends Area2D
signal enemy_killed
var direction = Vector2()
var screensize 
var follow = false
var distance
var speed = 0
var swarm = false
var enemySpeedMin = 50
var enemySpeedMax = 75
var enemyTimerMin = 5
var enemyTimerMax = 25

onready var player:Player = null
onready var sprite = $AnimatedSprite
onready var enemy_timer = $EnemyTimer

# Distance from player when it starts following
var distance_threshold = 50

func _ready():
	# Initiate Randomization
	randomize()
	# Init variables
	# get Screensize 
	
	# set speed between Min & Max values
	speed = rand_range(enemySpeedMin ,enemySpeedMax)
	# init AI variables 
	follow = false
	swarm = 0
	
	# set Enemy live time between Min & Max values
	enemy_timer.wait_time = (rand_range(enemyTimerMin ,enemyTimerMax))
	# Start Enemy Life Timer
	enemy_timer.start()
	

func _process(delta):  
	if not is_instance_valid(player):
		_find_player() 
		return
	update()
	screensize = get_viewport_rect().size
	# AI rules
	# get direction / distance of player
	direction = player.position - self.position
	# Determine whether to flip enemy image to face player
	if direction.x > 0:
		# Set Enemy facing right
		sprite.flip_h = false
	else:
		# Set Enemy facing left
		sprite.flip_h = true
	# calculate distance from player
	distance = sqrt(direction.x * direction.x + direction.y * direction.y)
	print(distance) # uncomment this to see distance from player
	# If distance less than 200 then start Enemy following player
	if distance < distance_threshold:
		follow = true
	else:
		follow = false
	# Move Enemy towards player if follow is true or swarm is true
	if follow == true or swarm > 300:   
		# increment swarm while enemy following
		swarm += 1
		#print(swarm) # uncomment this to check swarm 
		position += direction.normalized() * speed * delta
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0 , screensize.y)

# Find the player in the scene based on its group
func _find_player() -> void:
	player = get_tree().get_nodes_in_group("player")[0]


func _on_effect_tween_completed( object, key ):
	# remove enemy from memory after Tween finishes (enemy shrinks when killed)
	queue_free()
	
	
func _on_enemytimer_timeout():
	# if enemy time to live runs out activate Tween (enemy shrinks)
	if not $effect.is_active():
		$effect.start()
		
		
func _on_VisibilityNotifier2D_screen_exited():
	# if enemy goes outside of screen (shouldn't happen) then remove from memory
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		body.die()
		
		# limit collision to single time
		call_deferred("set_monitoring", false)
		
		# emit a signal when enemy killed
		emit_signal("enemy_killed")

func _draw():
	# Draw the distance threshold
	_draw_empty_circle(Vector2(0,0), Vector2(distance_threshold, 0), Color("#FFFFFF"), 1)
	
# ------------------------------------------------------------------------------
# Draw an empty circle to the screen
# Used for drawing in the editor only
# ------------------------------------------------------------------------------
func _draw_empty_circle(circle_center:Vector2, circle_fireball_spacing:Vector2, color:Color, resolution:int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_fireball_spacing + circle_center

	while draw_counter <= 360:
		line_end = circle_fireball_spacing.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_fireball_spacing.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)

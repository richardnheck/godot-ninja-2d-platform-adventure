tool
extends StaticBody2D

export var speed = 70

export var length = 1	# length in tiles

onready var sprite:Sprite = $Sprite
onready var collision_shape:CollisionShape2D = $CollisionShape2D
onready var area_collision_shape:CollisionShape2D = $Area2D/CollisionShape2D

const TILE_SIZE:int = 16 

func _ready():
	#collision_shape.position.x = (TILE_SIZE/2*(length-1))
	var total_length_pixels = TILE_SIZE * length
	var extents = total_length_pixels / 2.0  # the collision rectangles "half extents"
	collision_shape.shape.extents.x = extents
	area_collision_shape.shape.extents.x = extents
	
	# To make placement of conveyor belt easier ensure length extends from the origin
	# as opposed to be centered
	collision_shape.position.x = extents
	area_collision_shape.position.x = extents
	
	sprite.texture.region = Rect2(0, 0, length * TILE_SIZE, TILE_SIZE)
	constant_linear_velocity.x = speed

func _process(delta):
	if sprite:
		sprite.texture.region.position.x -= speed * delta


func _on_Area2D_body_entered(body: Node2D) -> void:
	pass


func _on_Area2D_body_exited(body: Node2D) -> void:
	if body.is_in_group(Constants.GROUP_PLAYER):
		if body.has_method("reset_applied_velocity"):
			body.reset_applied_velocity();

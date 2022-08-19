extends StaticBody2D

export var speed = 50
export var length = 1	# length in tiles

onready var sprite:Sprite = $Sprite
onready var collision_shape:CollisionShape2D = $CollisionShape2D
onready var area_collision_shape:CollisionShape2D = $Area2D/CollisionShape2D

const TILE_SIZE:int = 16 

func _ready():
	#collision_shape.position.x = (TILE_SIZE/2*(length-1)) 
	collision_shape.shape.extents.x = TILE_SIZE / 2 * length
	area_collision_shape.shape.extents.x = TILE_SIZE / 2 * length
	
	sprite.texture.region = Rect2(0, 0, length * TILE_SIZE, TILE_SIZE)
	constant_linear_velocity.x = speed

func _process(delta):
	sprite.texture.region.position.x -= speed * delta


func _on_Area2D_body_entered(body: Node2D) -> void:
	constant_linear_velocity.x = speed


func _on_Area2D_body_exited(body: Node2D) -> void:
	constant_linear_velocity.x = 0

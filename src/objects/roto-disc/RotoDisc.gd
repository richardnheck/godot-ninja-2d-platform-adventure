tool
extends Node2D

##
## A node that spins an object
##
const object_scene = "res://src/objects/roto-disc/Disc.tscn"	
const Once = preload("res://src/utility/Once.gd")				# Utility for trigger once behaviour

# Configurable Properties
# ------------------------------------------------------------------------
# Start direction of flames in degrees
# 0 degrees is right
# Postive angles rotate clockwise
export(int, -180, 180, 45) var start_direction:int = 0 setget _set_start_direction

# The spin speed of rotation (degrees per second)
export(int, -180, 180, 45) var spin_speed:int = 90 setget _set_spin_speed

# The number of object chains that can spin
export(int, 1, 4) var chains:int = 1 setget _set_chains

# Sets whether the rotation is animated in the editor or not
export var animate_in_editor:bool = true setget _set_animate_in_editor

# Sets whether the guides drawn in editor or shown in the game
# The guides are normally shown in the editor and not in the game
# Set this to true if you want to see them in the game
export var show_editor_guides:bool = false setget _set_show_editor_guides
# ------------------------------------------------------------------------

# Additional Configuration
# ------------------------------------------------------------------------
# The size of the object in pixels
var object_size = 16

# This is the radius of the circle that the object is spinning
var radius = 50   

# The rotation pivot node
# The objects are programatically added to this node
onready var pivot := $Pivot

# Represents the actual rotation in degrees that the pivot is rotated
# Positive rotation results in clockwise rotation
var actual_rotation_degrees = 0

# The time that has passed
var time_passed:float = 0.0

#
# Colors for drawing
# 
const COLOR_WHITE = Color("#FFFFFF")
const COLOR_ORANGE = Color("#FF7700")
const COLOR_BLUE = Color("#0000FF")

# ------------------------------------------------------------------------------
# Set the speed of the spin
# Only relevant when in SPIN mode
# ------------------------------------------------------------------------------
func _set_spin_speed(value) -> void:
	spin_speed = value
	_reset_spin()
	
	
# ------------------------------------------------------------------------------	
# Set the start direction of the objects
# ------------------------------------------------------------------------------
func _set_start_direction(value) -> void:
	start_direction = value
	_reset_spin()

# ------------------------------------------------------------------------------
# Set the number of chains
# ------------------------------------------------------------------------------
func _set_chains(value) -> void:
	chains = value
	update()
	
# ------------------------------------------------------------------------------
# Set whether rotation is animated in editor or not
# ------------------------------------------------------------------------------
func _set_animate_in_editor(value) -> void:
	animate_in_editor = value
	_reset_spin()

# ------------------------------------------------------------------------------
# Set whether editor guides are shown in game or not
# ------------------------------------------------------------------------------
func _set_show_editor_guides(value) -> void:
	show_editor_guides = value
		
# ------------------------------------------------------------------------------
# Reset the spin so it starts with the newly configured values
# ------------------------------------------------------------------------------
func _reset_spin() -> void:
	actual_rotation_degrees = 0
	update()

# ------------------------------------------------------------------------------	
# Reset so current settings can be freshly applied
# ------------------------------------------------------------------------------
func reset() -> void:
	_reset_spin()
	_init_objects()


# ------------------------------------------------------------------------------	
# Initialise the objects
# ------------------------------------------------------------------------------
func _init_objects() -> void:
	# Remove current objects
	for n in pivot.get_children():
		pivot.remove_child(n)
		n.queue_free()
		
	# Add objects
	for c in range(0, chains):
		var angle = c * (360 / chains)
		_add_object(angle)
	
# ------------------------------------------------------------------------------
# The ready function for initialisation
# ------------------------------------------------------------------------------
func _ready() -> void:
	if Engine.editor_hint:	
		return
	reset()
	
# ------------------------------------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
# ------------------------------------------------------------------------------
func _process(delta: float) -> void: 
	time_passed += delta
	_process_spin(delta)

# ------------------------------------------------------------------------------
# Process spinning the objects
# ------------------------------------------------------------------------------
func _process_spin(delta: float) -> void:
	actual_rotation_degrees += spin_speed * delta
	if not Engine.editor_hint:
		# Rotate the actual flames in the game
		pivot.rotation_degrees = start_direction + actual_rotation_degrees
	
	update()
	
# ------------------------------------------------------------------------------
# Get the name of the object group
# ------------------------------------------------------------------------------
func _get_object_group()-> String:
	return "object" + String(self.get_instance_id())
	

# ------------------------------------------------------------------------------
# Add a real object node to the pivot node
# @param start_angle	The starting angle of the chain
# ------------------------------------------------------------------------------
func _add_object(start_angle) -> void:
	var object:Disc = load(object_scene).instance()
	object.add_to_group(_get_object_group())
	object.position = Vector2(radius, 0).rotated(deg2rad(start_angle))
	object.show_object(true)
	
	# Add the object to the pivot
	pivot.add_child(object)		


# ------------------------------------------------------------------------------
# Draw to the screen in the editor
# ------------------------------------------------------------------------------
func _draw():
	if not Engine.editor_hint:
		if not show_editor_guides:
			return
		
	# Draw the objects
	for c in range(0, chains):
		var angle = c * (360 / chains)
		_draw_object(start_direction + angle)
		
	# Draw the circle showing the path of the object
	_draw_empty_circle(Vector2(), Vector2(0, radius), COLOR_WHITE, 1)
	
	# Draw the circle indicating speed of rotation
	if animate_in_editor:
		draw_circle(Vector2(radius, 0).rotated(deg2rad(start_direction + actual_rotation_degrees)), 3, COLOR_WHITE)


# ------------------------------------------------------------------------------	
# Draw the object (represented by a circle) to the screen
# @param start_angle	The start angle (degrees) of the object chain
# ------------------------------------------------------------------------------
func _draw_object(start_angle:float) -> void:
	var _draw_object = true
			
	if _draw_object:
		_draw_empty_circle(Vector2(radius, 0).rotated(deg2rad(start_angle)), Vector2(object_size/2,0), COLOR_ORANGE, 1)


# ------------------------------------------------------------------------------
# Draw an empty circle to the screen
# ------------------------------------------------------------------------------
func _draw_empty_circle(circle_center:Vector2, circle_object_spacing:Vector2, color:Color, resolution:int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_object_spacing + circle_center

	while draw_counter <= 360:
		line_end = circle_object_spacing.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_object_spacing.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)

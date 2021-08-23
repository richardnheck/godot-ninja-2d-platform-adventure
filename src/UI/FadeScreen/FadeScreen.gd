extends Node2D
class_name FadeScreen

signal changing_scene
signal fading_in_finished
signal fading_out_finished
signal fading_started


#Child nodes
onready var fade_player = $CanvasLayer/Control/FadePlayer
onready var rect = $CanvasLayer/Control/BlackRectBottom
onready var loading_indicator = $CanvasLayer/Control/LoadingIndicator

var scene_to_go : String
var is_reload_scene_call = false

func _ready() -> void:
	# Hide the loading indicator message by default
	loading_indicator.visible = false
	
	# rect is hidden in scene so it doesn't block the view of other scenes
	# in the editor.  Since it is hidden, make it visible when loaded
	rect.visible = true
	

func go_to_scene(var target : String, show_loading_message = false):
	if show_loading_message:
		loading_indicator.visible = true
		
	scene_to_go = target
	fade_player.play("Fade Out")
	
	# pausing on causes delay in when setting camera limits in level
	#get_tree().paused = true
	
	print('Preloading scene: ' + target)
	
	emit_signal("changing_scene")

func reload_scene():
	fade_player.play("Fade Out")
	
	# pausing on causes delay in when setting camera limits in level
	#get_tree().paused = true
	
	is_reload_scene_call = true #To let fader know we're reloading scene
	print('Reloading scene: ' + str(get_tree().current_scene.get_path()))
	
	emit_signal("changing_scene")

func fade_in_current_scene():
	fade_player.play("Fade In")
	

func _on_AnimationPlayer_animation_finished(anim_name : String):
	if anim_name == "Fade Out":
		#Choose between go_to_scene or reloading current
		if is_reload_scene_call:
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene(scene_to_go)
			
		emit_signal("fading_out_finished")
	if anim_name == "Fade In":
		get_tree().paused = false
		emit_signal("fading_in_finished")
	
	

func _on_AnimationPlayer_animation_started(anim_name : String):
	if anim_name == "Fade In":
		pass
		# pausing on causes delay in when setting camera limits in level
		#get_tree().paused = true
	
	emit_signal("fading_started")

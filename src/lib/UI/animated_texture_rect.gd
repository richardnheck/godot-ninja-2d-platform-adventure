tool
extends TextureRect

class_name AnimatedTextureRect

export (SpriteFrames) var sprite_frames setget set_sprite_frames, get_sprite_frames
export (String) var animation = "default"
export (int) var current_frame_index = 0
export (float, 0.5, 90.0) var frames_per_second = 2.0 setget set_fps, get_fps
export (bool) var play_on_ready = true

var da_timer = null
var is_playing = false
var _is_playing_editor = false
var _is_allowed_to_play_in_editor = true


func _ready():
	if not Engine.editor_hint:
		_is_allowed_to_play_in_editor = false
		_is_playing_editor = false
		if play_on_ready:
			play()


# --- Getters / Setters ---

func get_sprite_frames():
	return sprite_frames

func set_sprite_frames(val):
	sprite_frames = val
	_set_texture()

func get_fps():
	return frames_per_second

func set_fps(val):
	frames_per_second = val
	if not da_timer:
		_timer_setup()
	_set_timer_wait_time()


# --- Public Controls ---

func play():
	_kill_timer()
	_set_texture()
	is_playing = true
	
	if not da_timer:
		_timer_setup()
	
	_set_timer_wait_time()
	da_timer.start()


func stop():
	_kill_timer()
	is_playing = false


func editor_play_toggle():
	if _is_playing_editor:
		_is_playing_editor = false
		_kill_timer()
		return
	
	_set_texture()
	_is_playing_editor = true
	
	if not da_timer:
		_timer_setup()
	
	_set_timer_wait_time()
	da_timer.start()


# --- Animation Logic ---

func _play_next_frame():
	if _is_not_allowed_to_run():
		_kill_timer()
		return
	
	var anim_name = _get_real_animation_name()
	current_frame_index += 1
	
	if current_frame_index >= sprite_frames.get_frame_count(anim_name):
		current_frame_index = 0
	
	_set_texture()


func _get_real_animation_name():
	if sprite_frames.get_animation_names().has(animation):
		return animation
	else:
		return sprite_frames.get_animation_names()[0]


func _set_texture():
	if not sprite_frames:
		return
	
	var anim_name = _get_real_animation_name()
	
	if current_frame_index >= sprite_frames.get_frame_count(anim_name):
		current_frame_index = 0
	
	texture = sprite_frames.get_frame(anim_name, current_frame_index)


# --- Timer Handling ---

func _timer_setup():
	da_timer = Timer.new()
	add_child(da_timer)
	da_timer.autostart = false
	da_timer.connect("timeout", self, "_on_frame_end_timeout")


func _set_timer_wait_time():
	if da_timer:
		da_timer.wait_time = 1.0 / frames_per_second


func _is_not_allowed_to_run():
	return not is_playing and (
		not _is_allowed_to_play_in_editor or
		not _is_playing_editor
	)


func _kill_timer():
	if da_timer:
		da_timer.stop()
		da_timer.queue_free()
		da_timer = null


func _on_frame_end_timeout():
	if _is_not_allowed_to_run():
		_kill_timer()
		return
	
	_play_next_frame()

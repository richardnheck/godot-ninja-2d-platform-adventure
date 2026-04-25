extends HSlider

func _ready():
	_init_volume()

func _on_SoundFxVolumeSlider_value_changed(value):
	var db_volume = linear2db(value)
	Game_AudioManager.set_sound_fx_volume(db_volume)

func _on_SoundFxVolumeSlider_visibility_changed(visible):
	if visible:
		_init_volume()

func _init_volume():
	value = db2linear(Game_AudioManager.get_sound_fx_volume())

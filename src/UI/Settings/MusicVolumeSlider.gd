extends HSlider

func _ready():
	_init_volume()

func _init_volume():
	value = db2linear(Game_AudioManager.get_music_volume())

func _on_MusicVolumeSlider_value_changed(value):
	var db_volume = linear2db(value)
	Game_AudioManager.set_music_volume(db_volume)

func _on_MusicVolumeSlider_visibility_changed(value):
		if visible:
			_init_volume()


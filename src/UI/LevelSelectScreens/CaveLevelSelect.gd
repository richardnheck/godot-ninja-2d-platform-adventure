extends CanvasLayer


onready var buttonContainer = $Control/LevelButtonsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levelsCount = LevelData.get_levels().size()
	levelsCount = levelsCount - 1;	 # Don't use boss scene
	for levelIndex in range(0, levelsCount):
		var button = Button.new()
		button.text = str(levelIndex + 1)
		button.connect("button_up", self, "_level_button_pressed", [levelIndex])
		#button.set_size(Vector2(40,18));  #doesn't work
		buttonContainer.add_child(button)
		
	
func _level_button_pressed(levelIndex):
	LevelData.goto_level(levelIndex)


func _on_BossButton_button_up() -> void:
	LevelData.goto_boss_level()


func _on_IntroButton_button_up() -> void:
	get_tree().change_scene("res://src/UI/StoryIntroScreen/StoryIntro.tscn")

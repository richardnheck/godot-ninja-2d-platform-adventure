extends CanvasLayer


onready var buttonContainer = $Control/LevelButtonsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levelsCount = LevelData.get_levels().size()
	for levelIndex in range(0, levelsCount):
		var button = Button.new()
		button.text = str(levelIndex + 1)
		button.connect("button_up", self, "_level_button_pressed", [levelIndex])
		buttonContainer.add_child(button)
	
func _level_button_pressed(levelIndex):
	LevelData.goto_level(levelIndex)

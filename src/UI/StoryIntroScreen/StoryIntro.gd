extends CanvasLayer

signal continue_sig

# Declare member variables here. Examples:
var continue_flag: bool = false

enum State { 
	START_WALK_IN = 0,
	WALKING_IN = 1,
	START_WALK_OUT = 2,
	WALKING_OUT = 3,
	JUMP = 4,
	JUMPING = 5
}
	
var state: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/DialogBox1.hide()
	$Control/DialogBox2.hide()
	$AnimatedSprite.play("walk")
	state = State.START_WALK_IN
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.START_WALK_IN:
		$AnimationPlayer.play("walk-in")
		state = State.WALKING_IN

	if state == State.START_WALK_OUT:
		$AnimationPlayer.play("walk-out")
		state = State.WALKING_OUT	

	if state == State.JUMP:
		$AnimationPlayer.play("jump")
		state = State.JUMPING
				
	# Wait until player walks to centre	
	yield($AnimationPlayer, "animation_finished")
	
	# Player is in centre
	$AnimatedSprite.play("idle")
	yield(get_tree().create_timer(0.5), "timeout")
	
	# Start talking
	$Control/DialogBox1.show()
	yield(self, "continue_sig")
	$Control/DialogBox1.hide()
	$Control/DialogBox2.show()
	
	# Wait for using input to finish talking
	yield(self, "continue_sig")
	
	# Start walk out to hole
	$AnimatedSprite.play("walk")
	state = State.START_WALK_OUT
	yield($AnimationPlayer, "animation_finished")
	
	# At hole, pause then jump
	yield(get_tree().create_timer(0.5), "timeout")
	state = State.JUMP
	yield($AnimationPlayer, "animation_finished")
	

func continue() -> void:
	emit_signal("continue_sig")

func jump_up() -> void:
	$AnimatedSprite.play("jump-up")

func jump_down() -> void:
	$AnimatedSprite.play("jump-down")


func _on_SkipButton_button_up() -> void:
	get_tree().change_scene("res://src/levels/CaveLevels/CaveLevelLearningMechanics.tscn")


func _on_ClickRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			self.continue()


func _on_ContinueButton_button_up() -> void:
	self.continue()


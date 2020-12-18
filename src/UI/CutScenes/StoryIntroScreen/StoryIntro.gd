extends CanvasLayer

signal continue_sig

# Declare member variables here. Examples:
var continue_flag: bool = false

enum State { 
	START_WALK_IN = 0,   
	DOING_WALK_IN = 1,
	START_DIALOG1 = 2,
	DOING_DIALOG1 = 3,
	START_DIALOG2 = 4,
	DOING_DIALOG2 = 5,
	START_WALK_OUT = 6,
	DOING_WALK_OUT = 7,
	START_JUMP = 8,
	DOING_JUMP = 9,
	
}
	
var state: int

var step: int = 0

onready var cut_scene_base = $CutSceneBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/DialogBox1.hide()
	$Control/DialogBox2.hide()
	$AnimatedSprite.play("walk")
	state = State.START_WALK_IN
	
	cut_scene_base.show_continue(false)
	cut_scene_base.connect("on_continue", self, "continue")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.START_WALK_IN:
			$AnimationPlayer.play("walk-in")
			state = State.DOING_WALK_IN
	
		State.DOING_WALK_IN:
			# Wait until player walks to centre	
			yield($AnimationPlayer, "animation_finished")
			$AnimatedSprite.play("idle")
			state = State.START_DIALOG1
			
		State.START_DIALOG1:
			$Control/DialogBox1.show()
			cut_scene_base.show_continue(true)
			state = State.DOING_DIALOG1

		State.DOING_DIALOG1:
			yield(self, "continue_sig")
			$Control/DialogBox1.hide()		# Hide first dialog
			cut_scene_base.show_continue(false)
			state = State.START_DIALOG2
		
		State.START_DIALOG2:
			yield(get_tree().create_timer(0.3), "timeout")  # Wait a bit before shoing next dialog
			$Control/DialogBox2.show()
			cut_scene_base.show_continue(true)
			state = State.DOING_DIALOG2
	
		State.DOING_DIALOG2:
			yield(self, "continue_sig")
			$Control/DialogBox2.hide()
			cut_scene_base.show_continue(false)
			state = State.START_WALK_OUT
		
		State.START_WALK_OUT:
			$AnimatedSprite.play("walk")
			$AnimationPlayer.play("walk-out")
			state = State.DOING_WALK_OUT
	
		State.DOING_WALK_OUT:
			# Wait for walk out animation to finish
			yield($AnimationPlayer, "animation_finished")
			
			# Pause at hole a bit then jump
			$AnimatedSprite.play("idle")
			yield(get_tree().create_timer(0.8 ), "timeout")
			state = State.START_JUMP
		
		State.START_JUMP:
			$AnimationPlayer.play("jump")
			state = State.DOING_JUMP
	

func continue() -> void:
	emit_signal("continue_sig")

func jump_up() -> void:
	$AnimatedSprite.play("jump-up")

func jump_down() -> void:
	$AnimatedSprite.play("jump-down")

func goto_next_scene()->void:
	cut_scene_base.goto_next_scene()

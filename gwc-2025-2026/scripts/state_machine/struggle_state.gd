extends NodeState
class_name StruggleState

@export var struggle_key := "struggle"

@export var max_progress := 100.0
@export var press_gain := 3      # 每次按键获得
@export var decay_rate := 25.0      # 每秒下降

var progress := 20.0
var medical_pod: MedicalPod

func _on_enter():
	progress = 20.0
	print("Enter Struggle")
	var bar = get_tree().get_first_node_in_group("struggle_ui")
	if bar:
		bar.struggle_state = self
		bar.visible = true


func _on_physics_process(delta):

	progress -= decay_rate * delta

	if Input.is_action_pressed("struggle"):
		progress += press_gain

	progress = clamp(progress, 0.0, max_progress)

	print("Struggle progress:", int(progress))

func _on_next_transitions():
	if progress >= max_progress:
		transition.emit("idle")

func _on_exit():
	var bar = get_tree().get_first_node_in_group("struggle_ui")
	if bar:
		bar.visible = false
	print("Exit Struggle State")
	GameInputEvent.input_enabled = true

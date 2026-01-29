extends NodeState
class_name PodLockedState

@export var player: Player
@export var ai_warning_delay := 2.0  

var _timer: Timer

func _on_enter():
	print("Enter PodLocked: medical scan started")

	_timer = Timer.new()
	_timer.wait_time = ai_warning_delay
	_timer.one_shot = true
	_timer.timeout.connect(_on_sedative_started)
	add_child(_timer)
	_timer.start()
	GameInputEvent.input_enabled = false

func _on_sedative_started():
	print("Medical AI: unauthorized neural activity detected")
	print("Medical AI: initiating memory wipe protocol")

	transition.emit("struggle")

func _on_exit():
	if is_instance_valid(_timer):
		_timer.stop()
		_timer.queue_free()
	print("Exit PodLocked")

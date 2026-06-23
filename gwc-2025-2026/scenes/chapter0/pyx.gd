extends CharacterBody2D

signal arrived_at_lead_target

@export var max_speed := 120.0
@export var accel := 70.0
@export var stop_radius := 20.0

var player: CharacterBody2D
var hover_offset := Vector2.ZERO

var _lead_target: Vector2
var _is_leading := false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	randomize()
	hover_offset = Vector2(randf_range(-8, 8), randf_range(-4, 4))

## Tells Pyx to walk to a fixed position (e.g. the wrench) instead of
## chasing the player. She automatically resumes following once she arrives.
func lead_to(target_position: Vector2) -> void:
	_lead_target = target_position
	_is_leading = true

func _physics_process(delta):
	var target: Vector2
	if _is_leading:
		target = _lead_target
	elif player:
		target = player.global_position
	else:
		return

	var to_target := target - global_position
	var distance := to_target.length()

	if distance > stop_radius:
		var desired_velocity := to_target.normalized() * max_speed
		velocity = velocity.move_toward(desired_velocity, accel * delta)
		#velocity = desired_velocity
	else:
		velocity = velocity.move_toward(Vector2.ZERO, accel * delta)
		if _is_leading:
			_is_leading = false
			arrived_at_lead_target.emit()
	move_and_slide()

func _process(_delta):
	hover_offset.y = sin(Time.get_ticks_msec()) * 100

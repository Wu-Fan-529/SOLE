class_name GameInputEvent

static var direction: Vector2 = Vector2.ZERO
static var input_enabled := true

static func movement_input() -> Vector2:
	if not input_enabled:
		direction = Vector2.ZERO
		return direction

	if Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	else:
		direction = Vector2.ZERO
		
	return direction

static func is_movement_input() -> bool:
	return direction != Vector2.ZERO

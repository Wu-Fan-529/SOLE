extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction = GameInputEvent.movement_input()
	
	if direction == Vector2.UP or direction == Vector2.LEFT or direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_up")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_down")
		
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * speed
	player.move_and_slide()
	
	if direction != Vector2.ZERO:
		player.last_move_dir = direction


func _on_next_transitions() -> void:
	if !GameInputEvent.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()

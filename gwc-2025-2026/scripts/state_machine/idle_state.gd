extends NodeState

@export var player: Player
@export var animated_sprite_2D: AnimatedSprite2D

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	animated_sprite_2D.play("idle")

func _on_next_transitions() -> void:
	GameInputEvent.movement_input()
	
	if GameInputEvent.is_movement_input():
		transition.emit("Walk")

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2D.stop()

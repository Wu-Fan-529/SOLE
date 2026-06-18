extends Node2D
## Patrol + idle float NPC for the corridor. No detection in Ch0.

@export var npc_id := "nurse"
@export var is_human := false
@export var patrol_points: Array[Vector2] = []
@export var patrol_speed := 24.0

var _index := 0

func _ready() -> void:
	UITween.float_loop(self, 2.0, 3.0)

func _physics_process(delta: float) -> void:
	if patrol_points.is_empty():
		return
	var target: Vector2 = patrol_points[_index]
	var dir: Vector2 = target - global_position
	if dir.length() < 2.0:
		_index = (_index + 1) % patrol_points.size()
	else:
		global_position += dir.normalized() * patrol_speed * delta

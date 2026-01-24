extends CharacterBody2D

@export var max_speed := 120.0
@export var accel := 70.0
@export var stop_radius := 20.0  # ⭐ 靠近目标就别追了

var player: CharacterBody2D
var hover_offset := Vector2.ZERO

func _ready():
	player = get_tree().get_first_node_in_group("player")
	randomize()
	hover_offset = Vector2(randf_range(-8, 8), randf_range(-4, 4))
	
func _physics_process(delta):
	if not player:
		return

	# --- 2️⃣ 计算稳定目标点 ---
	var target := player.global_position

	var to_target := target - global_position
	var distance := to_target.length()

	if distance > stop_radius:
		var desired_velocity := to_target.normalized() * max_speed
		velocity = velocity.move_toward(desired_velocity, accel * delta)
		#velocity = desired_velocity
	else:
		velocity = velocity.move_toward(Vector2.ZERO, accel * delta)
	move_and_slide()

func _process(_delta):
	# ⭐ 轻微、低频的悬停
	hover_offset.y = sin(Time.get_ticks_msec()) * 100

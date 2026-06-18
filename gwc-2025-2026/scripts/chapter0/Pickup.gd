extends Area2D
## Generic item pickup. Press interact near it to collect.

@export var item_id := "wrench"
@export var item_name := "Wrench"

var player_nearby := false
@onready var prompt: Label = get_tree().get_first_node_in_group("interaction_prompt")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		_collect()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		if prompt:
			prompt.text = "Press [E] to pick up %s" % item_name
			prompt.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		if prompt:
			prompt.visible = false

func _collect() -> void:
	var scene_root := get_tree().current_scene
	if scene_root.has_method("on_item_picked_up"):
		scene_root.on_item_picked_up(item_id)
	if prompt:
		prompt.visible = false
	queue_free()

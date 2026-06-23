extends Node2D
## Scene 0-2: 2D gameplay begins. Pyx intro, Pyx leads to the wrench, pickup, exit.
## Pyx intro plays through Dialogic ("ch0_pyx_intro") as soon as the scene starts.

const NEXT_SCENE := "res://scenes/chapter0/HospitalCorridor.tscn"

@onready var pyx: CharacterBody2D = $Pyx
@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var exit_trigger: Area2D = $ExitTrigger
@onready var wrench: Area2D = $Pickups/Wrench

var pyx_intro_done := false

func _ready() -> void:
	GameInputEvent.input_enabled = false
	exit_trigger.body_entered.connect(_on_exit_entered)
	UITween.fade_in(pyx, 0.5)
	Dialogic.start("ch0_pyx_intro")
	Dialogic.timeline_ended.connect(_on_pyx_intro_done, CONNECT_ONE_SHOT)

func _on_pyx_intro_done() -> void:
	GameInputEvent.input_enabled = true
	# After "Follow me," Pyx walks ahead to the wrench; the player still has
	# to walk up and press [E] to actually collect it (Pickup.gd).
	if is_instance_valid(wrench):
		pyx.lead_to(wrench.global_position)

func on_item_picked_up(item_id: String) -> void:
	inventory_panel.add_item(item_id)

func _on_exit_entered(body: Node2D) -> void:
	if pyx_intro_done or not body.is_in_group("player"):
		return
	pyx_intro_done = true
	GameInputEvent.input_enabled = false
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file(NEXT_SCENE)

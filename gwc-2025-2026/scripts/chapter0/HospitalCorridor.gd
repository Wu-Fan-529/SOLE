extends Node2D
## Scene 0-3: stealth movement + first human/AI verification.
## Uses the autoloaded IDV_VerificationManager singleton.
## Dialogic drives: nurse observation lines + Pyx's verification feedback.

const NEXT_SCENE := "res://scenes/chapter0/MedicalRoom_2D.tscn"  # loops back for demo

@onready var overlay: Control = $UI/VerificationOverlay
@onready var verif_trigger: Area2D = $VerificationSystem/VerificationTrigger
@onready var crouch_indicator: Label = $UI/CrouchIndicator
@onready var player: CharacterBody2D = $Player

var verification_done := false
var is_crouching := false
var observed := false

func _ready() -> void:
	GameInputEvent.input_enabled = true
	_register_profiles()
	verif_trigger.body_entered.connect(_on_trigger_entered)
	overlay.get_node("ButtonContainer/ChooseNurseA").pressed.connect(
		func(): _on_choice("nurse_a"))
	overlay.get_node("ButtonContainer/ChooseNurseB").pressed.connect(
		func(): _on_choice("nurse_b"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = not is_crouching
		crouch_indicator.visible = is_crouching

func _register_profiles() -> void:
	var a := VerificationProfile.new()
	a.emotional_variance = 0.05
	a.pattern_deviation = 0.02
	a.contextual_memory = 0.10
	IDV_VerificationManager.register_entity("nurse_a", a)

	var b := VerificationProfile.new()
	b.emotional_variance = 0.80
	b.pattern_deviation = 0.65
	b.contextual_memory = 0.90
	IDV_VerificationManager.register_entity("nurse_b", b)

func _on_trigger_entered(body: Node2D) -> void:
	if verification_done or not body.is_in_group("player"):
		return
	GameInputEvent.input_enabled = false
	# First play both nurses' observation lines, then open the judgment UI.
	if not observed:
		observed = true
		_play_observation()
	else:
		overlay.show_animated()

func _play_observation() -> void:
	Dialogic.start("ch0_nurse_a")
	# Chain nurse_b after nurse_a, then show the overlay.
	Dialogic.timeline_ended.connect(_after_nurse_a, CONNECT_ONE_SHOT)

func _after_nurse_a() -> void:
	Dialogic.start("ch0_nurse_b")
	Dialogic.timeline_ended.connect(_after_nurse_b, CONNECT_ONE_SHOT)

func _after_nurse_b() -> void:
	overlay.show_animated()

func _on_choice(chosen_id: String) -> void:
	if verification_done:
		return
	verification_done = true
	var correct := chosen_id == "nurse_b"
	var profile: VerificationProfile = IDV_VerificationManager.get_profile(chosen_id)
	print("[Verification] %s | human_likelihood=%.2f | correct=%s"
		% [chosen_id, profile.human_likelihood(), correct])
	overlay.show_result(
		"Correct - human detected." if correct else "Incorrect - entity misidentified.",
		correct)
	await get_tree().create_timer(1.5).timeout
	await overlay.hide_animated().finished
	# Pyx reacts via Dialogic, then transition.
	Dialogic.start("ch0_verification_correct" if correct else "ch0_verification_wrong")
	Dialogic.timeline_ended.connect(_go_next, CONNECT_ONE_SHOT)

func _go_next() -> void:
	get_tree().change_scene_to_file(NEXT_SCENE)

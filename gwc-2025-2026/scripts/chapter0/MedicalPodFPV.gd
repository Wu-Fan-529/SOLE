extends Node3D
## Scene 0-1: First-person pod. Camera locked. QTE struggle only.
## Flow: awaken -> struggle (hold F) -> pod opens -> transition to 0-2.

const NEXT_SCENE := "res://scenes/chapter0/MedicalRoom_2D.tscn"

const HUD_LINES := [
	"[color=#00ff88]Neural activity: CONFIRMED[/color]",
	"Identity match: [color=#ff4444]FAILED[/color]",
	"Initiating memory erasure...",
	"[color=#ffaa00]WARNING: anomalous resistance[/color]",
]

@export var max_progress := 100.0
@export var press_gain := 2.5
@export var decay_rate := 30.0

@onready var hud_text: RichTextLabel = $HUD/HUDText
@onready var struggle_bar: ProgressBar = $HUD/StruggleBar
@onready var breathing: AudioStreamPlayer = $Audio/Breathing

var progress := 20.0
var struggling := false
var done := false

func _ready() -> void:
	GameInputEvent.input_enabled = false
	hud_text.text = ""
	for line: String in HUD_LINES:
		hud_text.text += line + "\n"
	if breathing.stream:
		breathing.play()
	struggle_bar.max_value = max_progress
	struggle_bar.visible = true
	# Begin struggle after a short beat.
	await get_tree().create_timer(1.2).timeout
	struggling = true

func _physics_process(delta: float) -> void:
	if not struggling or done:
		return
	progress -= decay_rate * delta
	if Input.is_action_pressed("struggle"):
		progress += press_gain
	progress = clampf(progress, 0.0, max_progress)
	struggle_bar.value = progress
	if progress >= max_progress:
		_on_struggle_complete()

func _on_struggle_complete() -> void:
	done = true
	struggling = false
	struggle_bar.visible = false
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(NEXT_SCENE)

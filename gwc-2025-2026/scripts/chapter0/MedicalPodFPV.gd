extends Node3D
## Scene 0-1: First-person pod. Camera locked. QTE struggle only.
## Flow: awaken -> struggle (hold F) -> Pyx breaks the glass and pulls the player out -> transition to 0-2.

const NEXT_SCENE := "res://scenes/chapter0/MedicalRoom_2D.tscn"
const RESCUE_TIMELINE := "ch0_pod_rescue"

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
@onready var hint: Label = $HUD/Hint
@onready var breathing: AudioStreamPlayer = $Audio/Breathing
@onready var breathing_rig: Node3D = $BreathingRig
@onready var pod_glass: MeshInstance3D = $PodGlass

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
	hint.visible = false
	await _rescue_sequence()

## Pyx breaks the pod glass and pulls the player free, then we cut to 0-2.
func _rescue_sequence() -> void:
	await get_tree().create_timer(0.3).timeout
	_shake_camera()
	_shatter_glass()
	await get_tree().create_timer(0.5).timeout

	Dialogic.start(RESCUE_TIMELINE)
	Dialogic.timeline_ended.connect(_on_rescue_dialogue_done, CONNECT_ONE_SHOT)

func _on_rescue_dialogue_done() -> void:
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file(NEXT_SCENE)

func _shake_camera() -> void:
	if not breathing_rig:
		return
	var origin: Vector3 = breathing_rig.position
	var tween: Tween = create_tween()
	for i in range(6):
		var offset := Vector3(randf_range(-0.04, 0.04), randf_range(-0.04, 0.04), 0.0)
		tween.tween_property(breathing_rig, "position", origin + offset, 0.04)
	tween.tween_property(breathing_rig, "position", origin, 0.04)

func _shatter_glass() -> void:
	if not pod_glass:
		return
	var glass_mat: StandardMaterial3D = pod_glass.get_surface_override_material(0)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(pod_glass, "scale", pod_glass.scale * 1.4, 0.5)\
		.set_ease(Tween.EASE_OUT)
	if glass_mat:
		tween.tween_property(glass_mat, "albedo_color:a", 0.0, 0.5)
	tween.chain().tween_callback(func(): pod_glass.visible = false)

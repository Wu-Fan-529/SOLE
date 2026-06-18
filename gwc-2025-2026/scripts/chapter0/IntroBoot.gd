extends Node2D
## Scene 0-0: System cold-boot. Non-interactive. Transitions to 0-1.

const NEXT_SCENE := "res://scenes/chapter0/MedicalPod_FPV.tscn"

const BOOT_LINES := [
	"[color=#00ff88]SOLE MEDICAL SYSTEM v9.3.1[/color]",
	"Neural signature detected.",
	"Identity verification... [color=#ff4444]FAILED[/color]",
	"Fallback protocol engaged.",
	"Memory erasure sequence initializing...",
]
const LINE_PAUSE := 0.6
const CHARS_PER_SECOND := 22.0

@onready var system_text: RichTextLabel = $CanvasLayer/SystemText

func _ready() -> void:
	system_text.text = ""
	system_text.visible_characters = 0
	system_text.modulate.a = 0.0
	UITween.fade_in(system_text, 0.4)
	await get_tree().create_timer(0.5).timeout
	_play_boot_sequence()

func _play_boot_sequence() -> void:
	for line: String in BOOT_LINES:
		system_text.text += line + "\n"
		var from: int = system_text.visible_characters
		var to: int = system_text.get_total_character_count()
		var new_chars: int = to - from
		if new_chars <= 0:
			continue
		var duration: float = new_chars / CHARS_PER_SECOND
		var tween: Tween = system_text.create_tween()
		tween.tween_property(system_text, "visible_characters", to, duration)
		await tween.finished
		await get_tree().create_timer(LINE_PAUSE).timeout
	await UITween.fade_out(system_text, 0.5).finished
	get_tree().change_scene_to_file(NEXT_SCENE)

extends Control
## UI controller for the verification judgment panel.

@onready var prompt_label: RichTextLabel = $PromptLabel
@onready var result_label: Label = $ResultLabel
@onready var btn_a: Button = $ButtonContainer/ChooseNurseA
@onready var btn_b: Button = $ButtonContainer/ChooseNurseB
@onready var btn_container: HBoxContainer = $ButtonContainer

func _ready() -> void:
	btn_a.pressed.connect(_lock_buttons)
	btn_b.pressed.connect(_lock_buttons)
	modulate.a = 0.0
	visible = false
	result_label.visible = false

func show_animated() -> void:
	visible = true
	UITween.fade_in(self, 0.3)
	await get_tree().create_timer(0.15).timeout
	UITween.slide_in(btn_container, Vector2(0, 20), 0.3)
	UITween.typewriter(prompt_label, 30.0)

func show_result(text: String, correct: bool) -> void:
	result_label.text = text
	result_label.modulate = Color(0.4, 1, 0.5) if correct else Color(1, 0.4, 0.4)
	UITween.pop_in(result_label, 0.3)

func hide_animated() -> Tween:
	return UITween.fade_out(self, 0.25)

func _lock_buttons() -> void:
	btn_a.disabled = true
	btn_b.disabled = true

extends TextureProgressBar

var struggle_state: StruggleState

func _ready():
	visible = false

func _process(_delta):
	if struggle_state:
		value = struggle_state.progress

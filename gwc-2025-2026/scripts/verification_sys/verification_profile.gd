extends Resource
class_name VerificationProfile

@export var emotional_variance := 0.0
@export var pattern_deviation := 0.0
@export var contextual_memory := 0.0

func human_likelihood() -> float:
	return clamp(
		emotional_variance * 0.4 +
		pattern_deviation * 0.4 +
		contextual_memory * 0.2,
		0.0, 1.0
	)

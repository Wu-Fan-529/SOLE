extends Node
class_name VerificationManager

var profiles := {}

func register_entity(id: String, profile: VerificationProfile):
	profiles[id] = profile

func get_profile(id: String):
	return profiles.get(id)

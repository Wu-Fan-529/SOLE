class_name Player
extends CharacterBody2D

var player_direction: Vector2
var last_move_dir := Vector2.RIGHT
func _ready():
	print("PLAYER READY:", self)
	add_to_group("player")

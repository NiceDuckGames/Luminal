extends Area2D

@export var max_player_size: float

signal player_entered(max_size)
signal player_exited


func _ready() -> void:
	self.connect("player_entered", get_tree().current_scene._on_no_grow_zone_player_entered)
	self.connect("player_exited", get_tree().current_scene._on_no_grow_zone_player_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		emit_signal("player_entered", max_player_size - 1)


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		emit_signal("player_exited")

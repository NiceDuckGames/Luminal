extends Area2D


signal finished


func _ready() -> void:
	
	self.connect("finished", get_tree().current_scene._on_finish_finished)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		emit_signal("finished")

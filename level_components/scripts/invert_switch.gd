extends Area2D


@export var level: Node2D


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		level.invert_level()
		$AudioStreamPlayer2D.play(0.075)
		$CollisionShape2D.set_deferred("disabled", true)
		self.hide()


func _on_audio_stream_player_2d_finished() -> void:
	self.queue_free()

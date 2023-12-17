extends Area2D


signal pressed


@export var play_sound: bool = true


func enable():
	
	if play_sound:
		$AudioStreamPlayer2D.play(0.075)
	$AudioStreamPlayer2D.pitch_scale = 1.0
	$CollisionShape2D.set_deferred("disabled", false)
	self.show()


func disable():
	
	if play_sound:
		$AudioStreamPlayer2D.play(0.075)
	$AudioStreamPlayer2D.pitch_scale = 1.1
	$CollisionShape2D.set_deferred("disabled", true)
	self.hide()


func _on_body_entered(body: Node2D) -> void:
	
	emit_signal("pressed")
	
	disable()

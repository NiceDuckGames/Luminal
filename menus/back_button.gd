extends Button


func _on_mouse_entered() -> void:
	$PointLight2D.visible = true


func _on_mouse_exited() -> void:
	$PointLight2D.visible = false


func _on_button_down() -> void:
	$PointLight2D.visible = false


func _on_focus_entered() -> void:
	$PointLight2D.visible = true


func _on_focus_exited() -> void:
	$PointLight2D.visible = false

extends Node2D


signal light_turned_off


func get_lights() -> Array[Node]:
	return get_children()


func _on_light_switch_pressed() -> void:
	emit_signal("light_turned_off")

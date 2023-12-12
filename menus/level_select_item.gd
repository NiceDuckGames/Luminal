extends PanelContainer

var level_file_path: String = ""
var level_name: String = ""


func set_completed():
	
	$MarginContainer/Label["theme_override_colors/font_color"] = Color.BLACK
	$MarginContainer/Button["theme_override_colors/font_color"] = Color.BLACK


func set_level_name(l_name: String):
	level_name = l_name
	$MarginContainer/Label.text = l_name
	$MarginContainer/Button.text = l_name


func _on_button_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()
	get_node(level_name).visible = true
#	$LightOccluder2D.visible = true


func _on_button_mouse_exited() -> void:
	get_node(level_name).visible = false
#	$LightOccluder2D.visible = false


func _on_button_pressed() -> void:
	var level = load(level_file_path)
	print(level)
	get_tree().change_scene_to_packed(level)

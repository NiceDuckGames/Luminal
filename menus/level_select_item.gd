extends PanelContainer


@export var challenge_color: Color = Color.RED

var level_file_path: String = ""
var level_name: String = ""


func _ready() -> void:
	
	if int(level_name) % 5 == 0:
		$PointLight2D.color = challenge_color


func set_completed():
	
	$MarginContainer/Label["theme_override_colors/font_color"] = Color.BLACK
	$MarginContainer/Button["theme_override_colors/font_color"] = Color.BLACK


func set_level_name(l_name: String):
	level_name = l_name
	$MarginContainer/Label.text = l_name
	$MarginContainer/Button.text = l_name
	
	get_node(level_name).visible = true


func _on_button_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()
	$PointLight2D.visible = true
	get_node(level_name).visible = false


func _on_button_mouse_exited() -> void:
	$PointLight2D.visible = false
	get_node(level_name).visible = true


func _on_button_pressed() -> void:
	var level = load(level_file_path)
	get_tree().change_scene_to_packed(level)


func _on_focus_entered() -> void:
	$AudioStreamPlayer2D.play()
	$PointLight2D.visible = true
	get_node(level_name).visible = false


func _on_focus_exited() -> void:
	$PointLight2D.visible = false
	get_node(level_name).visible = true


func _input(event: InputEvent) -> void:
	
	if event.is_action("ui_accept") && self.has_focus():
		var level = load(level_file_path)
		get_tree().change_scene_to_packed(level)

extends MarginContainer



func _ready() -> void:
	$Control/BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	$AnimationPlayer.play("go_back")


func return_to_main_screen():
	var main_screen: PackedScene = load("res://menus/main_menu.tscn")
	get_tree().change_scene_to_packed(main_screen)


func _on_jam_info_button_pressed() -> void:
	
	$JamInfo.visible = !$JamInfo.visible
	$VBoxContainer.visible = !$VBoxContainer.visible
	$AudioStreamPlayer.play(0.075)

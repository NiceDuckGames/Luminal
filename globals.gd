extends Node


var is_startup: bool = true
var previous_scene: String = ""
var current_scene: String = ""



func set_current_scene(scene_name: String):
	
	previous_scene = current_scene
	current_scene = scene_name

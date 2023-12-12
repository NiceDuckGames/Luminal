extends Node


var completed: Dictionary = {}


func is_set_up() -> bool:
	
	return !completed.is_empty()


func setup_levels(level_names: PackedStringArray):
	
	for l_name in level_names:
		
		completed[l_name] = false


func complete_level(level_name: String):
	
	if !completed.has(level_name): return
	
	completed[level_name] = true


func is_level_completed(level_name):
	if !completed.has(level_name): return
	return completed[level_name]

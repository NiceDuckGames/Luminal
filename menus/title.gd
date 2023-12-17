extends VBoxContainer

@export var light_off_color: Color
@export var light_on_color: Color

@onready var scene_light: Light2D = $Title/PointLight2D
@onready var menu_container: HBoxContainer = $HBoxContainer
@onready var credits_button: Button = $"../Credits"


func _ready() -> void:
	
	$Title["theme_override_colors/font_color"] = light_off_color

func _on_point_light_2d_visibility_changed() -> void:
	
	if !is_node_ready(): return
	
	var light_on: bool = scene_light.visible
	
	if light_on:
		$Title["theme_override_colors/font_color"] = light_on_color
		
	else:
		$Title["theme_override_colors/font_color"] = light_off_color
	
	menu_container.visible = true


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		
		if credits_button.has_focus():
			self.grab_focus()
		
		for button in menu_container.get_children():
			if button.has_focus():
				self.grab_focus()

extends ColorRect


@export var dark_color: Color = Color.WHITE
@export var light_color: Color = Color("2c2c2c")


func set_dark(is_dark: bool):
	
	if is_dark:
		color = dark_color
	else:
		color = light_color

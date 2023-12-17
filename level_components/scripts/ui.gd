extends CanvasLayer

@onready var game_end_label: Label = $Label

func game_over():
	game_end_label.text = "Game Over"
	game_end_label.show()


func game_finished():
	pass
#	game_end_label.text = "You Won"
#	game_end_label.show()


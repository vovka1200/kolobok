extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

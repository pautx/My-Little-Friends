extends CanvasLayer

signal exercise_button_pressed(satiation: float, happiness: float, health: float)

func _on_light_button_pressed() -> void:
	exercise_button_pressed.emit(-5, 5, 10)

func _on_moderate_button_pressed() -> void:
	exercise_button_pressed.emit(-15, 10, 20)

func _on_vigorous_button_pressed() -> void:
	exercise_button_pressed.emit(-15, -5, 30)

func _on_maximum_button_pressed() -> void:
	exercise_button_pressed.emit(-25, -15, 50)

func _on_exit_button_pressed() -> void:
	hide()
	$SFX.play()

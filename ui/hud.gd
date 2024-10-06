extends CanvasLayer

signal trashcan_hovered(toggle: bool)

func set_money(money: int) -> void:
	%MoneyLabel.text = "%s" % str(money).pad_zeros(5)

func set_satiation(satiation: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%SatiationBar, "value", satiation, 0.4)

func set_happiness(happiness: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%HappinessBar, "value", happiness, 0.4)

func set_health(health: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%HealthBar, "value", health, 0.4)

func _on_trashcan_mouse_entered() -> void:
	trashcan_hovered.emit(true)
	%Trashcan.texture = load("res://ui/trash_hover.png")

func _on_trashcan_mouse_exited() -> void:
	trashcan_hovered.emit(false)
	%Trashcan.texture = load("res://ui/trash.png")

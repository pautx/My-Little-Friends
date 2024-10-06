extends StaticBody2D

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	$SFX.play()
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(1.8).timeout
	queue_free()

func _process(delta: float) -> void:
	move_and_collide(Vector2.DOWN * 2.5)

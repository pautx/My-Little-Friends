extends StaticBody2D

signal node_grabbed(toggle: bool)

var is_grabbable: bool
var is_grabbed: bool

func _ready() -> void:
	$SFX.play()

func _process(delta: float) -> void:
	if Input.is_action_pressed("pickup") and is_grabbed:
		position = get_global_mouse_position().clamp(Vector2(-315, -180), Vector2(315, 142))
		
	move_and_collide(Vector2.DOWN * 2)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup") and is_grabbable:
		is_grabbed = true
		$SFX.set_stream(load("res://pickup.wav"))
		$SFX.play()
		node_grabbed.emit(true)
	
	if event.is_action_released("pickup") and is_grabbed:
		is_grabbed = false
		$SFX.set_stream(load("res://drop.wav"))
		$SFX.play()
		#node_grabbed.emit(false)
		

func _on_mouse_entered() -> void:
	is_grabbable = true

func _on_mouse_exited() -> void:
	is_grabbable = false

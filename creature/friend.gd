extends CharacterBody2D

enum Direction {
	LEFT,
	RIGHT
}

enum State {
	IDLE,
	MOVE,
	SLEEP
}

signal satiation_changed(satiation: float)
signal happiness_changed(happiness: float)
signal health_changed(health: float)
signal pooped()

var speed: float

var direction = Direction.LEFT
var state = State.IDLE

func _ready() -> void:
	speed = randf_range(50.0, 120.0)

func _process(delta: float) -> void:
	var vector := Vector2.ZERO
	
	if $LeftBoundCheck.is_colliding():
		direction = Direction.RIGHT
	
	if $RightBoundCheck.is_colliding():
		direction = Direction.LEFT
	
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("blink")
		State.MOVE:
			match direction:
				Direction.LEFT:
					vector.x = -1
					$AnimatedSprite2D.flip_h = true
				Direction.RIGHT:
					vector.x = 1
					$AnimatedSprite2D.flip_h = false
		State.SLEEP:
			$AnimatedSprite2D.play("sleep")
			$AnimatedSprite2D.flip_h = false
					
	velocity = vector * speed + get_gravity()
	move_and_slide()

func _on_state_timer_timeout() -> void:
	state = State.IDLE
	await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	if state == State.SLEEP:
		$StateTimer.start()
	else:
		direction = randi() % Direction.size()
		state = randi() % 2
		$StateTimer.wait_time = randf_range(1.0, 5.0)
		$StateTimer.start()

func _on_poop_timer_timeout() -> void:
	pooped.emit()
	$PoopTimer.wait_time = randf_range(30.0, 120.0)
	$PoopTimer.start()

func _on_sleep_timer_timeout() -> void:
	$StateTimer.paused = true
	$PoopTimer.paused = true
	state = State.SLEEP
	await get_tree().create_timer(randf_range(30.0, 60.0)).timeout
	$StateTimer.paused = false
	$PoopTimer.paused = false
	state = State.IDLE
	$SleepTimer.wait_time = randf_range(90.0, 180.0)
	$SleepTimer.start()


func _on_emotion_timer_timeout() -> void:
	pass # Replace with function body.

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
var satiation: float
var happiness: float
var health: float
var direction = Direction.LEFT
var state = State.IDLE
var is_grabbable: bool
var is_grabbed: bool

func _ready() -> void:
	$Voice.pitch_scale = randf_range(0.8, 1.2)
	speed = randf_range(50.0, 150.0)
	satiation = randf_range(10.0, 30.0)
	happiness = randf_range(25.0, 60.0)
	health = randf_range(10.0, 80.0)

func _process(delta: float) -> void:
	var vector := Vector2.ZERO
	
	if Input.is_action_pressed("pickup") and is_grabbed:
		position = get_global_mouse_position().clamp(Vector2(-315, -180), Vector2(315, 142))
	
	if state != State.SLEEP:
		satiation -= 0.50 * delta
		happiness -= 0.25 * delta
		satiation_changed.emit(satiation)
		happiness_changed.emit(happiness)
	
	if satiation < 0:
		satiation = 0
		health -= 0.60 * delta
	
	if happiness < 0:
		happiness = 0
		health -= 0.30 * delta
	
	health_changed.emit(health)
	
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup") and is_grabbable:
		if state != State.SLEEP:
			happiness += randi() % 8
			happiness_changed.emit(happiness)
		is_grabbed = true
		$SFX.set_stream(load("res://pickup.wav"))
		$SFX.play()
	
	if event.is_action_released("pickup") and is_grabbed:
		is_grabbed = false
		$SFX.set_stream(load("res://drop.wav"))
		$SFX.play()

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
	if state != State.SLEEP:
		if satiation > 50 and happiness > 70 and health > 50:
			$Emotion.texture = load("res://creature/happy.png")
			$Voice.set_stream(load("res://creature/happy.wav"))
		elif satiation < 10 or happiness < 20 or health < 10:
			$Emotion.texture = load("res://creature/sad.png")
			$Voice.set_stream(load("res://creature/sad.wav"))
		
		$Voice.play()
		await get_tree().create_timer(3.0).timeout
		$Emotion.texture = null

func _on_mouse_entered() -> void:
	is_grabbable = true

func _on_mouse_exited() -> void:
	is_grabbable = false

extends Node2D

var money: int = 50
var current_grabbed_node: Node2D
var is_hovering_trashcan: bool

func _ready() -> void:
	await get_tree().create_timer(2.8).timeout
	$HUD.set_health($Creature.health)
	$HUD.show()
	$Creature.show()

func _input(event: InputEvent) -> void:
	if event.is_action_released("pickup") and is_hovering_trashcan and current_grabbed_node:
		$Creature.happiness += 5
		$HUD.set_happiness($Creature.happiness)
		current_grabbed_node.queue_free()
		current_grabbed_node = null

func _on_creature_happiness_changed(happiness: float) -> void:
	$HUD.set_happiness(happiness)

func _on_creature_health_changed(health: float) -> void:
	$HUD.set_health(health)

func _on_creature_satiation_changed(satiation: float) -> void:
	$HUD.set_satiation(satiation)

func _on_feed_button_pressed() -> void:
	if $FoodMenu.is_visible():
		$FoodMenu.hide()
	else:
		$FoodMenu.show()
		$ExerciseMenu.hide()
	$SFX.play()

func _on_exercise_button_pressed() -> void:
	if $ExerciseMenu.is_visible():
		$ExerciseMenu.hide()
	else:
		$ExerciseMenu.show()
		$FoodMenu.hide()
	$SFX.play()

func _on_work_button_pressed() -> void:
	money += 5
	$HUD.set_money(money)
	$GPUParticles2D.position = get_local_mouse_position()
	$GPUParticles2D.position.y -= 20
	$GPUParticles2D.restart()
	$Cash.pitch_scale = randf_range(1.0, 1.6)
	$Cash.play()

func _on_food_menu_food_item_pressed(price: int, satiation: float, happiness: float, health: float) -> void:
	if money >= price:
		money -= price
		$Creature.satiation += satiation
		if $Creature.satiation > 100:
			$Creature.satiation = 100
		
		$Creature.happiness += happiness
		if $Creature.happiness > 100:
			$Creature.happiness = 100
		
		$Creature.health += health
		if $Creature.health > 100:
			$Creature.health = 100
		
		if $Creature.health < 0:
			$Creature.health = 0
		
		$HUD.set_money(money)
		$HUD.set_satiation($Creature.satiation)
		$HUD.set_happiness($Creature.happiness)
		$HUD.set_health($Creature.health)
		$SFX.play()

func _on_exercise_menu_exercise_button_pressed(satiation: float, happiness: float, health: float) -> void:
	if $Creature.satiation - 5 > abs(satiation):
		$Creature.satiation += satiation
		$Creature.happiness += happiness
		$Creature.health += health
		$Creature.satiation += satiation
		
		if $Creature.satiation > 100:
			$Creature.satiation = 100
		
		$Creature.happiness += happiness
		if $Creature.happiness > 100:
			$Creature.happiness = 100
		
		$Creature.health += health
		if $Creature.health > 100:
			$Creature.health = 100
		
		$HUD.set_satiation($Creature.satiation)
		$HUD.set_happiness($Creature.happiness)
		$HUD.set_health($Creature.health)
		$SFX.play()

func _on_creature_pooped() -> void:
	var poop = load("res://poop/poop.tscn").instantiate()
	poop.position = $Creature.position
	poop.node_grabbed.connect(
		func(toggle: bool):
			if toggle:
				current_grabbed_node = poop
			else:
				current_grabbed_node = null
	)
	$Poops.add_child(poop)

func _on_hud_trashcan_hovered(toggle: bool) -> void:
	is_hovering_trashcan = toggle

func _on_new_friend_timer_timeout() -> void:
	var egg = load("res://egg/egg.tscn").instantiate()
	var friend = load("res://creature/friend.tscn").instantiate()
	var rand_x = randi_range(-300, 300)
	egg.position.x = rand_x
	$Friends.add_child(egg)
	await get_tree().create_timer(2.75).timeout
	friend.position = egg.position
	$Friends.add_child(friend)
	$NewFriendTimer.wait_time = randf_range(30.0, 90.0)
	$NewFriendTimer.start()

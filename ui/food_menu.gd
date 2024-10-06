extends CanvasLayer

const PELLET_PRICE = 5
const BREAD_PRICE = 12
const APPLE_PRICE = 20
const BURGER_PRICE = 50
const CANDY_PRICE = 15
const COOKIE_PRICE = 25
const CAKE_PRICE = 100

signal food_item_pressed(price: int, satiation: float, happiness: float, health: float)

func _ready() -> void:
	%PelletButton.text = "Pellet\n$%d" % PELLET_PRICE
	%BreadButton.text = "Bread\n$%d" % BREAD_PRICE
	%AppleButton.text = "Apple\n$%d" % APPLE_PRICE
	%BurgerButton.text = "Burger\n$%d" % BURGER_PRICE
	%CandyButton.text = "Candy\n$%d" % CANDY_PRICE
	%CookieButton.text = "Cookie\n$%d" % COOKIE_PRICE
	%CakeButton.text = "Cake\n$%d" % CAKE_PRICE

func _on_pellet_button_pressed() -> void:
	food_item_pressed.emit(PELLET_PRICE, 2, -1, 0)
	
func _on_bread_button_pressed() -> void:
	food_item_pressed.emit(BREAD_PRICE, 5, -1, 0)

func _on_apple_button_pressed() -> void:
	food_item_pressed.emit(APPLE_PRICE, 5, 1, 5)

func _on_burger_button_pressed() -> void:
	food_item_pressed.emit(BURGER_PRICE, 50, 0, -15)

func _on_candy_button_pressed() -> void:
	food_item_pressed.emit(CANDY_PRICE, 5, 10, -5)

func _on_cookie_button_pressed() -> void:
	food_item_pressed.emit(COOKIE_PRICE, 10, 15, -15)

func _on_cake_button_pressed() -> void:
	food_item_pressed.emit(CAKE_PRICE, 40, 30, -20)

func _on_exit_button_pressed() -> void:
	hide()
	$SFX.play()

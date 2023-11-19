extends Sprite2D

var highlighted = false
@onready var normal_texture = preload("res://sprites/order-background.png")
@onready var highlight_texture = preload("res://sprites/order-background-highlight.png")

var my_order = {}
var delivered_foods = []
var raging = false

func _process(delta: float) -> void:
	texture = highlight_texture if highlighted else normal_texture
	if raging:
		$Emoticon.offset = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1),
		)
	else:
		$Emoticon.offset = Vector2.ZERO

func update_graphics():
	$Food.texture = Game.FOOD_TYPES[my_order.food_type]["texture"]
	var count = my_order.count
	for food in delivered_foods:
		print(food + " " + my_order.food_type)
		if food == my_order.food_type:
			count -= 1
	
	if count > 1:
		$Food.visible = true				
		$Food/Label.visible = true
		$Food/Label.text = str(count)
		$Check.visible = false				
	elif count == 1:
		$Food.visible = true		
		$Food/Label.visible = false
		$Check.visible = false		
	else:
		$Food.visible = false
		$Food/Label.visible = false
		$Check.visible = true		

func set_delivered(foods):
	print("Deliv: " + str(foods))
	delivered_foods = foods
	update_graphics()

func set_order(order):
	my_order = order
	update_graphics()

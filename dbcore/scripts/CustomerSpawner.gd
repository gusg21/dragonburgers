extends Node2D

var spawn_timer = 5.0
var customer_scene = preload("res://scenes/CustomerDragon.tscn")
@onready var world_node = get_parent()
@onready var counter_positions = [
	$CounterPos1, $CounterPos2, $CounterPos3
]


func spawn_customer(order):
	if Game.has_open_spot():
		var customer = customer_scene.instantiate()
		world_node.add_child(customer)
		customer.set_order(order)
		customer.position = position
		var index = Game.get_open_spot()
		Game.CUSTOMER_POSITIONS[index] = true
		customer.customer_position_index = index
		customer.target_position = counter_positions[index].global_position
		spawn_timer = randf_range(5.0, 10.0)
		Game.SOUNDZ.play_sound("door_open")

func _process(delta):
	if Game.is_mode_pausey(): return
	
	if Game.MODE == "waiting": return
	
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		var max = 1
		if Game.WAVE_NUMBER >= 2:
			max = 2
		if Game.WAVE_NUMBER >= 4:
			max = 4
		if Game.WAVE_NUMBER >= 6:
			max = 5
			
		var foods = ["burger", "burger", "burger", "patty"]
		if Game.WAVE_NUMBER >= 2:
			foods.append_array(["fries", "fries", "fries", "burned_patty"])
		if Game.WAVE_NUMBER >= 3:
			foods.append_array(["bread", "burger", "burned_patty"])
		if Game.WAVE_NUMBER >= 4:
			foods.append_array(["burned_patty", "burned_patty"])
		
		var food = foods.pick_random()
		
		if food == "burned_patty": max = 1
		
		var order = {
			food_type = food,
			count = randi_range(1, max)
		}
		spawn_customer(order)

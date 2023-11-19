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

func _process(delta):
	if Game.is_mode_pausey(): return
	
	if Game.MODE == "waiting": return
	
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		var order = {
			food_type = Game.FOOD_TYPES.keys().pick_random(),
			count = randi_range(1, 2)
		}
		spawn_customer(order)

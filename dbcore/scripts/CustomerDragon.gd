extends CharacterBody2D

var WALK_SPEED = 50.0
var CHANCE_TO_EAT_IN = 0.3
@onready var ANIMATION_SETS = [
	preload("res://frames/bluedragon.tres"),
	preload("res://frames/pinkdragon.tres"),
	preload("res://frames/reddragon.tres"),
	preload("res://frames/vomitdragon.tres"),
]

var my_order
var happiness = 1.0
var customer_position_index
var holding_spot = true
var marked_as_not_alive = false
var _target_position
var target_position: Vector2:
	set(pos):
		_target_position = pos
		$NavigationAgent2D.target_position = pos
var order_filled: bool = false
var mouse_over: bool = false
var delivered_foods = []
var leaving = false
var hotfix_timer = 10
var eat_timer = 10

func _ready() -> void: 
	$Character.sprite_frames = ANIMATION_SETS.pick_random()
	
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func set_order(order):
	print("Got order " + str(order))
	my_order = order
	$OrderUI.set_order(order)

func _process(delta):
	if Game.is_mode_pausey(): return
	
	$OrderUI.highlighted = interactable()
	$OrderUI.raging = happiness < 0.15
	
	if !order_filled:
		var seconds_to_sad = Game.SECONDS_TO_SAD - (Game.WAVE_NUMBER * 4)
		happiness -= delta / seconds_to_sad
		happiness = clamp(happiness, 0.0, 1.0) # life
		$OrderUI/Emoticon.set_happiness(happiness)
		if happiness <= 0:
			exit_building()
	elif order_filled and not leaving:
		eat_timer -= delta
		if eat_timer <= 0:
			target_position = Game.DOOR_POSITION
			leaving = true
			
	if leaving:
		hotfix_timer -= delta
		if hotfix_timer <= 0:
			exit_building()
		
#		print(global_position.distance_to(target_position))
		if global_position.distance_to(target_position) < 90: # unsure why this needs to be so high :/
			exit_building()
			
	var speed_norm = velocity.length() / WALK_SPEED
#	print(speed_norm)
	if speed_norm > 0.5:
		$Character.play("walk")
		$Character.speed_scale = speed_norm
	else:
		$Character.play("idle")		
		$Character.speed_scale = 1
	
	if abs(velocity.x) > 5:
		if velocity.x > 0:
			$Character.flip_h = true
		else:
			$Character.flip_h = false
	
	if $NavigationAgent2D.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.limit_length()
	new_velocity = new_velocity * WALK_SPEED

	velocity = new_velocity
	move_and_slide()
	
func _enter_tree() -> void:
	Game.ALIVE_CUSTOMERS += 1
	
func _exit_tree() -> void:
	if not marked_as_not_alive:
		Game.ALIVE_CUSTOMERS -= 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_finish_order"):
		if global_position.distance_to(get_global_mouse_position()) < 20:
			finish_order()

func get_rating_change():
	if order_filled:
		if happiness > 0.66:
			return +0.4
		elif happiness > 0.3:
			return +0.25
		else:
			return +0.0
	else:
		return -0.4

func exit_building():
	var rating_delta = get_rating_change() * (1 + (Game.WAVE_NUMBER / 10.0))
	Game.RATING += rating_delta
	
	if holding_spot:
		Game.CUSTOMER_POSITIONS[customer_position_index] = false
		holding_spot = false
	
	var pop = Game.NUMBER_POP_SCENE.instantiate()
	get_parent().add_child(pop)
	pop.global_position = global_position + Vector2(0, -32)
	var positive = rating_delta >= 0
	pop.set_text(("+" if positive else "") + ("%.2f" % rating_delta))
	pop.set_color(Color.GREEN_YELLOW if positive else Color.ORANGE_RED)
	queue_free()

func finish_order():
	Game.CUSTOMERS_SERVED += 1
	Game.SOUNDZ.play_sound("fanfare")
	
	Game.ALIVE_CUSTOMERS -= 1
	marked_as_not_alive = true
	order_filled = true
	Game.CUSTOMER_POSITIONS[customer_position_index] = false
	holding_spot = false
	if randf() < CHANCE_TO_EAT_IN:
		target_position = Game.EAT_IN_SPOTS.pick_random()
		eat_timer = randf_range(10, 20)
	else:
		exit_building()

func check_if_satisfied():
	var count = my_order.count
	for food in delivered_foods:
		print(food + " " + my_order.food_type)
		if food == my_order.food_type:
			count -= 1
	
	return count == 0

func interactable():
	return mouse_over and Game.PLAYER.get_held_food_type() == my_order.food_type

func interact():
	if Game.PLAYER.has_ingredient():
		var ingredient = Game.PLAYER.take_ingredient()
		delivered_foods.append(ingredient.get_type())
		ingredient.queue_free()
		$OrderUI.set_delivered(delivered_foods)
		
		if check_if_satisfied():
			finish_order()
		else:
			happiness += 0.3
			happiness = clamp(happiness, 0, 1)

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if interactable():
			interact()
			get_viewport().set_input_as_handled()

func _mouse_enter() -> void:
	print(Game.PLAYER.get_held_food_type())
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

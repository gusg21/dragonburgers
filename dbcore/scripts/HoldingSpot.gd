extends Sprite2D

var mouse_over = false
var held_ingredient = null
@onready var normal_texture = preload("res://sprites/holdingspot.png")
@onready var highlight_texture = preload("res://sprites/holdingspot-highlight.png")

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func _process(delta: float) -> void:
	texture = highlight_texture if can_interact() else normal_texture
	modulate.a = 1 if is_accessible() and Game.PLAYER.has_ingredient() else 0.5

func is_accessible():
	return mouse_over and Game.PLAYER.global_position.distance_to($Area2D.global_position) < 80.0

func can_interact():
	var accessible = is_accessible()
	if held_ingredient == null:
		return accessible \
				and Game.PLAYER.has_ingredient()
	else:
		if held_ingredient.get_type() == "bread" and Game.PLAYER.get_held_food_type() == "patty":
			return accessible
		if held_ingredient.get_type() == "patty" and Game.PLAYER.get_held_food_type() == "bread":
			return accessible
			
		return accessible and not Game.PLAYER.has_ingredient()
	
func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func interact():
	if held_ingredient == null:
		held_ingredient = Game.PLAYER.take_ingredient()
		held_ingredient.z_override = true
		held_ingredient.grabbed = false
		held_ingredient.global_position = global_position
		Game.SOUNDZ.play_sound("place")
	else:
		if held_ingredient.get_type() in ["bread", "patty"] and \
			Game.PLAYER.get_held_food_type() in ["patty", "bread"]:
			var ingredient = Game.PLAYER.take_ingredient()
			ingredient.queue_free()
			held_ingredient.set_type("burger")
			Game.SOUNDZ.play_sound("place")
		else:
			Game.PLAYER.grab_ingredient(held_ingredient)
			held_ingredient.z_override = false		
			held_ingredient.grabbed = true
			held_ingredient = null

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_interact():
			interact()

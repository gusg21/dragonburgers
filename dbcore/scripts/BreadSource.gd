extends StaticBody2D

var mouse_over = false
var held_ingredient = null
@onready var normal_texture = preload("res://sprites/bread-container.png")
@onready var highlight_texture = preload("res://sprites/bread-container-highlight.png")

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func _process(delta: float) -> void:
	$Graphics.texture = highlight_texture if can_interact() else normal_texture

func can_interact():
	var accesible = mouse_over and Game.PLAYER.global_position.distance_to($Area2D.global_position) < 80.0
	return accesible \
				and not Game.PLAYER.has_ingredient()
	
func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func interact():
	var ingredient = Game.INGREDIENT_SCENE.instantiate()
	get_parent().add_child(ingredient)
	ingredient.set_type("bread")
	Game.PLAYER.grab_ingredient(ingredient)
	ingredient.grabbed = true

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_interact():
			interact()
			get_viewport().set_input_as_handled()

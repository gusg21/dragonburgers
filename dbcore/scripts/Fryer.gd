extends Node2D

const TIME_TO_DONE = 10

var mouse_over = false
@onready var normal_texture = preload("res://sprites/fryer.png")
@onready var highlight_texture = preload("res://sprites/fryer-highlight.png")
@onready var closed_texture = preload("res://sprites/fryer-down.png")
@onready var closed_highlight_texture = preload("res://sprites/fryer-down-highlight.png")

var down = false
var cook_time = 0

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func can_interact():
	var a = mouse_over and Game.PLAYER.global_position.distance_to(global_position) < 80.0
	if not down:
		return a
	else:
		return cook_time > TIME_TO_DONE and not Game.PLAYER.holding_any()

func _process(delta: float) -> void:
	if Game.is_mode_pausey(): return
	
	$Pointer.visible = (cook_time > TIME_TO_DONE) and down
	
	if not down:
		$Graphics.texture = highlight_texture if can_interact() else normal_texture
	else:
		cook_time += delta
		$Graphics.texture = closed_highlight_texture if can_interact() else closed_texture

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_interact():
			interact()
			
	
func interact():
	Game.SOUNDZ.play_sound("frying")
	Game.SOUNDZ.play_sound("click_button2")
	
	if not down:
		down = true
		cook_time = 0
	else:
		var fries = Game.INGREDIENT_SCENE.instantiate()
		get_parent().add_child(fries)
		fries.set_type("fries")
		fries.grabbed = true
		down = false

extends Node2D

var mouse_over = false
@onready var human_scene = preload("res://scenes/Person.tscn")
@onready var normal_texture = preload("res://sprites/people-container.png")
@onready var highlight_texture = preload("res://sprites/people-container-highlight.png")

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func can_deposit():
	return mouse_over and Game.PLAYER.global_position.distance_to($Area2D.global_position) < 50.0

func _process(delta: float) -> void:
	$Graphics.texture = highlight_texture if can_deposit() else normal_texture

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_deposit():
			deposit()
			get_viewport().set_input_as_handled()
			
func deposit():
	if Game.PLAYER.has_human():
		Game.HUMANS_IN_BOX += 1
		Game.PLAYER.held_human.queue_free()
		Game.PLAYER.drop_human()
	elif Game.HUMANS_IN_BOX > 0:
		Game.HUMANS_IN_BOX -= 1
		var new_human = human_scene.instantiate()
		new_human.grabbed = true
		get_parent().add_child(new_human)
		Game.PLAYER.grab_human(new_human)

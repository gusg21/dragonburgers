extends StaticBody2D

var mouse_over = false
@onready var normal_texture = preload("res://sprites/trashcan.png")
@onready var highlight_texture = preload("res://sprites/trashcan-highlight.png")

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func _process(delta: float) -> void:
	$Sprite2D.texture = highlight_texture if can_interact() else normal_texture

func can_interact():
	var accesible = mouse_over and Game.PLAYER.global_position.distance_to($Area2D.global_position) < 50.0
	return accesible \
			and Game.PLAYER.has_ingredient()

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func interact():
	Game.INGREDIENTS_TRASHED += 1
	
	var i = Game.PLAYER.take_ingredient()
	i.queue_free()

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_interact():
			interact()

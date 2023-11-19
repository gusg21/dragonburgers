extends Node2D

const TIME_TO_DONE = 5
const TIME_TO_BURNED = 15

var mouse_over = false
@onready var human_scene = preload("res://scenes/Person.tscn")
@onready var normal_texture = preload("res://sprites/pattymaker.png")
@onready var highlight_texture = preload("res://sprites/pattymaker-highlight.png")
@onready var closed_texture = preload("res://sprites/pattymaker-closed.png")
@onready var closed_highlight_texture = preload("res://sprites/pattymaker-closed-highlight.png")

var closed = false
var cook_time = 0

func _ready() -> void:
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)

func can_interact():
	if not closed:
		return mouse_over and Game.PLAYER.global_position.distance_to(global_position) < 80.0 \
			and Game.PLAYER.has_human()
	else:
		return cook_time > TIME_TO_DONE and not Game.PLAYER.holding_any()

func _process(delta: float) -> void:
	if Game.is_mode_pausey() or not visible: return
	
	if not closed:
		$Graphics.texture = highlight_texture if can_interact() else normal_texture
		$Indicator.visible = false
		$Burning.visible = false
	else:
		$Indicator.visible = true
		$Indicator.frame = 1 if cook_time > TIME_TO_DONE else 0
		cook_time += delta
		$Graphics.texture = closed_highlight_texture if can_interact() else closed_texture
		$Burning.visible = cook_time > TIME_TO_BURNED

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if can_interact():
			interact()
			
func close():
	closed = true
	cook_time = 0
	Game.SOUNDZ.play_sound("frying")
	Game.SOUNDZ.play_sound("closed")
	
func interact():
	if not visible: return
	
	if not closed:
		Game.PLAYER.held_human.queue_free()
		Game.PLAYER.drop_human()
		close()
	else:
		var patty = Game.INGREDIENT_SCENE.instantiate()
		get_parent().add_child(patty)
		var burned = cook_time > TIME_TO_BURNED
		patty.set_type("patty" if not burned else "burned_patty")
		if burned: Game.PATTIES_BURNED += 1
		patty.grabbed = true
		closed = false

extends StaticBody2D

const TIME_TO_FIX = 5.0
const HIDING_RADIUS = 20

@onready var normal_tex = preload("res://sprites/table.png")
@onready var hover_tex = preload("res://sprites/table-highlight.png")
var knocked_over = false
var fix_time = 0
var knocked_offset = Vector2(-32, -32)
var mouse_over = false

func _ready() -> void:
	Game.HIDING_SPOTS.append(self)
	
	$KnockArea.mouse_entered.connect(_mouse_enter)
	$KnockArea.mouse_exited.connect(_mouse_exit)

func can_knock():
	return Game.PLAYER.global_position.distance_to(global_position) < 100 and \
		mouse_over and not knocked_over

func _process(delta: float) -> void:
	if Game.is_mode_pausey(): return
	
	$Sprite2D.texture = hover_tex if can_knock() else normal_tex
	
	if can_knock() and Input.is_action_just_pressed("click"):
		knock_over()
	
	if knocked_over:
		fix_time -= delta
		
		if fix_time <= 0.0:
			fix_table()
			
func get_hiding_point() -> Vector2:
	return global_position + Vector2(-0, -32) + Vector2(
		randf_range(-HIDING_RADIUS, HIDING_RADIUS), 
		randf_range(-HIDING_RADIUS, HIDING_RADIUS)
		)
		
func is_hidden() -> bool: return not knocked_over

func fix_table():
	position -= Vector2(-32, -32)	
	rotation_degrees = 0
	knocked_over = false
	
func knock_over():
	knocked_over = true
	rotation_degrees = 90
	position += knocked_offset
	fix_time = TIME_TO_FIX
	Game.TABLES_TOPPLED += 1

func _mouse_enter() -> void:
	print("mouse in table")
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

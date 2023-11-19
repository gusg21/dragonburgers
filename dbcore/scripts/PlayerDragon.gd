extends CharacterBody2D

const ACCELERATION = 50.0
const MAX_SPEED = 300.0

var held_human
var held_ingredient

func _ready() -> void:
	Game.PLAYER = self

func get_grab_position():
	return global_position + Vector2(32, -32)
	
func grab_human(human):
	Game.HUMANS_GRABBED += 1
	held_human = human
	
func drop_human():
	held_human = null
	
func has_human(): return held_human != null

func has_ingredient(): return held_ingredient != null

func holding_any(): return has_human() or has_ingredient()

func grab_ingredient(ingredient): held_ingredient = ingredient

func take_ingredient():
	var temp = held_ingredient
	held_ingredient = null
	return temp

func get_held_food_type():
	if has_ingredient():
		return held_ingredient.get_type()
	else:
		return ""

func _physics_process(_delta):
	if Game.is_mode_pausey(): return
	
	if Game.MODE == "serving":
		Game.PLAY_TIME += _delta
		
		Game.WAVE_TIME -= _delta
		Game.WAVE_TIME = clampf(Game.WAVE_TIME, 0, Game.MAX_WAVE_TIME)
		
		if Game.WAVE_TIME <= 0:
			Game.MODE = "waiting"
			Game.WAIT_TIME = 15
		
		Game.RATING -= _delta * 0.03
		Game.RATING = clampf(Game.RATING, 0, 5)
	
		if Game.RATING <= 0:
			Game.MODE = "game_over"
	elif Game.MODE == "waiting":
		Game.WAIT_TIME -= _delta
		
		if Game.WAIT_TIME <= 0 and Game.ALIVE_CUSTOMERS == 0:
			Game.MODE = "serving"
			Game.WAVE_NUMBER += 1
			Game.WAVE_TIME = Game.MAX_WAVE_TIME
	
	var movement = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
	)
	movement = movement.normalized()

	velocity = velocity.move_toward(movement * MAX_SPEED, ACCELERATION)

	move_and_slide()

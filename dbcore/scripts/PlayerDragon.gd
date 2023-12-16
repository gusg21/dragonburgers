extends CharacterBody2D

const ACCELERATION = 50.0
const MAX_SPEED = 250.0

var held_human
var held_ingredient

@onready var rip_frames = preload("res://frames/ripdragon.tres")
@onready var fancy_rip_frames = preload("res://frames/fancyripdragon.tres")

func _ready() -> void:
	Game.PLAYER = self

func get_grab_position():
	var offset
	if $Graphics.flip_h:
		offset = Vector2(32, -32)
	else:
		offset = Vector2(-24, -32)
	return global_position + offset
	
func grab_human(human):
	Game.HUMANS_GRABBED += 1
	held_human = human
	
func drop_human():
	held_human = null
	
func has_human(): return held_human != null

func has_ingredient(): return held_ingredient != null

func holding_any(): return has_human() or has_ingredient()

func grab_ingredient(ingredient):
	held_ingredient = ingredient

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
	
	if Input.is_action_just_pressed("DEBUG_die") and Game.DEBUG:
		Game.RATING = 0.01
	
	if Input.is_action_just_pressed("DEBUG_add_money") and Game.DEBUG:
		Game.MONEY += 1
	
	if Game.MODE == "serving":
		Game.PLAY_TIME += _delta
		
		Game.WAVE_TIME -= _delta
		Game.WAVE_TIME = clampf(Game.WAVE_TIME, 0, Game.MAX_WAVE_TIME)
		
		if Game.WAVE_TIME <= 0:
			Game.MODE = "waiting"
			if Game.WAVE_NUMBER >= 3:
				Game.WAIT_TIME = 5
			else:
				Game.WAIT_TIME = 10
		
		var rating_dec_speed = 0.03
		rating_dec_speed += (Game.WAVE_NUMBER-1) * 0.01
		
		Game.RATING -= _delta * rating_dec_speed
		Game.RATING = clampf(Game.RATING, 0, 5)
	
		if Game.RATING <= 0:
			if Game.PLAY_TIME > Game.HIGHSCORE_TIME:
				print("high")
				$Graphics.sprite_frames = fancy_rip_frames
			else:
				$Graphics.sprite_frames = rip_frames
			
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
	
	var speed_norm = velocity.length() / MAX_SPEED
	if speed_norm > 0.05:
		$Graphics.play("walk")
		$Graphics.speed_scale = speed_norm
	else:
		$Graphics.play("idle")		
		$Graphics.speed_scale = 1
	
	if abs(velocity.x) > 5:
		if velocity.x > 0:
			$Graphics.flip_h = true
		else:
			$Graphics.flip_h = false

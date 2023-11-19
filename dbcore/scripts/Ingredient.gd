extends Node2D

@export var food_type: String

var grabbed = false
var z_override = false

func _ready() -> void:
	if food_type != "":
		set_type(food_type)
		
	Game.SOUNDZ.play_sound("pickup")

func set_type(type):
	food_type = type
	$Sprite2D.texture = Game.FOOD_TYPES[food_type].texture

func get_type(): return food_type

func _process(delta: float) -> void:
	if grabbed:
		z_index = 1
		Game.PLAYER.grab_ingredient(self)
		global_position = Game.PLAYER.get_grab_position()
	else:
		z_index = 0
		
	if z_override: z_index = 1

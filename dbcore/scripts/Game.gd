extends Node

signal mode_changed(new_mode: String)

# data
var MODE = "menu":
	set(new_mode):
		emit_signal("mode_changed", new_mode)
		MODE = new_mode
var DEBUG = true
var PLAYER: Node2D
var WORLD: Node2D
var SOUNDZ: Sounds
var HUMANS_IN_BOX = 0
var HUMANS_GRABBED = 0
var PATTIES_BURNED = 0
var ALIVE_CUSTOMERS = 0
var CUSTOMERS_SERVED = 0
var INGREDIENTS_TRASHED = 0
var TABLES_TOPPLED = 0
var HIDING_SPOTS = []
var EAT_IN_SPOTS = []
var PLAY_TIME = 0
var WAVE_TIME = 90
var WAVE_NUMBER = 0
var WAIT_TIME = 15
var DOOR_POSITION: Vector2 = Vector2()
var HIGHSCORE_TIME = 0
var CUSTOMER_POSITIONS = {
	0: false, 1: false, 2: false
}
var RATING = 5.0
var ALIVE_HUMAN_COUNT = 0
var IS_REPLAY = false

func reset_data():
	HIDING_SPOTS = []
	EAT_IN_SPOTS = []
	HUMANS_IN_BOX = 0
	HUMANS_GRABBED = 0
	PATTIES_BURNED = 0
	CUSTOMERS_SERVED = 0
	INGREDIENTS_TRASHED = 0
	TABLES_TOPPLED = 0
	PLAY_TIME = 0
	WAVE_TIME = MAX_WAVE_TIME
	WAVE_NUMBER = 0
	WAIT_TIME = 15
	CUSTOMER_POSITIONS = {
		0: false, 1: false, 2: false
	}
	RATING = 5.0
	ALIVE_HUMAN_COUNT = 0
	IS_REPLAY = true
	MODE = "waiting"

func has_open_spot():
	return not (CUSTOMER_POSITIONS[0] and CUSTOMER_POSITIONS[1] and CUSTOMER_POSITIONS[2])
func get_open_spot():
	var indices = CUSTOMER_POSITIONS.keys()
	indices.shuffle()
	for i in indices:
		if not CUSTOMER_POSITIONS[i]:
			return i

# constants
const SAVE_FILE_NAME = "dragonz.gus"
const MAX_WAVE_TIME = 90.0
const SECONDS_TO_SAD = 40.0
const INGREDIENT_SCENE = preload("res://scenes/Ingredient.tscn")
const NUMBER_POP_SCENE = preload("res://scenes/NumberPop.tscn")
const FOOD_TYPES: Dictionary = {
	"burger": {
		texture = preload("res://sprites/burger.png")
	},
	"fries": {
		texture = preload("res://sprites/fries.png")
	},
	"patty": {
		texture = preload("res://sprites/patty.png")
	},
	"bread": {
		texture = preload("res://sprites/bread.png")
	},
	"burned_patty": {
		texture = preload("res://sprites/burned-patty.png")
	},
}

func _ready() -> void:
	randomize()
	
	var path = "user://" + SAVE_FILE_NAME
	if not FileAccess.file_exists(path):
		HIGHSCORE_TIME = 0
	else:
		var save = FileAccess.open(path, FileAccess.READ)
		HIGHSCORE_TIME = int(save.get_as_text())
		
func _exit_tree() -> void:
	var path = "user://" + SAVE_FILE_NAME
	var save = FileAccess.open(path, FileAccess.WRITE)
	save.store_line(str(HIGHSCORE_TIME))

func is_mode_pausey():
	return MODE in ["pause", "game_over", "menu"]

func get_time(): return Time.get_ticks_msec() / 1000.0

var _prev_mode = ""
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("pause_game"):
			if DEBUG:
				if is_mode_pausey():
					MODE = _prev_mode
				else:
					_prev_mode = MODE
					MODE = "pause"

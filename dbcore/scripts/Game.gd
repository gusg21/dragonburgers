extends Node

signal mode_changed(new_mode: String)
signal item_bought(id: int)

# data
var MODE = "":
	set(new_mode):
		emit_signal("mode_changed", new_mode)
		var index = MODE_STACK.size()-1
		if MODE_STACK.size() > 0: 
			MODE_STACK[index] = new_mode
		else:
			MODE_STACK.append(new_mode)
	get:
		if MODE_STACK.size() == 0: return ""
		
		return MODE_STACK[MODE_STACK.size()-1]
var MODE_STACK = []
var DEBUG = true
var PLAYER: Node2D
var WORLD: Node2D
var SOUNDZ: Sounds
var SECONDS_TO_SAD = 40.0
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
var MONEY = 0
var CUSTOMER_POSITIONS = {
	0: false, 1: false, 2: false
}
var RATING = 5.0:
	set(val):
		RATING = clampf(val, 0, 5)
var ALIVE_HUMAN_COUNT = 0
var IS_REPLAY = false
var SHOP_ITEMS = [
	{
		id = "extra-fryer-1",
		texture = preload("res://sprites/fryer.png"),
		name = "Extra Fryer",
		cost = 10,
		description = "Serve more customers with an extra fryer!"
	},
	{
		id = "extra-fryer-2",
		texture = preload("res://sprites/fryer.png"),
		name = "Extra Fryer",
		cost = 15,
		description = "Serve EVEN MORE customers with another extra fryer!"
	},
	{
		id = "extra-patty-maker-1",
		texture = preload("res://sprites/pattymaker.png"),
		name = "Extra Patty Maker",
		cost = 5,
		description = 	"Flatten more villagers into delicious patties " + 
						"with an extra patty maker!"
	},
	{
		id = "gold-coin-pile",
		texture = preload("res://sprites/coin-pile-shop-icon.png"),
		name = "Huge Pile of Gold",
		cost = 30,
		description = "Keep your customers happier for longer with some lovely decor! " +
			"Everyone knows dragons love huge gold piles."
	}
]
var BOUGHT_ITEM_IDS = []

func reset_data():
	BOUGHT_ITEM_IDS = []
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
	MONEY = 0
	MODE_STACK = ["waiting"]

func has_open_spot():
	return not (CUSTOMER_POSITIONS[0] and CUSTOMER_POSITIONS[1] and CUSTOMER_POSITIONS[2])
func get_open_spot():
	var indices = CUSTOMER_POSITIONS.keys()
	indices.shuffle()
	for i in indices:
		if not CUSTOMER_POSITIONS[i]:
			return i
func buy(item_id):
	BOUGHT_ITEM_IDS.append(item_id)
	item_bought.emit(item_id)

# constants
const PAUSEY_MODES = ["pause", "game_over", "menu", "shopping"]
const SAVE_FILE_NAME = "dragonz.gus"
const MAX_WAVE_TIME = 90.0
const INGREDIENT_SCENE = preload("res://scenes/Ingredient.tscn")
const NUMBER_POP_SCENE = preload("res://scenes/NumberPop.tscn")
const COIN_SCENE = preload("res://scenes/Coin.tscn")
const DIAMOND_SCENE = preload("res://scenes/Diamond.tscn")
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
	
	DEBUG = OS.has_feature("editor")
	
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
	return MODE in PAUSEY_MODES
	
func push_mode(new_mode):
	MODE_STACK.append(new_mode)
	emit_signal("mode_changed", MODE)

func pop_mode():
	MODE_STACK.pop_back()
	emit_signal("mode_changed", MODE)

func get_time(): return Time.get_ticks_msec() / 1000.0

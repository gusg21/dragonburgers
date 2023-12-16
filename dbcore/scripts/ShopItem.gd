extends HBoxContainer

@onready var buy_button = $AllDescriptionNLine/AllDescription/BuyButton
var my_id = ""
var my_cost = 99999999
var description_display: RichTextLabel

func _ready() -> void:
	buy_button.pressed.connect(on_buy_button_pressed)

func is_bought() -> bool:
	return my_id in Game.BOUGHT_ITEM_IDS
	
func can_buy() -> bool:
	return Game.MONEY >= my_cost

func _process(delta: float) -> void:
	$ItemPicBG/Check.visible = is_bought()
	buy_button.disabled = is_bought() or not can_buy()

func on_buy_button_pressed():
	if can_buy():
		Game.buy(my_id)
		description_display.append_text("\n[color=green]Purchased!")

# id = "extra-fryer-1",
# texture = preload("res://sprites/fryer-highlight.png"),
# name = "Extra Fryer",
# cost = 3,
# description = "Serve more customers with an extra fryer!"
func set_item_data(data):
	var id_display = $AllDescriptionNLine/AllDescription/NameNPrice/DEBUG_itemID
	var texture_display = $ItemPicBG/ItemPic
	var name_display = $AllDescriptionNLine/AllDescription/NameNPrice/ItemName
	var cost_display = $AllDescriptionNLine/AllDescription/NameNPrice/PriceContainer/ItemPrice
	description_display = $AllDescriptionNLine/AllDescription/CenterContainer/Description

	my_id = data["id"]
	id_display.text = data["id"]
	texture_display.texture = data["texture"]
	name_display.text = data["name"]
	my_cost = data["cost"]
	cost_display.text = str(data["cost"])
	description_display.text = "[center]" + data["description"]

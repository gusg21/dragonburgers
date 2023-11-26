extends HBoxContainer

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
	var description_display = $AllDescriptionNLine/AllDescription/CenterContainer/Description

	id_display.text = data["id"]
	texture_display.texture = data["texture"]
	name_display.text = data["name"]
	cost_display.text = str(data["cost"])
	description_display.text = "[center]" + data["description"]

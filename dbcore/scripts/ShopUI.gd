extends CenterContainer

var prev_mode
var shop_item_scene = preload("res://scenes/ShopItem.tscn")

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)	
	
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Quit.pressed.connect(on_quit_pressed)

func _process(delta: float) -> void:
	visible = Game.MODE == "shopping"

func on_quit_pressed():
	Game.pop_mode()

func setup_shop():
	var items_container = $ShopPanel/Panel/MarginContainer/VBoxContainer/ForSale/MarginContainer/Scroll/ShopItemsContainer
	
	for child in items_container.get_children():
		child.queue_free()
	
	var items: Array = Game.SHOP_ITEMS
	items.sort_custom(func(a, b):
		return a["cost"] < b["cost"]
	)
	for item in items:
		var container = $ShopPanel/Panel/MarginContainer/VBoxContainer/ForSale/MarginContainer/Scroll/ShopItemsContainer
		var new_item = shop_item_scene.instantiate()
		
		new_item.set_item_data(item)
		
		container.add_child(new_item)

func on_visibility_changed():
	if visible:
		setup_shop()

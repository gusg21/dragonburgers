extends Sprite2D


func _ready() -> void:
	Game.item_bought.connect(on_item_bought)
	
func on_item_bought(item_id):
	if item_id == "gold-coin-pile":
		Game.SECONDS_TO_SAD += 40

func _process(delta: float) -> void:
	visible = "gold-coin-pile" in Game.BOUGHT_ITEM_IDS
	

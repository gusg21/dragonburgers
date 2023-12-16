extends Node2D

var makers_unlocked = 0

func _ready() -> void:
	Game.item_bought.connect(on_item_bought)

func on_item_bought(item_id: String):
	if item_id.contains("patty"):
		makers_unlocked += 1

func _process(delta: float) -> void:
	$PattyMaker.visible = makers_unlocked >= 0
	$PattyMaker2.visible = makers_unlocked >= 0
	$PattyMaker3.visible = makers_unlocked >= 1

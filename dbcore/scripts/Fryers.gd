extends Node2D

var fryers_unlocked = 0

func _ready() -> void:
	Game.item_bought.connect(on_item_bought)

func on_item_bought(item_id: String):
	if item_id.contains("fryer"):
		fryers_unlocked += 1

func _process(delta: float) -> void:
	$Fryer.visible = fryers_unlocked >= 0
	$Fryer2.visible = fryers_unlocked >= 1
	$Fryer3.visible = fryers_unlocked >= 2

extends Sprite2D

func _process(delta: float) -> void:
	if Game.MODE == "waiting":
		visible = true
	else:
		visible = false

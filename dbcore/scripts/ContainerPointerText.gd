extends Label

func _process(delta: float) -> void:
	text = str(floor(Game.HUMANS_IN_BOX))

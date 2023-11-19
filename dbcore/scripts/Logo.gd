extends TextureRect

func _process(delta: float) -> void:
	position.y = sin(Game.get_time()) * 5

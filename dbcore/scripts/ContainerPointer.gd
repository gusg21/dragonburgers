extends Sprite2D

func _process(_delta: float) -> void:
	if Game.PLAYER.has_human():
		modulate.a = 1
		return
	
	var d = get_parent().global_position.distance_to(Game.PLAYER.global_position)
	if d < 80:
		modulate.a = 1
	else:
		modulate.a = 0

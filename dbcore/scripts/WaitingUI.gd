extends Sprite2D

func _ready() -> void:
	Game.mode_changed.connect(on_mode_changed)

func on_mode_changed(new):
	if new == "waiting":
		var tween = get_tree().create_tween()
		offset = Vector2(0, -100)
		tween.tween_property(self, "offset", Vector2.ZERO, 0.5)
		tween.play()
	else:
		var tween = get_tree().create_tween()
		offset = Vector2(0, 0)
		tween.tween_property(self, "offset", Vector2(0, -100), 0.5)
		tween.play()

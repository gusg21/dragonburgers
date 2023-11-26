extends Sprite2D

var icons = []
var o_pos = Vector2()

func _ready() -> void:
	for child in $Fires.get_children():
		icons.append(child)
		child.region_enabled = true
		child.region_rect = Rect2(
			0, 0, child.texture.get_width(), child.texture.get_height()
			)
	
	o_pos = position

func _process(delta: float) -> void:
	$RatingLabel.text = ("%.2f" % Game.RATING) + "/5"
	var low = Game.RATING < 0.75 and not Game.is_mode_pausey()
	$Vignette.visible = low
	if low:
		position = o_pos + Vector2(randf_range(-2.0, 2.0), randf_range(-2.0, 2.0))
	else:
		position = o_pos
	
	
	for i in range(5):
		var baseline = i * 0.2
		var normalized = (Game.RATING - baseline * 5.0)
		normalized = clamp(normalized, 0, 1)
		icons[i].scale = Vector2(normalized, normalized)

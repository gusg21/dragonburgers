extends Sprite2D

var icons = []

func _ready() -> void:
	for child in $Fires.get_children():
		icons.append(child)
		child.region_enabled = true
		child.region_rect = Rect2(
			0, 0, child.texture.get_width(), child.texture.get_height()
			)

func _process(delta: float) -> void:
	$RatingLabel.text = ("%.2f" % Game.RATING) + "/5"
	
	for i in range(5):
		var baseline = i * 0.2
		var normalized = (Game.RATING - baseline * 5.0)
		normalized = clamp(normalized, 0, 1)
		icons[i].scale = Vector2(normalized, normalized)

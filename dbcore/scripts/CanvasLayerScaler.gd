extends CanvasLayer

var best_height
var best_width
var ratio

func _ready() -> void:
	best_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	best_width = ProjectSettings.get_setting("display/window/size/viewport_width")

	ratio = best_width / best_height

func _process(delta: float) -> void:
	var current_size = get_viewport().get_visible_rect().size
	var ideal_height = floor(current_size.x / best_height)
	
	scale = Vector2(
		ideal_height * ratio,
		ideal_height
	)
	
	

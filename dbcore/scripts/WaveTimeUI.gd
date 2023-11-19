extends Node

var max_width

func _ready() -> void:
	max_width = $Bar.region_rect.size.x

func _process(delta: float) -> void:
	$WaveNum.text = str(Game.WAVE_NUMBER)
	$Bar.region_rect.size.x = (1-(Game.WAVE_TIME / Game.MAX_WAVE_TIME)) * max_width

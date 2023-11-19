extends Node2D

var speed = 10
var max_lifetime = 2
var lifetime = 2

func set_text(text): $Label.text = text

func set_color(color): 
	# this sucks
	var settings = LabelSettings.new()
	settings.font_color = color
	settings.outline_color = Color.BLACK
	settings.outline_size = 4
	$Label.set_label_settings(settings)

func _process(delta: float) -> void:
	global_position += Vector2.UP * delta * speed
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	scale = Vector2(
		lifetime * 3 / max_lifetime,
		lifetime * 3 / max_lifetime
	)
	modulate.a = lifetime / max_lifetime

extends Sprite2D

func set_happiness(happiness):
	frame = floor(happiness * float(hframes))

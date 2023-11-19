extends Node

func _ready():
	for child in get_children():
		Game.EAT_IN_SPOTS.append(child.global_position)

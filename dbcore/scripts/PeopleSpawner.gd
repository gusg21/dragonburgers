extends Node

@onready var person_scene = preload("res://scenes/Person.tscn")
var spawn_timer = 5.0
var spawn_positions = []

func _ready() -> void:
	for child in get_children():
		spawn_positions.append(child.global_position)
	
func _process(delta: float) -> void:
	if Game.is_mode_pausey(): return
	
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_timer = randf_range(1, 3)
		spawn_human()
		
func spawn_human():
	if Game.ALIVE_HUMAN_COUNT < 10:
		Game.ALIVE_HUMAN_COUNT += 1
		var human = person_scene.instantiate()
		human.global_position = spawn_positions.pick_random()
		Game.WORLD.add_child(human)
		print("HUMAN")

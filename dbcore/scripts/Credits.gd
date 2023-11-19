extends Control

func _ready() -> void:
	call_deferred("play_music")
	
func play_music():
	Game.SOUNDZ.play_sound("rocky")
	
func go_to_menu():
	Game.reset_data()
	get_tree().change_scene_to_file("res://scenes/Gameplay.tscn")

func _process(delta: float) -> void:
	var speed = 23
	
	if Input.is_anything_pressed():
		speed *= 5
	
	position += Vector2.UP * delta * speed
	
	if position.y < -930:
		go_to_menu()

extends Node2D

var flashing = false
var flash_time = 0.1
var next_flash = 9

func _ready() -> void:
	visible = false
	
	call_deferred("play_loop")

func play_loop():
	var loop = Game.SOUNDZ.play_sound("rainloop", "Ambient")
	

func flash():
	visible = true
	if randf() < 0.5:
		next_flash = 0.1
	else:
		next_flash = randf_range(2.5, 12)
		
	flash_time = 0.1

func unflash():
	visible = false
	flashing = false

func _process(delta: float) -> void:
	if fmod(Game.get_time(), next_flash) < 0.09 and not flashing:
		flash()
		flashing = true
		
	if flashing:
		flash_time -= delta
		if flash_time <= 0:
			unflash()

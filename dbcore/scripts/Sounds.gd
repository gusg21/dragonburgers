extends Node

class_name Sounds

@onready var SOUND_PLAYER_SCENE = preload("res://scenes/SoundPlayer.tscn")

func list_files_in_directory(path):
	print(path)
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		print("file %s" % file)
		if file == "":
			break
		elif file.begins_with("."):
			continue
		elif file.contains("import"):
			continue
		else:
			files.append(file)

	dir.list_dir_end()

	return files

var sounds = {}

func _ready() -> void:
	Game.SOUNDZ = self
	
	var path = OS.get_executable_path().get_base_dir() + "/sounds/"
	var sound_names = list_files_in_directory(path)
	for sound_name in sound_names:
		var sound = load(path + sound_name)
		sounds[sound_name.get_basename()] = sound
	print("loaded %s" % str(sound_names))

func kill_all_sounds():
	for sound in get_children():
		sound.queue_free()

func kill_sound(sound):
	sound.stop()
	sound.queue_free()

func play_sound(name, bus_name = "") -> AudioStreamPlayer:
	var player: AudioStreamPlayer = SOUND_PLAYER_SCENE.instantiate()
	add_child(player)
	player.finished.connect(func():
		kill_sound(player)
		)
	if bus_name != "":
		player.bus = bus_name
	else:
		player.bus = "Sounds"
	
	if name in sounds:
		player.stream = sounds[name]
		player.play()
		
		
		
		return player
	else:
		printerr("No sound by name %s" % name)
		
		return null

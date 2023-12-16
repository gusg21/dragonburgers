extends Control

@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sounds_bus_id = AudioServer.get_bus_index("Sounds")
@onready var ambient_bus_id = AudioServer.get_bus_index("Ambient")

const OPTIONS_PATH = "user://options.gus"
var options = {
	music = true,
	sfx = true,
	fullscreen = true
}

var silent_db = linear_to_db(0)
var music_init_db = 0
var sounds_init_db = 0
var ambient_init_db = 0

func _ready() -> void:
	music_init_db = AudioServer.get_bus_volume_db(music_bus_id)
	sounds_init_db = AudioServer.get_bus_volume_db(sounds_bus_id)
	ambient_init_db = AudioServer.get_bus_volume_db(ambient_bus_id)
	
	load_from_file()
	
	$MusicToggle.toggled.connect(on_music_toggled)
	$SoundToggle.toggled.connect(on_sound_toggled)
	
	$FullscreenToggle.toggled.connect(on_fullscreen_toggled)

func load_from_file():
	var loaded_options
	if FileAccess.file_exists(OPTIONS_PATH):
		var options_file = FileAccess.open(OPTIONS_PATH, FileAccess.READ)
		loaded_options = JSON.new().parse_string(options_file.get_line())
		if loaded_options:
			options = loaded_options
		else:
			DirAccess.remove_absolute(OPTIONS_PATH)
			print("Invalid options file! Using default options...")
	else:
		print("No options file, using default options...")
	
	if options != null:
		$MusicToggle.set_pressed_no_signal(options.music)
		$SoundToggle.set_pressed_no_signal(options.sfx)
		$FullscreenToggle.set_pressed_no_signal(options.fullscreen)
		
		on_music_toggled(options.music)
		on_sound_toggled(options.sfx)
		on_fullscreen_toggled(options.fullscreen)
		
		if options.has("debug"):
			Game.DEBUG = options["debug"]
		
		print("Loaded options file.")
		if Game.DEBUG:
			print(loaded_options)
	else:
		print("Failed to load valid options.")

func save_to_file():
	print("Saving options...")
	
	var options_file = FileAccess.open(OPTIONS_PATH, FileAccess.WRITE)
	var string_options = JSON.stringify(options)
	options_file.store_line(string_options)
	
	print(string_options)

func on_music_toggled(on: bool) -> void:
	options.music = on
	
	AudioServer.set_bus_volume_db(ambient_bus_id, ambient_init_db if on else silent_db)
	AudioServer.set_bus_volume_db(music_bus_id, music_init_db if on else silent_db)

func on_sound_toggled(on: bool) -> void:
	options.sfx = on	
	
	AudioServer.set_bus_volume_db(sounds_bus_id, sounds_init_db if on else silent_db)

func on_fullscreen_toggled(on: bool) -> void:
	options.fullscreen = on	
	
	if on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

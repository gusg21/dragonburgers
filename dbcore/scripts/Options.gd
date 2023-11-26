extends Control

@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sounds_bus_id = AudioServer.get_bus_index("Sounds")
@onready var ambient_bus_id = AudioServer.get_bus_index("Ambient")

var silent_db = linear_to_db(0)
var music_init_db = 0
var sounds_init_db = 0
var ambient_init_db = 0

func _ready() -> void:
	music_init_db = AudioServer.get_bus_volume_db(music_bus_id)
	sounds_init_db = AudioServer.get_bus_volume_db(sounds_bus_id)
	ambient_init_db = AudioServer.get_bus_volume_db(ambient_bus_id)
	
	$MusicToggle.toggled.connect(on_music_toggled)
	$SoundToggle.toggled.connect(on_sound_toggled)

func on_music_toggled(state: bool) -> void:
	AudioServer.set_bus_volume_db(ambient_bus_id, ambient_init_db if state else silent_db)
	AudioServer.set_bus_volume_db(music_bus_id, music_init_db if state else silent_db)

func on_sound_toggled(state: bool) -> void:
	AudioServer.set_bus_volume_db(sounds_bus_id, sounds_init_db if state else silent_db)

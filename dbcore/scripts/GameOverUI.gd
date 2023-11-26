extends MarginContainer

@onready var play_button = $"Panel/CenterContainer/VBoxContainer/HBoxContainer/Play Again"
@onready var itch_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Itch
@onready var credits_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Credits
@onready var stats = $Panel/CenterContainer/VBoxContainer/Stats

const STATS_TEMPLATE = """[center][font=res://fonts/arialrounded.TTF][font_size=25][u]Stats[/u][/font_size][/font]
Humans Grabbed: $$
Patties Burned: $$
Customers Served: $$
Ingredients Trashed: $$
Tables Toppled: $$
[color=green]Time Survived: $$[/color]
[color=#ccc]Highscore Time: $$[/color]
$$"""

func compose_stats(highscore):
	var minutes = floor(Game.PLAY_TIME / 60.0)
	var seconds = floor(fmod(Game.PLAY_TIME, 60.0))
	var himinutes = floor(Game.HIGHSCORE_TIME / 60.0)
	var hiseconds = floor(fmod(Game.HIGHSCORE_TIME, 60.0))
	return STATS_TEMPLATE.format([
		"%d" % Game.HUMANS_GRABBED,
		"%d" % Game.PATTIES_BURNED,
		"%d" % Game.CUSTOMERS_SERVED,
		"%d" % Game.INGREDIENTS_TRASHED,
		"%d" % Game.TABLES_TOPPLED,
		"%02d:%02d" % [minutes, seconds],
		"%02d:%02d" % [himinutes, hiseconds],
		"%s" % "[wave][rainbow]NEW HIGHSCORE![/rainbow][/wave]" if highscore else ""
	], "$$")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.mode_changed.connect(on_mode_changed)	
	
	play_button.button_up.connect(on_play_pressed)
	itch_button.button_up.connect(on_itch_pressed)
	credits_button.button_up.connect(on_credits_pressed)
	
#	if Game.DEBUG:
#		Game.MODE = "game_over"

func on_play_pressed():
	get_tree().reload_current_scene()
	Game.reset_data()

func on_itch_pressed():
	OS.shell_open("https://czarnicholas.itch.io/")

func on_credits_pressed():
	await get_tree().create_timer(0.5).timeout
	Game.SOUNDZ.kill_all_sounds()
	get_tree().change_scene_to_file("res://scenes/Credits.tscn")

func on_mode_changed(new: String):
	if new == "game_over":
		print("Game Over!")
		var tween = get_tree().create_tween()
		position = Vector2(0, 300)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", Vector2.ZERO, 2)
		tween.play()
		
		Game.SOUNDZ.kill_all_sounds()
		Game.SOUNDZ.play_sound("fail")
		
		var highscore = false
		if Game.PLAY_TIME > Game.HIGHSCORE_TIME:
			Game.HIGHSCORE_TIME = Game.PLAY_TIME
			highscore = true
			
		stats.text = compose_stats(highscore)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.MODE != "game_over":
		visible = false
	else:
		visible = true

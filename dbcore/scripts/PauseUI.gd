extends CenterContainer

var restart_progress = 0
var restart_down = false
@onready var options = $ShopPanel/Panel/MarginContainer/VBoxContainer/Options

func _ready() -> void:
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/Exit.pressed.connect(on_exit_pressed)
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/Return.pressed.connect(on_return_pressed)	
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/Restart.button_down.connect(on_restart_down)
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/Restart.button_up.connect(on_restart_up)

func _process(delta: float) -> void:
	visible = Game.MODE == "pause"
	
	if restart_down:
		restart_progress += delta * 50
		
		if restart_progress >= 100:
			options.save_to_file()
			get_tree().reload_current_scene()
			Game.reset_data()
	
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/RestartProgress.visible = restart_down
	$ShopPanel/Panel/MarginContainer/VBoxContainer/Buttons/RestartProgress.value = restart_progress

func on_exit_pressed():
	options.save_to_file()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func on_return_pressed():
	Game.pop_mode()
	options.save_to_file()

func on_restart_down():
	restart_down = true
	
func on_restart_up():
	restart_progress = 0
	restart_down = false

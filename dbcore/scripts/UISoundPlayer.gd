extends Node

func _ready():
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_SceneTree_node_added)

func _on_SceneTree_node_added(node):
	if node is Button:
		connect_to_button(node)

func _on_Button_pressed():
	Game.SOUNDZ.play_sound("button_press")

func _on_Button_mouse_entered():
	Game.SOUNDZ.play_sound([
		"button_hover",
		"button_hover2",
		"button_hover3",
		"button_hover4",
	].pick_random())
	

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button: Button):
	button.pressed.connect(_on_Button_pressed)
	button.mouse_entered.connect(_on_Button_mouse_entered)

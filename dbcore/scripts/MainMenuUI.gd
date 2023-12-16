extends Control

var index = 0

func get_all_children(in_node,arr:=[]):
	if in_node is Button:
		arr.push_back(in_node)
	
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
		
	return arr

func _ready() -> void:
	if Game.IS_REPLAY or Game.DEBUG:
		Game.MODE = "waiting"
		queue_free()
		return
	
	Game.MODE = "menu"
	
	for child in get_children():
		child.visible = true
	
	for button in get_all_children(self):
		button.button_up.connect(next_card)
	
	index = get_child_count() - 1
	visible = true

func next_card():
	
	fade_out()
	index -= 1
	
	if index == -1:
		Game.MODE = "waiting"
		queue_free()

func fade_out():
	var card = get_child(index)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", Vector2(0, 400), 1)
	tween.play()

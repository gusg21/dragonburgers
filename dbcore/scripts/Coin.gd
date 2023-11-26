extends AnimatedSprite2D

const COIN_TARGET_POS = Vector2(-256, -140)
const COIN_VALUE = 1
var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(on_body_entered)
	$Area2D.mouse_entered.connect(on_mouse_entered)

func pickup():
	Game.MONEY += COIN_VALUE
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.3)
	tween.parallel().tween_property(self, "position", COIN_TARGET_POS, 0.3)
	tween.tween_callback(queue_free)

func on_body_entered(body):
	if not picked_up:
		pickup()
		picked_up = true

func on_mouse_entered():
	if not picked_up:
		pickup()
		picked_up = true

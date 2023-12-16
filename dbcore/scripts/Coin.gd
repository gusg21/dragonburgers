extends AnimatedSprite2D

const COIN_TARGET_POS = Vector2(-256, -140)
const COIN_VALUE = 1
const DIAMOND_VALUE = 10
var picked_up = false
var velocity: Vector2 = Vector2.ZERO
var pickupable = false
var is_diamond = false # externally set
var base_offset = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_offset = offset
	$Area2D.body_entered.connect(on_body_entered)
	$Area2D.mouse_entered.connect(on_mouse_entered)

func _process(delta: float) -> void:
	offset = base_offset + Vector2.UP * sin(Game.get_time() * 2) * 2
	if is_diamond:
		rotation_degrees = sin(Game.get_time() * 4) * 10
	position += velocity
	velocity *= 0.6
	if velocity.length() < 0.1:
		velocity = Vector2.ZERO
		pickupable = true

func pickup():
	if not is_diamond:
		Game.MONEY += COIN_VALUE
	else:
		Game.MONEY += DIAMOND_VALUE
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	if not is_diamond:
		tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.3)
	tween.parallel().tween_property(self, "position", COIN_TARGET_POS, 0.7 if is_diamond else 0.3)
	tween.tween_callback(queue_free)

func on_body_entered(body):
	if not picked_up and pickupable:
		pickup()
		picked_up = true

func on_mouse_entered():
	if not picked_up and pickupable:
		pickup()
		picked_up = true

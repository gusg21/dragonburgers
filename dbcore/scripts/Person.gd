extends CharacterBody2D

const HIDDEN_TOLERANCE = 5

var movement_speed: float = 100.0
@export var movement_target_position: Vector2
var hiding_spot: Node2D
var am_i_hidden: bool = false
var mouse_over = false
var grabbed = false
var rehide_timer = 100

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	$Area2D.input_event.connect(_area_input)
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)
	
	$Sprite2D.frame = randi_range(0, $Sprite2D.hframes - 1)
	
	rehide_timer = randf_range(10, 20)

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false
	
func grabbable():
	return mouse_over and (Game.PLAYER.global_position.distance_to(global_position) < 100) and \
		not Game.PLAYER.holding_any()

func _area_input(view, event: InputEvent, shape):
	if event.is_action_pressed("click"):
		if mouse_over and grabbable():
			Game.PLAYER.grab_human(self)
			grabbed = true

func actor_setup():
	await get_tree().physics_frame

	find_new_hiding_spot()
	
func find_new_hiding_spot():
	rehide_timer = randf_range(10, 20)
	var AAA = randf() < 0.1
	$CPUParticles2D.emitting = AAA
	if AAA: print("AAA")
	
	var spots: Array = Game.HIDING_SPOTS
	spots.shuffle()
	for spot in spots:
		if spot.is_hidden():
			hiding_spot = spot
			movement_target_position = hiding_spot.get_hiding_point()
			set_movement_target(movement_target_position)
			return

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if Game.is_mode_pausey(): return	
	
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.limit_length()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()

func _exit_tree() -> void:
	Game.ALIVE_HUMAN_COUNT -= 1
	Game.ALIVE_HUMAN_COUNT = clamp(Game.ALIVE_HUMAN_COUNT, 0, 100)

func rehide():
	rehide_timer = randf_range(10, 20)
	find_new_hiding_spot()

func _process(delta: float) -> void:
	if Game.is_mode_pausey(): return
	
	if grabbed:
		global_position = Game.PLAYER.get_grab_position()
		$Sprite2D.z_index = 1
		$Highlight.visible = false
#		$CPUParticles2D.amount = 15
		$CPUParticles2D.emitting = true
	else:
		$Highlight.visible = mouse_over
		$Sprite2D.z_index = -1		
		
		am_i_hidden = global_position.distance_to(movement_target_position) < HIDDEN_TOLERANCE
		
		if hiding_spot:
			if not hiding_spot.is_hidden():
				find_new_hiding_spot()
			else:
				rehide_timer -= delta
				if rehide_timer <= 0:
					rehide()
		
		if not am_i_hidden:
			rotation_degrees = sin(Game.get_time() * 20.0) * 10.0
		else:
			$CPUParticles2D.emitting = false

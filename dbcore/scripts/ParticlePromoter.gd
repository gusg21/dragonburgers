extends CPUParticles2D

var original_parent
var will_destroy = false
var og_pos

func _ready() -> void:
	original_parent = get_parent()
	og_pos = global_position
	
	get_parent().remove_child(self)
	call_deferred("promote")
	

func promote():
	reparent($"/root/Gameplay/World")
	
	position = og_pos	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(original_parent) and not will_destroy:
		emitting = false
		get_tree().create_timer(2.0).timeout.connect(queue_free)
		will_destroy = true
	else:
		if is_instance_valid(original_parent):
			global_position = original_parent.global_position

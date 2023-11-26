extends Panel

const builtin_type_names = ["nil", "bool", "int", "real", "string", "vector2", "rect2", "vector3", "maxtrix32", "plane", "quat", "aabb",  "matrix3", "transform", "color", "image", "nodepath", "rid", null, "inputevent", "dictionary", "array", "rawarray", "intarray", "realarray", "stringarray", "vector2array", "vector3array", "colorarray", "unknown"]

func _ready() -> void:
	visible = false
	
	if not OS.has_feature("editor"):
		queue_free()
		return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_toggle_panel"):
		visible = !visible

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var info = ""
	var props = Game.get_property_list()
	props.sort_custom(func(a, b):
			return a["name"].naturalnocasecmp_to(b["name"]) < 0
	)
	var i = 0
	for prop in props:
		i += 0.1
		i = fmod(i, 1)
		var san_cname = prop["class_name"].to_lower()
		var is_caps = prop["name"] == prop["name"].to_upper()
		if not san_cname.contains("node") and not san_cname.contains("script") and is_caps:
			var value = Game.get(prop["name"])
			if typeof(value) != TYPE_OBJECT:
				var color = Color.from_hsv(i, 0.7, 0.9)
				info += "[color=" + color.to_html() + "]" + str(prop["name"]) + ": " + \
					str(value) + "(" + builtin_type_names[typeof(value)] + ")\n"
			else:
				info += str(prop["name"]) + ": " + str(value) + "(" + str(value.get_class()) + ")\n"
	
	$Box/Label.text = info

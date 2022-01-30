tool
extends VBoxContainer

signal color
signal tool_selected
signal view_selected
signal palette

export(Texture) var colors

func _ready() -> void:
	var c := find_node("colors")
	
	for i in range(16):
		var color_button = preload("color.tscn").instance()
		color_button.color.r8 = i
		c.add_child(color_button)

	for i in range(16):
		var color_button = preload("depth.tscn").instance()
		color_button.color.b8 = i << 4
		find_node("depth").add_child(color_button)

	for i in range(8):
		var color_button = preload("light.tscn").instance()
		color_button.color.r8 = i << 4
		find_node("light").add_child(color_button)

	for x in find_node("view").get_children():
		x.connect("pressed", self, "emit_signal", ["view_selected", x.name])

	for x in find_node("colors").get_children():
		x.connect("pressed", self, "_color_pressed", ["color", x.color])
		
	for x in find_node("shade").get_children():
		x.connect("pressed", self, "_color_pressed", ["slope", x.color])
		
	for x in find_node("depth").get_children():
		x.connect("pressed", self, "_color_pressed", ["depth", x.color])

	for x in find_node("tools").get_children():
		x.connect("pressed", self, "_tool_pressed", [x.name])
		
	for x in find_node("light").get_children():
		x.connect("pressed", self, "_color_pressed", ["light", x.color])
		
	find_node("palette").connect("pressed", self, "emit_signal", ["palette"])

func _tool_pressed(tool_name) -> void:
	emit_signal("tool_selected", tool_name)

func _color_pressed(map : String, color : Color) -> void:
	prints("_color_pressed", color)
	emit_signal("color", map, color)

func _on_save_as_pressed():
	find_node("save_as_dialog").popup_centered(Vector2(640, 480))

func _on_save_as_dialog_file_selected(path):
	emit_signal("save_as", path)

func dir_contents(path, i = 0):
	prints("PATH", path)

	var res = []
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if file_name != ".." and file_name != ".":
					res += dir_contents(path + "/" + file_name)
			else:
				if file_name.ends_with(".png"):
					res.push_back(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	return res

func _on_magic_pressed():
	for image in dir_contents("res://entity"):
		print(image)

		var texture :Texture = load(image)
		var data            := texture.get_data()
		
		data.lock()
		for y in range(texture.get_height()):
			for x in range(texture.get_width()):
				var color := data.get_pixel(x, y)
				
				if color.r8 == 6:
					color.r8 = 4

				data.set_pixel(x, y, color)
					
					
		data.unlock()
	
		data.save_png(image)
		prints("save", image)

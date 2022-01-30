tool
extends EditorPlugin

var tool_box_ 
var sprite_     : Sprite
var resource_path_ : String
var left_mouse_down_  := false
var right_mouse_down_ := false
var map_              := ""
var color_            := Color()
var edit_button_
var canvas_
var edited_           := false
var dirty_            := false

func handles(object : Object) -> bool:
	if object is Sprite and not object is PaintableSpriteOverlay and object.texture and object.texture is StreamTexture:
		return true
	else:
		return false

func apply_changes() -> void:
	if sprite_:
		#print("apply_changes")
		save_()

func edit(object : Object) -> void:
	prints('edit', object)
	
	ctor_(object)

func make_visible(show : bool) -> void:
	prints('make_visible', show)

	if not show:
		dtor_()

func _on_edit_pressed() -> void:
	print("_on_edit_pressed")
	
	edited_ = true
	add_tool_box_()

func add_edit_button_() -> void:
	remove_edit_button_()

	edit_button_ = PanelContainer.new()
	var b  = ToolButton.new()
	b.text = "Edit"
	edit_button_.add_child(b)
	b.connect("pressed", self, "_on_edit_pressed")
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, edit_button_)

func remove_edit_button_() -> void:
	if edit_button_:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, edit_button_)
		edit_button_.free()
		edit_button_ = null
		
func add_tool_box_() -> void:
	remove_tool_box_()

	tool_box_      = preload("res://addons/sprite/tool_box.tscn").instance()
	tool_box_.name = "tool_box"
	tool_box_.connect("color",         self, "set_color")
	tool_box_.connect("tool_selected", self, "set_tool")
	tool_box_.connect("palette",       self, "set_palette")
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, tool_box_)

	canvas_ = preload("res://addons/sprite/canvas.tscn").instance()
	sprite_.add_child(canvas_)

func ctor_(sprite : Sprite) -> void:
	if sprite == sprite_:
		return

	dtor_()
	
	if sprite.texture.resource_path.find(".png") == -1:
		push_error("ctor_ bad incoming resource_path " + sprite.texture.resource_path)
		return

	resource_path_  = sprite.texture.resource_path
	sprite_         = sprite

	prints("resource_path_ =", resource_path_)
	
	add_edit_button_()
	
func dtor_() -> void:
	print("dtor_")

	remove_edit_button_()
	remove_tool_box_()

	if sprite_:
		if not resource_path_:
			push_error("ctor_ null resource_path")
			sprite_ = null
			return

		if resource_path_.find(".png") == -1:
			push_error("ctor_ bad resource_path_ " + resource_path_)
			sprite_        = null
			resource_path_ = ""
			return

		if edited_:
			save_()

			prints("reseting texture", resource_path_)
			sprite_.texture = load(resource_path_)
	
	edited_        = false
	dirty_         = false
	sprite_        = null
	resource_path_ = ""

func remove_tool_box_() -> void:
	if tool_box_:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, tool_box_)
		tool_box_.free()
		tool_box_ = null
	
	if canvas_:
		canvas_.get_parent().remove_child(canvas_)
		canvas_.free()
		canvas_ = null

func forward_canvas_gui_input(event : InputEvent) -> bool:
	if not canvas_:
		return false
	
	if not sprite_ or not sprite_.is_inside_tree():
		return false

	if event is InputEventMouseButton and event.button_index == 1:
		left_mouse_down_ = event.pressed
	
	if event is InputEventMouseButton and event.button_index == 2:
		right_mouse_down_ = event.pressed
	
	if left_mouse_down_:
		edit_sprite(sprite_.get_global_mouse_position(), color_)
		return true

	if right_mouse_down_:
		edit_sprite(sprite_.get_global_mouse_position(), color_, true)
		return true

	return false

func save_() -> void:
	if not dirty_:
		return

	prints("save_", resource_path_)
	sprite_.texture.get_data().save_png(resource_path_)
	#print(ProjectSettings.globalize_path(resource_path_))
	dirty_ = false
	get_editor_interface().get_resource_filesystem().scan_sources()

func save_as(path) -> void:
	sprite_.texture.get_data().save_png(path)

func set_color(map : String, color : Color) -> void:
	prints("set_color", map, color)
	map_   = map
	color_ = color

	canvas_.material.set_shader_param("light_view", map_ == "light")
	canvas_.material.set_shader_param("depth_view", map_ == "depth")


func set_tool(tool_name : String) -> void:
	if tool_name == "fill" and map_ == "depth":
		var data := sprite_.texture.get_data()
		data.lock()
				
		for y in data.get_height():
			for x in data.get_width():
				var c := data.get_pixel(x, y)
				c.b8 = c.b8 & ~depth_mask
				c.b8 = c.b8 | color_.b8
				data.set_pixel(x, y, c)
		
		data.unlock()
		
		dirty_ = true

		var t := ImageTexture.new()
		t.create_from_image(data, 0)

		sprite_.texture = t

func set_palette() -> void:
	print("HI")
	var browse := FileDialog.new()
	browse.rect_size = Vector2(500, 500)
	browse.mode = FileDialog.MODE_OPEN_FILE
	add_child(browse)
	browse.popup_centered()
	var file = yield(browse, "file_selected")
	browse.queue_free()
	
	var material:ShaderMaterial = preload("res://addons/sprite/tool_box.tres")
	material.set_shader_param("color_swap_map", load(file))
	
	var canvas_material:ShaderMaterial = preload("res://addons/sprite/canvas.tres")
	canvas_material.set_shader_param("color_map", load(file))

const depth_mask = 15 << 4
const slope_mask = 15
const light_mask = 15 << 4
const slope_none = 5

func edit_sprite(position : Vector2, color : Color, erase : bool = false) -> void:
	
	position.rotated(sprite_.rotation)
	
	if sprite_.centered:
		position[0] += sprite_.texture.get_width()  * 0.5
		position[1] += sprite_.texture.get_height() * 0.5
	
	position[0] = floor(position[0] - sprite_.global_position[0])
	position[1] = floor(position[1] - sprite_.global_position[1])

	var data := sprite_.texture.get_data()
	data.lock()
	var c = data.get_pixelv(position)
	var d = c
	
	print(map_)
	
	if map_ == "color":
		if erase:
			c = Color(0.0, slope_none, 0.0, 0.0)
		else:
			if c.a8 == 0:
				c.b8 = slope_none
			c.r = color.r
			c.g = 0.0
			c.a = 1.0
	elif map_ == "light":
		if erase:
			c.r8 = c.r8 & ~light_mask
		else:
			c.r8 = c.r8 & ~light_mask
			c.r8 = c.r8 | color.r8
	elif map_ == "slope":
		if erase:
			c.b8 = c.b8 & ~slope_mask
			c.b8 = c.b8 | slope_none
		else:
			c.b8 = c.b8 & ~slope_mask
			c.b8 = c.b8 | color.b8
	elif map_ == "depth":
		if erase:
			c.b8 = c.b8 & ~depth_mask
		else:
			c.b8 = c.b8 & ~depth_mask
			c.b8 = c.b8 | color.b8

	data.set_pixelv(position, c)
	data.unlock()

	if c == d:
		return

	dirty_ = true

	var t := ImageTexture.new()
	t.create_from_image(data, 0)

	sprite_.texture = t


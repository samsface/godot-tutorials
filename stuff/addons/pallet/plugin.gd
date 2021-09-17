tool
extends EditorPlugin

var editing_object_:Node2D
var selected_scene_
var pallet_:GridContainer

func handles(object:Object) -> bool:
	return object is PalletCanvas

func edit(object:Object) -> void:
	editing_object_ = object

func make_visible(show : bool) -> void:
	if show:
		add_pallet_()
	else:
		remove_pallet_()

func add_pallet_() -> void:
	if pallet_:
		return

	pallet_ = GridContainer.new()
	pallet_.columns = 4
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, pallet_)
	
	var stuff := [
		"res://entities/entity.tscn",
		"res://entities/entity2.tscn"
		]
		
	var resource_previewer := get_editor_interface().get_resource_previewer()
	
	for path in stuff:
		resource_previewer.queue_resource_preview(path, self, "_on_resource_preview", null)
	
func _on_resource_preview(path:String, texture:Texture, user_data) -> void:
	if pallet_ and texture:
		var button := Button.new()
		button.icon = texture
		button.rect_min_size = Vector2(32, 32)
		button.connect("pressed", self, "_on_button_pressed", [path])
		pallet_.add_child(button)

func _on_button_pressed(path:String) -> void:
	print(path)
	selected_scene_ = path

func remove_pallet_() -> void:
	if pallet_:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, pallet_)
		pallet_.queue_free()
		pallet_ = null

func forward_canvas_gui_input(event:InputEvent) -> bool:
	if not editing_object_:
		return false

	if not event is InputEventMouseButton:
		return false
	
	prints(event.pressed, event.button_index)
	
	if not event.pressed or not event.button_index == 1:
		return false
		
	prints(selected_scene_)
		
	var new_instance_resource := load(selected_scene_)
	if not new_instance_resource:
		return false
		
	var new_instance = new_instance_resource.instance()
	if not new_instance:
		return false
		
	var undo := get_undo_redo()
	undo.create_action("paint_scene")
	undo.add_do_method(self, "paint_scene_", new_instance, editing_object_, editing_object_.get_global_mouse_position())
	undo.add_undo_method(self, "undo_paint_scene_", new_instance, editing_object_)
	# docs say this will prevent leaking newly created node though never verified personally
	undo.add_do_reference(new_instance)
	undo.commit_action()
	
	# stop godot selecting newly added node
	get_editor_interface().call_deferred("edit_node", editing_object_)
	
	return true

func paint_scene_(scene:Node, pallet:Node, position:Vector2) -> void:
	pallet.add_child(scene)
	scene.global_position = position.snapped(Vector2(64, 64))
	# without this, node will be added but NOT to the scene tree so won't be saved
	scene.owner = pallet

func undo_paint_scene_(scene:Node, pallet:Node) -> void:
	pallet.remove_child(scene)
	# no queue_free as we may redo action
	

tool
extends EditorPlugin

var editing_object_
var snap_button_

# Hook called by godot editor when we select a node in scene tree.
# Return true if we want our plugin to play with the node.
func handles(object:Object) -> bool:
	prints("handles", object.name)
	return object is Node

# Hook called by godot editor right after we return true from `handles` above ^^^.
func edit(object:Object) -> void:
	prints("edit", object.name)
	editing_object_ = object

# Hook called by godot editor telling you to either hide or show your plugin
# based on what you've told the editor in `handles` above ^^^.
func make_visible(show : bool) -> void:
	prints("make_visible", show)
	if not show:
		remove_snap_button_()
	else:
		add_snap_button_()

func add_snap_button_() -> void:
	if snap_button_:
		return
	snap_button_ = ToolButton.new()
	snap_button_.text = "Snap"
	snap_button_.connect("pressed", self, "snap_", [editing_object_])
	# Special version of `add_child` that adds nodes to editor gui.
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, snap_button_)

func remove_snap_button_() -> void:
	if snap_button_:
		# Special version of `remove_child` that removes nodes from editor gui.
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, snap_button_)
		snap_button_.queue_free()
		snap_button_ = null

func snap_(node:Node) -> void:
	node.global_position = node.global_position.snapped(Vector2(32, 32))

	for child in node.get_children():
		snap_(child)

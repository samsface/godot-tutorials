extends Node2D

var config_:Config

func _enter_tree() -> void:
	load_()

func _ready() -> void:
	test_()

func save_():
	# issue one, you have to open a file and call save yourself
	# issue two, you get everything because no export
	# issue three, it fails on complex stuff
	
	for action in InputMap.get_actions():
		config_.input_map[action] = InputMap.get_action_list(action)

	ResourceSaver.save("user://config.tres", config_)

func load_():
	config_ = load("user://config.tres")
	
	var x = var2str(Test.new())
	print(x)
	var y = str2var(x)
	print(y)
	
	if not config_:
		config_ = Config.new()
	
	for action in config_.input_map:
		InputMap.action_erase_events(action)
		for input_event in config_.input_map[action]:
			InputMap.action_add_event(action, input_event)

# TEST JUST FOR VIDEO
func test_():
	var s := Stats.new()
	for property in s.get_property_list():
		print(property)
	
	
	config_.volume = 0.5
	config_.show_tutorial = true
	config_.i_wont_be_saved = 5

	save_()
	
	OS.shell_open(ProjectSettings.globalize_path("user://"))

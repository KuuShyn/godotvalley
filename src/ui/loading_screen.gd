extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String

var min_load_time: float = 5.0  # Set the duration in seconds
var time_elapsed: float = 0.0
var loading_finished: bool = false

func _ready():
	# Start the background loading
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(delta: float):
	# Track how much time has passed
	time_elapsed += delta
	
	# Check if the ResourceLoader is done
	var status = ResourceLoader.load_threaded_get_status(next_scene_path)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		loading_finished = true
	
	# Only change the scene if BOTH conditions are met:
	# 1. The resource is fully loaded
	# 2. At least 5 seconds have passed
	if loading_finished and time_elapsed >= min_load_time:
		set_process(false) # Stop this loop
		goto_scene()

func goto_scene():
	var new_scene = ResourceLoader.load_threaded_get(next_scene_path)
	get_tree().change_scene_to_packed(new_scene)
	# Remove the loading screen from the root after switching
	queue_free()

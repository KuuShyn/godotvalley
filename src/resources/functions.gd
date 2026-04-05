extends Node

var previous_scene_path: String = ""
var player_position: Vector2 = Vector2.ZERO

func load_screen_to_scene(target: String, player: Node = null) -> void:
	# Save current scene + player position
	var current_scene = get_tree().current_scene
	if current_scene:
		previous_scene_path = current_scene.scene_file_path
	
	if player:
		player_position = player.global_position
	
	# Load loading screen
	var loading_screen_scene = preload("res://scenes/ui/loading_screen.tscn")
	var loading_screen = loading_screen_scene.instantiate()
	
	loading_screen.next_scene_path = target
	
	get_tree().root.add_child(loading_screen)

func return_to_previous_scene() -> void:
	if previous_scene_path == "":
		return
	
	load_screen_to_scene(previous_scene_path)

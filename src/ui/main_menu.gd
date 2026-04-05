extends Control

func _on_start_pressed() -> void:
	# Replace the old line with your global loading function
	# This triggers the loading screen instead of an instant swap
	Functions.load_screen_to_scene("res://scenes/levels/level.tscn")

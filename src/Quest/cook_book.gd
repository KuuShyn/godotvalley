extends Control

signal recipe_selected(recipe: RecipeResource)

@export var dodol_recipe: RecipeResource 

func _on_button_pressed() -> void:
	# Even if dodol_recipe is null, we'll send a dummy resource to prevent crashes
	var selected = dodol_recipe if dodol_recipe else RecipeResource.new()
	
	recipe_selected.emit(selected)
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		queue_free()

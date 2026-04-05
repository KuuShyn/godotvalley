extends Control

@export var ingredient_scene: PackedScene
@onready var spawn_left: Control = $spawn_left
@onready var spawn_right: Control = $spawn_right
@onready var cooking_ui: Control = $"../.."


func spawn_ingredient(ingredient_id: String, side: String = "left"):
	if not CookingData.DODOL_INGREDIENT_SPAWNS.has(ingredient_id):
		push_error("Unknown ingredient: " + ingredient_id)
		return
	
	var data = CookingData.DODOL_INGREDIENT_SPAWNS[ingredient_id]
	var ingredient = ingredient_scene.instantiate()
	
	# Set textures
	ingredient.texture = data.texture
	ingredient.texture_to_spawn = data.spawn_texture
	cooking_ui.trigger_dialogue_for(ingredient_id.to_lower() + "_spawned")
	print(ingredient_id.to_lower() + "_spawned")
	print(cooking_ui.get_path())
	ingredient.name = ingredient_id  # Use ID as node name
	
	# Choose container
	var container = spawn_left if side == "left" else spawn_right
	

	container.add_child(ingredient)

	return ingredient

func clear_ingredients():
	for child in spawn_left.get_children():
		child.queue_free()
	for child in spawn_right.get_children():
		child.queue_free()

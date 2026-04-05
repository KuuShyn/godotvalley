extends Control

signal recipe_selected(recipe: RecipeResource)
signal closed

@export var recipes: Array[RecipeResource] = []

@onready var container = $Panel/ScrollContainer/VBoxContainer

func _ready():
	recipes.clear()
	# Ensure this path is exactly correct in your FileSystem
	load_recipes_from_folder("res://resources/recipes/")
	populate_list()

func load_recipes_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# .remap check is good for exported games!
			if file_name.ends_with(".tres") or file_name.ends_with(".remap"):
				var recipe = load(path + file_name.replace(".remap", ""))
				if recipe is RecipeResource:
					recipes.append(recipe)
			file_name = dir.get_next()

func populate_list():
	for child in container.get_children():
		child.queue_free()
		
	for recipe in recipes:
		var btn = Button.new()
		# Use .get() or check if recipe exists to avoid "Invalid Access" errors
		btn.text = recipe.recipe_name if "recipe_name" in recipe else "Unknown Recipe"
		
		# If your Resource uses 'name' instead of 'recipe_name', use this:
		# btn.text = recipe.name 
		
		btn.custom_minimum_size = Vector2(0, 50)
		# Connect the dynamic button to the selection logic
		btn.pressed.connect(func(): _on_recipe_chosen(recipe))
		container.add_child(btn)

func _on_recipe_chosen(recipe: RecipeResource):
	# This sends the signal that stove.gd is waiting for
	recipe_selected.emit(recipe)
	# Close the menu so the minigame can show up
	queue_free() 

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		closed.emit()
		queue_free()

extends Control

signal recipe_selected(recipe: RecipeResource)

@export var dodol_recipe: RecipeResource 

@onready var recipe_bg_2: NinePatchRect = $CanvasLayer/BookFrame/RecipeBg2
@onready var recipe_bg_3: NinePatchRect = $CanvasLayer/BookFrame/RecipeBg3
@onready var recipe_bg_4: NinePatchRect = $CanvasLayer/BookFrame/RecipeBg4

var pages: Array
var current_page := 0

func _ready():
	pages = [recipe_bg_2, recipe_bg_3, recipe_bg_4]
	_update_pages()

func _on_button_pressed() -> void:
	var selected = dodol_recipe if dodol_recipe else RecipeResource.new()
	recipe_selected.emit(selected)
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		queue_free()

func _on_page_button_pressed() -> void:
	current_page += 1
	
	if current_page >= pages.size():
		current_page = 0  # loop back to first page
	
	_update_pages()

func _update_pages():
	for i in range(pages.size()):
		pages[i].visible = (i == current_page)

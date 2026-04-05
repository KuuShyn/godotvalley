extends Control

# Textures
const STOVE_COOL = preload("uid://crejtcqhjlcag")
const STOVE_HOT = preload("uid://287stkiqvlln")
const POT_FRONTHOT = preload("uid://bigfpdhlng6m8")

# Node references
@onready var spawner: Control = $"Pot Cooking/IngredientSpawner"
@onready var stove: NinePatchRect = $"Pot Cooking/Stove"

@onready var pot_back: NinePatchRect = $"Pot Cooking/Pot Back"
@onready var pot_ingredients: NinePatchRect = $"Pot Cooking/Pot Ingredients"
@onready var pot_front: NinePatchRect = $"Pot Cooking/Pot Front"
@onready var pot_zone: Control = $"Pot Cooking/Pot Zone"
@onready var laddle: CharacterBody2D = $"Pot Cooking/Laddle"

@onready var cooking_dialogue: Control = $"Cooking Dialogue"
@onready var start_cooking: Button = $"Start Cooking"
@onready var pot_cooking: CanvasLayer = $"Pot Cooking"
@onready var ingredient_spawner: Control = $"Pot Cooking/IngredientSpawner"
@onready var stove_button: Button = $"Pot Cooking/Stove Button"
@onready var proceed_button: Button = $"Pot Cooking/Proceed Button"
@onready var done_canvas: CanvasLayer = $"Done canvas"

func _ready():
	laddle.visible = false
	laddle.pot_ingredients = pot_ingredients  # Give ladle the reference
	pot_cooking.visible = false
	spawner.spawn_ingredient("Sugar", "right")
	cooking_dialogue.show_dialogue("Tap the screen, anak... let's begin cooking.", "pink")
	


func _on_spawn_laddle_pressed() -> void:
	laddle.visible = !laddle.visible 
	
	
func _on_reset_pressed():
	spawner.clear_ingredients()
	spawner.spawn_both_ingredients()


func _on_start_cooking_pressed() -> void:
	start_cooking.hide()
	pot_cooking.show()
	#cooking_dialogue.hide_dialogue("pink") 
	cooking_dialogue.show_dialogue("Light the fire first — press the stove button", "pink")
	


func _on_stove_button_pressed() -> void:
	cooking_dialogue.show_dialogue("First place the palm sugar and coconut milk into the wok. Add the tied pandan leaves.", "pink")
	ingredient_spawner.show()
	stove.texture = STOVE_HOT
	pot_front.texture = POT_FRONTHOT
	stove_button.hide()
	
# NEW: Show finish dialogue and button
func show_finish_dialogue():
	cooking_dialogue.hide_dialogue("blue")
	cooking_dialogue.show_dialogue("Remove the pandan leaves now—they've already released their flavor.", "pink")
	proceed_button.show()

func _on_proceed_button_pressed():
	start_cooking.hide()
	proceed_button.hide()
	cooking_dialogue.hide_dialogue("pink")
	pot_cooking.hide()
	await get_tree().create_timer(1.0).timeout
	done_canvas.show()
	

func trigger_dialogue_for(event: String):
	match event:
		"sugar_dropped":
			cooking_dialogue.show_dialogue(
				"As the mixture heats, the sugar molecules move faster and dissolve into the liquid.",
				"blue"
			)

		"pandanleaves_spawned":
			cooking_dialogue.show_dialogue(
				"The pandan leaves release аромат compounds that spread through diffusion, giving that signature smell.",
				"blue",
			)
		"pandanleaves_dropped":
			cooking_dialogue.hide_dialogue("blue")
			
		"riceflour_spawned":
			cooking_dialogue.show_dialogue(
				"Now, slowly pour in the glutinous rice flour mixture. Keep stirring!",
				"pink"
			)
		"riceflour_dropped":
			cooking_dialogue.show_dialogue(
				"Continuous stirring keeps the mixture uniform—this shows how particles stay evenly suspended.",
				"blue"
			)
			
		"stage8_start":
			cooking_dialogue.show_dialogue(
				"Don’t stop stirring! This part takes patience.",
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"The starch is undergoing gelatinization—absorbing water and thickening into a sticky texture.", 
				"blue"
			)
		"stage9_start":
			cooking_dialogue.show_dialogue(
				"At the same time, the sugar is caramelizing, creating that deep brown color and rich flavor.",
				"blue"
			)
		"stage10_start":
			cooking_dialogue.show_dialogue("Steady stirring spreads heat evenly and prevents burning.", "pink")
			cooking_dialogue.show_dialogue(
				"When the mixture starts pulling away from the pan, it’s almost ready.",
				"blue",
			)
		"dodol_done":
			show_finish_dialogue()
		"transfer_dodol":
			cooking_dialogue.show_dialogue(
				"Transfer the cooked dodol onto banana leaves.",
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"As it cools, thermal energy is released, allowing the mixture to set into a firm but chewy structure.",
				"blue"
			)
		"transfer_dodol_done":
			cooking_dialogue.hide_dialogue(
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"As it cools, thermal energy is released, allowing the mixture to set into a firm but chewy structure.",
				"blue"
			)
		"fold_dodol":
			cooking_dialogue.show_dialogue(
				"Fold the opposite ends of the banana leaf toward each other.",
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"The banana leaf helps retain heat and moisture while adding a subtle natural aroma.",
				"blue"
			)
		"fold_dodol_step2":
			cooking_dialogue.show_dialogue(
				"Press it gently to shape it evenly.",
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"The dodol is still soft, so it behaves like a viscoelastic material — it can be shaped easily.",
				"blue"
			)
		"cut_dodol":
			cooking_dialogue.show_dialogue(
				"Cut in the middle for serving.",
				"pink"
			)
			cooking_dialogue.show_dialogue(
				"As it cools further, the structure firms up, allowing clean cuts.",
				"blue"
			)
		"dodol_serve":
			cooking_dialogue.show_dialogue("And there you have it — your dodol is ready to serve!", "pink")
			cooking_dialogue.hide_dialogue("blue")
		"dodol_animation":
			cooking_dialogue.hide_dialogue("pink")
			

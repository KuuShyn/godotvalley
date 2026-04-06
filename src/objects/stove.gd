extends StaticBody2D

# --- 1. PRELOADS ---
var cook_book_scene = preload("res://scenes/Quest/cook_book.tscn")
const COOKING_UI = "res://scenes/cooking/scene/cooking_ui.tscn"


# --- 2. VARIABLES ---
var current_player: CharacterBody2D = null
var transitioning := false

# --- 3. THE INTERACTION ---
func interact(player: CharacterBody2D) -> void:
	if player.current_state == Enum.State.COOKING:
		return
	
	current_player = player
	var book = cook_book_scene.instantiate()
	book.tree_exited.connect(_on_book_closed)
	
	var canvas = get_tree().get_first_node_in_group("CanvasLayer")
	if not canvas:
		canvas = get_tree().current_scene.get_node_or_null("Overlay/CanvasLayer")
		
	if canvas:
		canvas.add_child(book)
		player.current_state = Enum.State.COOKING
		
		# Connect the selection signal
		book.recipe_selected.connect(_on_recipe_selected)
		
		# MANUAL CLEANUP: Only reset if the book is deleted WITHOUT 
		# transitioning to the minigame.
	
func _on_recipe_selected(recipe: RecipeResource) -> void:
	# 1. Wait for the Cook Book to be fully gone
	transitioning = true
	await get_tree().process_frame
	Functions.load_screen_to_scene(COOKING_UI, current_player)
	

func _on_book_closed() -> void:
	if current_player and not transitioning:
		current_player.current_state = Enum.State.DEFAULT
	
	
# Commented Out
## --- 4. THE TRANSITION ---
#func _on_recipe_selected(recipe: RecipeResource) -> void:
	## 1. Wait for the Cook Book to be fully gone
	#await get_tree().process_frame
	#
	## 2. Spawn the minigame
	#var minigame = minigame_scene.instantiate()
	#
	## 3. Add to a unique group so the cleanup logic knows a game is running
	#minigame.add_to_group("ActiveMinigame")
	#
	#var canvas = get_tree().get_first_node_in_group("CanvasLayer")
	#if canvas:
		#canvas.add_child(minigame)
		## 4. Connect the exit signal to the ACTUAL minigame
		#minigame.tree_exited.connect(_on_minigame_finished)
		#print("SUCCESS: Minigame started.")
	#else:
		#_on_minigame_finished()
#
## --- 5. THE CLEANUP ---
#func _on_minigame_finished() -> void:
	#if current_player:
		#current_player.current_state = Enum.State.DEFAULT
	#print("Stove: Player state reset to Default.")
	

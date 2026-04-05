extends CharacterBody2D

@export var speed: float = 2000.0
@export var stir_threshold: float = 4.0
@export var stir_cooldown: float = 0.1
@onready var pot_cooking: CanvasLayer = $".."

@onready var pot_ingredients: NinePatchRect = $"../Pot Ingredients"
@onready var done_canvas: CanvasLayer = $"../../Done canvas"
@onready var spawner: Control = $"../IngredientSpawner"
@onready var cooking_ui: Control = $"../.."

var is_dragging: bool = false
var drag_offset: Vector2
var last_position: Vector2
var stir_timer: float = 0.0
var stir_count: int = 0
var current_speed: float = 0.0
var speed_category: String = "idle"
var cook_progress: float = 0.0
var is_waiting_for_ingredient: bool = false
var is_cooking_done: bool = false
var z_timer: float = 0.0

func _ready():
	# Start hidden until first ingredient is added
	hide()

func _physics_process(delta):
	if is_cooking_done:
		return
	
	if is_dragging:
		
		var target = get_global_mouse_position() + drag_offset
	
		velocity = (target - global_position) * speed * delta
		var movement = (global_position - last_position).length()
		if movement > stir_threshold:
			z_timer += movement * 0.0005  # scale this for sensitivity
			z_index = int(z_timer) % 2
		
		check_stir(delta)
	else:
		velocity = Vector2.ZERO
		current_speed = 0.0
		speed_category = "idle"
	
	if stir_timer > 0:
		stir_timer = max(0, stir_timer - delta)
	
	move_and_slide()

func check_stir(delta):
	if stir_timer > 0:
		return
	
	if is_waiting_for_ingredient:
		return
	
	var movement = global_position - last_position
	var distance = movement.length()
	current_speed = velocity.length()
	
	if distance > stir_threshold:
		if current_speed < 1500:
			speed_category = "slow"
		elif current_speed < 2500:
			speed_category = "medium"
		else:
			speed_category = "fast"
		
		stir_count += 1
		stir_timer = stir_cooldown

		#print("Stir #", stir_count, " | ", speed_category, " | ", int(current_speed))
		
		cook_ingredient(delta)
	
	last_position = global_position

func cook_ingredient(delta):
	if not pot_ingredients or not pot_ingredients.texture:
		return
	
	var current_stage = pot_ingredients.get_meta("ingredient_name", "")
	if not CookingData.DODOL_STAGES.has(current_stage):
		return
	
	var stage = CookingData.DODOL_STAGES[current_stage]
	
	if not is_speed_valid(stage.required_speed):
		#print(current_stage, " needs ", stage.required_speed, " stirring!")
		return
	
	cook_progress += delta + 0.15
	var percent = int((cook_progress / stage.stir_time) * 100)
	#print("Cooking ", current_stage, ": ", percent, "%")
	
	if stage.has("dialogue_at_60_percent") and percent >= 60 and not stage.get("dialogue_shown", false):
		cooking_ui.trigger_dialogue_for("stage10_start")

	if cook_progress >= stage.stir_time:
		finish_stage(current_stage, stage)

func is_speed_valid(required: String) -> bool:
	if required == "any":
		return true
	return speed_category == required

func finish_stage(stage_name: String, stage: Dictionary):
	print(stage_name, " done!")
	cooking_ui.trigger_dialogue_for(stage_name.to_lower() + "_start")
	print(stage_name.to_lower() + "_start")
	# Show the stir texture FIRST (final dish texture)
	if stage.stir_texture:
		pot_ingredients.texture = stage.stir_texture
		print("Changed texture to: ", stage.stir_texture.resource_path)
	
	# Check for next_stage (auto-progression)
	if stage.has("next_stage") and stage.next_stage != null:
		pot_ingredients.set_meta("ingredient_name", stage.next_stage)
		print("Auto-progress to: ", stage.next_stage)
		cook_progress = 0.0
		
	elif stage.has("next_ingredient"):
		spawner.spawn_ingredient(stage.next_ingredient, stage.spawn_side)
		print("Spawned: ", stage.next_ingredient)
		is_waiting_for_ingredient = true
		
		# HIDE LADLE - wait for player to add ingredient
		hide()
		#print("🥄 Ladle hidden - add ingredient to continue")
		
		pot_ingredients.set_meta("finished_ingredient", stage_name)
	
	elif stage.has("finished_dish"):
		print(stage.finished_dish, " is ready!")
		is_cooking_done = true
		hide()
		# Wait a moment to show final texture, then show done canvas
		cooking_ui.trigger_dialogue_for(stage.finished_dish.to_lower() + "_done")
		print(stage.finished_dish.to_lower() + "_done")
	

func on_ingredient_added(new_ingredient: String):
	is_waiting_for_ingredient = false
	cook_progress = 0.0
	
	# SHOW LADLE - ingredient is in pot, ready to stir
	show()
	print("🥄 Ladle shown - start stirring!")
	
	print("🆕 New ingredient added: ", new_ingredient)

func _on_button_button_down() -> void:
	if is_cooking_done or not visible:
		return
	is_dragging = true
	drag_offset = global_position - get_global_mouse_position()
	last_position = global_position

func _on_button_button_up() -> void:
	is_dragging = false
	current_speed = 0.0
	speed_category = "idle"

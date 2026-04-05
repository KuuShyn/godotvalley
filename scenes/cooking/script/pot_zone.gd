extends Control

@onready var target_slot: NinePatchRect = $"../Pot Ingredients"
@onready var laddle: CharacterBody2D = $"../Laddle"

@onready var cooking_ui: Control = $"../.."

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _notification(what):
	match what:
		NOTIFICATION_DRAG_BEGIN:
			mouse_filter = Control.MOUSE_FILTER_PASS 
		NOTIFICATION_DRAG_END:
			mouse_filter = Control.MOUSE_FILTER_IGNORE 

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is NinePatchRect and data.texture != null

func _drop_data(at_position: Vector2, data: Variant):
	var source = data as NinePatchRect
	var ingredient_texture = source.get("texture_to_spawn")
	source.texture = null
	
	if target_slot and ingredient_texture:
		target_slot.texture = ingredient_texture
		target_slot.set_meta("ingredient_name", source.name)
		
		if laddle.has_method("on_ingredient_added"):
			laddle.on_ingredient_added(source.name)
	cooking_ui.trigger_dialogue_for(source.name.to_lower() + "_dropped")
	print(source.name.to_lower() + "_dropped")

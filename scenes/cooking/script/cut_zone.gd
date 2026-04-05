extends Control

@onready var dodol_banana_plate: TextureRect = $"../Dodol Banana plate"
@onready var knife: NinePatchRect = $"../Knife"
@onready var cooking_ui: Control = $"../.."
@onready var dodol_serve_canvas: CanvasLayer = $"../../Dodol Serve Canvas"
@onready var done_canvas: CanvasLayer = $".."
@onready var kitchen: NinePatchRect = $"../../Kitchen"
@onready var animation_player: AnimationPlayer = $"../../Dodol Serve Canvas/AnimationPlayer"

const SHADOW_BG = preload("uid://cds1x6taldh7b")


const CUT_DODOL = preload("uid://fq32dk8kknpy")
const SLICED_HALF_DODOL = preload("uid://cdvvw2wfmkqvl")

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Also check that source actually has a texture
	return data is NinePatchRect and data.texture != null

func _drop_data(at_position: Vector2, data: Variant):
	var source = data as NinePatchRect
	
	if knife:
		knife.modulate.a = 1.0  # Reset alpha first
		knife.hide()

	if dodol_banana_plate:
		dodol_banana_plate.texture = CUT_DODOL
		knife.hide()
		
		cooking_ui.trigger_dialogue_for("dodol_serve")
		await get_tree().create_timer(2).timeout
		dodol_banana_plate.texture = SLICED_HALF_DODOL
		await get_tree().create_timer(1).timeout
		done_canvas.hide()
		kitchen.texture = SHADOW_BG
		dodol_serve_canvas.show()
		cooking_ui.trigger_dialogue_for("dodol_animation")
		animation_player.play("Dodol Serve")

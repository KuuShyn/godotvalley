extends Control

@onready var laddle_with_dodol: NinePatchRect = $"../Laddle With Dodol"
@onready var dodol_on_banana: TextureRect = $"../Dodol on banana"
@onready var cooking_ui: Control = $"../.."
@onready var pot_back: TextureRect = $"../Pot Back"
@onready var dodol_only: NinePatchRect = $"../Dodol only"
@onready var pot_front: TextureRect = $"../Pot Front"
@onready var banana_leaf: TextureRect = $"../Banana Leaf"
@onready var dodol_banana_plate: TextureRect = $"../Dodol Banana plate"
@onready var fold_dodol: Button = $"../Fold Dodol"

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS

	if dodol_on_banana:
		dodol_on_banana.hide()


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Also check that source actually has a texture
	return data is NinePatchRect and data.texture != null

func _drop_data(at_position: Vector2, data: Variant):
	var source = data as NinePatchRect
	
	
	if laddle_with_dodol:
		laddle_with_dodol.modulate.a = 1.0  # Reset alpha first
		laddle_with_dodol.hide()
	
	if dodol_on_banana:
		pot_front.hide()
		pot_back.hide()
		cooking_ui.trigger_dialogue_for("transfer_dodol_done")
		dodol_on_banana.show()
		await get_tree().create_timer(2).timeout
		self.hide()
		dodol_on_banana.hide()
		banana_leaf.hide()
		dodol_banana_plate.show()
		await get_tree().create_timer(2).timeout
		cooking_ui.trigger_dialogue_for("fold_dodol")
		fold_dodol.show()
		
		

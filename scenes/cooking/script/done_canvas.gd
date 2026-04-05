extends CanvasLayer

@onready var laddle_with_dodol: NinePatchRect = $"Laddle With Dodol"
@onready var cooking_ui: Control = $".."
@onready var start_cooking: Button = $"../Start Cooking"
@onready var dodol_only: NinePatchRect = $"Dodol only"
@onready var banana_leaf: TextureRect = $"Banana Leaf"
@onready var pot_back: TextureRect = $"Pot Back"
@onready var pot_front: TextureRect = $"Pot Front"
@onready var banana_zone: Control = $"Banana Zone"

var has_triggered := false

func _process(delta: float) -> void:
	if visible and not has_triggered:
		has_triggered = true
		run_sequence()

func run_sequence() -> void:
	pot_back.show()
	pot_front.show()
	banana_leaf.show()
	dodol_only.show()
	banana_zone.show()

	await get_tree().process_frame
	cooking_ui.trigger_dialogue_for("transfer_dodol")

	await get_tree().create_timer(2.0).timeout
	dodol_only.hide()
	laddle_with_dodol.show()

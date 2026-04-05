extends Button

const _2 = preload("uid://bmerjfu3fbbd1")
const _3 = preload("uid://gwjg8xcarihs")
@onready var cooking_ui: Control = $"../.."

@onready var dodol_banana_plate: TextureRect = $"../Dodol Banana plate"
@onready var knife: NinePatchRect = $"../Knife"
@onready var banana_zone: Control = $"../Banana Zone"
@onready var cut_zone: Control = $"../Cut Zone"

var press_count := 0

func _on_pressed() -> void:
	press_count = min(press_count + 1, 2)
	
	if press_count == 1:
		dodol_banana_plate.texture = _2
		cooking_ui.trigger_dialogue_for("fold_dodol_step2")
	elif press_count == 2:
		dodol_banana_plate.texture = _3
		cooking_ui.trigger_dialogue_for("cut_dodol")
		knife.show()
		cut_zone.show()
		hide()

extends Control

@onready var patience_bar: TextureProgressBar = $UIContainer/PatienceFrame/PatienceBar
@onready var sweet_spot_indicator: ColorRect = $UIContainer/PatienceFrame/PatienceBar/SweetSpotIndicator
@onready var completion_bar: TextureProgressBar = $UIContainer/CompletionFrame/CompletionBar
@onready var family_help_button: Button = $FamilyHelpButton


@export var sweet_spot_min: float = 40.0
@export var sweet_spot_max: float = 60.0
@export var fill_speed: float = 15.0
@export var penalty_drain: float = 5.0

@export var heat_speed: float = 45.0
@export var cool_speed: float = 30.0 

var is_holding: bool = false
var patience_level: float = 50.0
var completion_level: float = 0.0

@export var difficulty_modifier: float = 1.0
@export var reward_item: Enum.Item = Enum.Item.TOMATO_SOUP

func _ready() -> void:
	sweet_spot_min = 50.0 - (10.0 / difficulty_modifier)
	sweet_spot_max = 50.0 + (10.0 / difficulty_modifier)
	fill_speed = 15.0 / difficulty_modifier
	
	sweet_spot_indicator.anchor_left = sweet_spot_min / 100.0
	sweet_spot_indicator.anchor_right = sweet_spot_max / 100.0
	family_help_button.hide()
	family_help_button.pressed.connect(_on_family_help_pressed)
	patience_bar.value = patience_level
	completion_bar.value = completion_level

func _process(delta: float) -> void:

	if is_holding:
		patience_level += heat_speed * delta
	else:
		patience_level -= cool_speed * delta

	patience_level = clamp(patience_level, 0.0, 100.0)
	patience_bar.value = patience_level


	var in_sweet_spot = patience_level >= sweet_spot_min and patience_level <= sweet_spot_max
	if in_sweet_spot:
		completion_level += fill_speed * delta
		sweet_spot_indicator.color = Color(0.2, 1.0, 0.2, 0.6)
		patience_bar.tint_progress = Color(0.9, 0.8, 0.2, 1.0)
	else:

		completion_level -= penalty_drain * delta
		sweet_spot_indicator.color = Color(1.0, 1.0, 1.0, 0.2)
		patience_bar.tint_progress = Color(0.9, 0.4, 0.2, 1.0)
		
	completion_level = clamp(completion_level, 0.0, 100.0)
	completion_bar.value = completion_level

	if completion_level >= 100.0:
		print("Cooking Complete! Reward: ", reward_item)
		Data.change_item(reward_item, 1, false)

		if reward_item == Enum.Item.DODOL:
			print("Magical Cookbook Unlock: Dodol Maguindanao – The Sweetness of Togetherness")
		set_process(false)
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		is_holding = true
	elif event.is_action_released("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		is_holding = false

func _on_family_help_pressed() -> void:

	completion_bar.value += 20.0
	patience_level = 50.0
	patience_bar.value = patience_level
	family_help_button.hide()

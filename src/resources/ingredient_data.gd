extends Resource
class_name IngredientData

@export var item_type: Enum.Item  # Links to your Enum
@export var raw_texture: Texture2D
@export var cooked_texture: Texture2D
@export var cook_time: int = 10
@export var required_speed: String = "slow"

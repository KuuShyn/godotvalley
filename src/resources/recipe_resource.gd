extends Resource
class_name RecipeResource

@export var name: String = ""
@export var icon: Texture2D
@export var ingredients: Dictionary = {} # {Enum.Item.CHILI: 1}
@export var result_item: Enum.Item
@export var difficulty_modifier: float = 1.0

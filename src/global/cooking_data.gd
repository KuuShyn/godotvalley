extends Node

# DODOL stages - ingredients that spawn bowls
const DODOL_STAGES = {
	"Sugar": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/sugar melted.png"),
		"stir_time": 5.0,
		"required_speed": "slow",
		"next_ingredient": "CoconutMilk",
		"spawn_side": "left",
		"type": "ingredient"
	},
	"CoconutMilk": {
		"stir_texture": null,
		"stir_time": 3.0,
		"required_speed": "any",
		"next_ingredient": "PandanLeaves",
		"spawn_side": "left",
		"type": "ingredient"
	},
	"PandanLeaves": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/pandan leaves mixed with milk.png"),
		"stir_time": 4.0,
		"required_speed": "slow",
		"next_ingredient": "RiceFlour",
		"spawn_side": "right",
		"type": "ingredient"
	},
	"RiceFlour": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/rice flour mixed.png"),
		"stir_time": 4.0,
		"required_speed": "slow",
		"next_stage": "Stage8",  # Not an ingredient - auto progress
		"type": "ingredient"
	},
	# COOKING STAGES (no spawning, just auto-progress in pot)
	"Stage8": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/8.png"),
		"stir_time": 3.0,
		"required_speed": "slow",
		"next_stage": "Stage9",
		"type": "cooking_stage"
	},
	"Stage9": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/9.png"),
		"stir_time": 3.0,
		"required_speed": "slow",
		"next_stage": "Stage10",
		"type": "cooking_stage"
	},
	"Stage10": {
		"stir_texture": preload("res://graphics/cooking/Stages of dodol/10.png"),
		"stir_time": 4.0,
		"required_speed": "slow",
		"next_stage": null,  # Done!
		"type": "cooking_stage",
		"finished_dish": "Dodol",
		"dialogue_at_60_percent": "Remove the pandan leaves now—they've already released their flavor."
	}
}

# Ingredient spawn data (bowl textures)
const DODOL_INGREDIENT_SPAWNS = {
	"Sugar": {
		"texture": preload("res://graphics/cooking/Ingredients /sugar_bowl.png"),
		"spawn_texture": preload("res://graphics/cooking/Stages of dodol/sugar.png"),
		
	},
	"CoconutMilk": {
		"texture": preload("res://graphics/cooking/Ingredients /coconut_milk_bowl.png"),
		"spawn_texture": preload("res://graphics/cooking/Stages of dodol/coconut milk.png")
	},
	"PandanLeaves": {
		"texture": preload("res://graphics/cooking/Ingredients /pandan leaves.png"),
		"spawn_texture": preload("res://graphics/cooking/Stages of dodol/pandan leaves on milk.png")
	},
	"RiceFlour": {
		"texture": preload("res://graphics/cooking/Ingredients /rice_flour_bowl.png"),
		"spawn_texture": preload("res://graphics/cooking/Stages of dodol/rice flour on milk.png")
	}
}

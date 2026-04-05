extends Node2D

@export var npc_id: String
@export var npc_name: String
@export var dialog: Array[String]
@export var fin_dialog: String
@export var texture: Texture2D
@export var has_fin_animation: bool
var dialog_index: int
var player: CharacterBody2D

func start_dialog():
	print("hello player")
	

extends Control


@onready var pink_label: Label = $VBoxContainer/Pink/MarginContainer/Label
@onready var blue_label: Label = $VBoxContainer/Blue/MarginContainer/Label
@onready var pink: PanelContainer = $VBoxContainer/Pink
@onready var blue: PanelContainer = $VBoxContainer/Blue

var queue: Array = []
var is_busy: bool = false

func _ready():
	blue.hide()
	pink.hide()

func show_dialogue(text: String, speaker: String = "pink"):
	if speaker == "pink":
		pink_label.text = text
		pink.show()
	elif speaker == "blue":
		blue_label.text = "STEM: " + text
		blue.show()

func hide_dialogue(speaker: String = "pink"):
	if speaker == "pink":
		pink.hide()
	elif speaker == "blue":
		blue.hide()

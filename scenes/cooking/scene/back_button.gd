extends Button
@onready var dodol_serve_canvas: CanvasLayer = $".."

func _on_pressed() -> void:
	dodol_serve_canvas.queue_free()
	Functions.return_to_previous_scene()

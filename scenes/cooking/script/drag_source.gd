extends NinePatchRect

@export var texture_to_spawn: Texture2D  # The "naked" ingredient (no bowl)

func _get_drag_data(at_position: Vector2):
	var preview = Control.new()
	
	var preview_ninepatch = NinePatchRect.new()
	preview_ninepatch.texture = texture
	preview_ninepatch.region_rect = region_rect
	preview_ninepatch.z_index = 10
	preview_ninepatch.size = Vector2(480, 480)
	preview_ninepatch.position = -preview_ninepatch.size / 2
	
	preview.add_child(preview_ninepatch)
	set_drag_preview(preview)
	
	modulate.a = 0.1
	return self

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false

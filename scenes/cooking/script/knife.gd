extends NinePatchRect

func _get_drag_data(at_position: Vector2):
	var preview = Control.new()
	var preview_ninepatch = NinePatchRect.new()
	preview_ninepatch.texture = texture
	preview_ninepatch.region_rect = region_rect
	preview_ninepatch.size = Vector2(1920, 1080)
	preview_ninepatch.position = Vector2(-1500,-600)
	print(preview_ninepatch.position)
	preview.add_child(preview_ninepatch)
	set_drag_preview(preview)

	modulate.a = 0.1
	
	return self

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0
		

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false

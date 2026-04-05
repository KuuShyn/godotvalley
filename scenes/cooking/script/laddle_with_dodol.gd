extends NinePatchRect

func _get_drag_data(at_position: Vector2):
	var preview = Control.new()
	var preview_ninepatch = NinePatchRect.new()
	preview_ninepatch.texture = texture
	preview_ninepatch.region_rect = region_rect
	preview_ninepatch.size = Vector2(1920, 1080)
	preview_ninepatch.position = -preview_ninepatch.size / 2
	preview.add_child(preview_ninepatch)
	set_drag_preview(preview)
	
	# Make original semi-transparent while dragging
	modulate.a = 0.1
	
	return self

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		# Restore full opacity
		modulate.a = 1.0
		
		# If we weren't dropped on banana zone, we're still visible
		# The banana zone will hide us if drop was successful

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false

extends TextureRect

# The texture to show when receiving a drop (set in inspector or load dynamically)
@export var drop_result_texture: Texture2D

# Store original texture for the drag source
var original_texture: Texture2D

func _get_drag_data(at_position: Vector2):
	# Store reference to original before clearing
	original_texture = texture
	
	# Create preview
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = EXPAND_FIT_WIDTH_PROPORTIONAL  # or 1
	preview_texture.size = Vector2(480, 480)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	## Clear this slot (optional - remove if you want to keep original)
	texture = null
	
	# Return the original texture as data
	return original_texture

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D

func _drop_data(at_position: Vector2, data: Variant):
	# Instead of showing the dragged texture, show drop_result_texture
	if drop_result_texture:
		texture = drop_result_texture
	else:
		# Fallback to dragged texture if no result texture set
		texture = data

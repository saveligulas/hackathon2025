# src/symbol/symbol_display.gd - COMPLETE WITH HIGHLIGHTING

extends Node2D

@export var symbol_data: Symbol:
	set(value):
		symbol_data = value
		update_display()

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

var is_highlighted: bool = false
var original_color: Color = Color(0.028, 0.028, 0.309, 1.0)
var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)  # Green
var highlight_overlay: ColorRect  # For the highlight effect

func _ready():
	if symbol_data:
		update_display()
	create_highlight_overlay()

# NEW: Create highlight overlay on top of symbol
func create_highlight_overlay() -> void:
	highlight_overlay = ColorRect.new()
	highlight_overlay.color = Color.TRANSPARENT
	highlight_overlay.z_index = 10  # On top
	add_child(highlight_overlay)

# NEW: Set highlighting state
func set_highlighted(highlighted: bool) -> void:
	is_highlighted = highlighted
	update_highlight()
# NEW: Update visual highlighting
func update_highlight() -> void:
	if not is_node_ready() or not highlight_overlay:
		return
	
	if is_highlighted:
		# GREEN GLOW EFFECT - MODIFY THESE VALUES FOR STRENGTH
		
		# OVERLAY OPACITY - Change from 0.4 to higher (max 1.0 for fully opaque)
		highlight_overlay.color = Color(0.0, 1.0, 0.0, 0.8)  # CHANGED: 0.4 → 0.8 (STRONGER)
		
		# BRIGHTNESS MULTIPLIER - Change values to brighten more
		color_rect.self_modulate = Color(1.5, 1.7, 1.5, 1.0)  # CHANGED: 1.3, 1.5, 1.3 → 1.5, 1.7, 1.5 (BRIGHTER)
	else:
		# NORMAL STATE
		highlight_overlay.color = Color.TRANSPARENT
		color_rect.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		color_rect.color = original_color


func update_display():
	if not is_node_ready():
		return

	if symbol_data == null:
		return

	color_rect.size.x = 140
	color_rect.size.y = 157
	color_rect.color = Color(0.028, 0.028, 0.309, 1.0)
	original_color = color_rect.color

	# Update highlight overlay size to match
	if highlight_overlay:
		highlight_overlay.size = color_rect.size

	if "texture" in symbol_data and symbol_data.texture != null:
		if sprite:
			sprite.texture = symbol_data.texture
			sprite.scale = Vector2(0.5, 0.5)
			sprite.translate(Vector2(70, 78))
			sprite.show()
	else:
		print("Symbol missing texture")

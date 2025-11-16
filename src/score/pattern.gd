# src/score/pattern.gd
extends Resource
class_name Pattern

# Pattern metadata
@export var pattern_id: String = ""
@export var pattern_name: String = "Unnamed Pattern"
@export var description: String = ""

# Grid layout (5x3) - 1 = required cell, 0 = ignored
@export var cells: PackedInt32Array = [
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
]

# Target symbol for this pattern (single symbol patterns only)
@export var target_symbol_uid: String = ""

# Pattern effects (bonuses when matched)
@export var pattern_effects: Array[Effect] = []

# Required config
@export var must_fill_all_cells: bool = true  # All cells or at least one line?
@export var min_symbol_count: int = 5  # Minimum symbols needed

func get_symbol_at_position(reel: int, row: int) -> int:
	return cells[reel * 3 + row]

func is_required_cell(reel: int, row: int) -> bool:
	return get_symbol_at_position(reel, row) == 1

func apply_pattern_effects(context: Dictionary) -> Dictionary:
	"""Apply all effects from this pattern"""
	for effect in pattern_effects:
		if effect.can_apply(context):
			context = effect.apply(context)
	return context

func get_cell_count() -> int:
	var count = 0
	for cell in cells:
		if cell == 1:
			count += 1
	return count

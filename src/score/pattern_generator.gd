# src/score/pattern_generator.gd
# EASIEST WAY: Run this ONCE to auto-generate all 7 base patterns
# Copy this file, add it as an autoload, or run it manually once then delete

extends Node

# Call this once to create all patterns
func generate_all_patterns() -> void:
	print("\n=== GENERATING ALL PATTERNS ===\n")
	
	# Single symbol patterns = match ANY symbol, no targeting
	var top_line = create_pattern(
		"top_line",
		"Top Line",
		"Match symbols across the top row",
		PackedInt32Array([1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0]),
		"",  # target symbol
		25,  # bonus points
		1    # bonus mult
	)
	save_pattern(top_line, "res://patterns/top_line.tres")
	
	var middle_line = create_pattern(
		"middle_line",
		"Middle Line",
		"Match symbols across the middle row",
		PackedInt32Array([0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0]),
		"",
		25,
		1
	)
	save_pattern(middle_line, "res://patterns/middle_line.tres")
	
	var bottom_line = create_pattern(
		"bottom_line",
		"Bottom Line",
		"Match symbols across the bottom row",
		PackedInt32Array([0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1]),
		"",
		25,
		1
	)
	save_pattern(bottom_line, "res://patterns/bottom_line.tres")
	
	var diagonal_tlbr = create_pattern(
		"diagonal_tlbr",
		"Diagonal TL-BR",
		"Diagonal line from top-left to bottom-right",
		PackedInt32Array([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0]),
		"",
		35,
		2
	)
	save_pattern(diagonal_tlbr, "res://patterns/diagonal_tlbr.tres")
	
	var diagonal_trbl = create_pattern(
		"diagonal_trbl",
		"Diagonal TR-BL",
		"Diagonal line from top-right to bottom-left",
		PackedInt32Array([0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1]),
		"",
		35,
		2
	)
	save_pattern(diagonal_trbl, "res://patterns/diagonal_trbl.tres")
	
	var v_shape = create_pattern(
		"v_shape",
		"V-Shape",
		"V-shaped pattern (top→middle→bottom→middle→top)",
		PackedInt32Array([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0]),
		"",
		40,
		2
	)
	save_pattern(v_shape, "res://patterns/v_shape.tres")
	
	var reverse_v = create_pattern(
		"reverse_v_shape",
		"Reverse V-Shape",
		"Reverse V-shaped pattern (bottom→middle→top→middle→bottom)",
		PackedInt32Array([0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]),
		"",
		40,
		2
	)
	save_pattern(reverse_v, "res://patterns/reverse_v_shape.tres")
	
	print("\n✓ All 7 patterns generated!")
	print("✓ Top Line, Middle Line, Bottom Line")
	print("✓ Diagonal TL-BR, Diagonal TR-BL")
	print("✓ V-Shape, Reverse V-Shape\n")

# Helper: Create a single pattern
func create_pattern(
	pattern_id: String,
	pattern_name: String,
	description: String,
	cells: PackedInt32Array,
	target_symbol: String = "",
	bonus_points: int = 0,
	bonus_mult: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = pattern_name
	pattern.description = description
	pattern.cells = cells
	pattern.target_symbol_uid = target_symbol
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	# Add effects
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [])
		)
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [])
		)
	
	return pattern

# Helper: Save pattern to .tres file
func save_pattern(pattern: Pattern, file_path: String) -> void:
	var error = ResourceSaver.save(pattern, file_path)
	
	if error == OK:
		print("✓ Saved: %s (%s)" % [pattern.pattern_name, pattern.pattern_id])
	else:
		print("✗ Failed to save: %s (Error code: %d)" % [file_path, error])

# Optional: Auto-run on scene load
func _ready() -> void:
	# Uncomment to auto-generate when this node loads
	# generate_all_patterns()
	pass

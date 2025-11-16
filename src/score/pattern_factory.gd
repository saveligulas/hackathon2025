# src/score/pattern_factory.gd
extends Node
class_name PatternFactory

# Creates a single-symbol line pattern (top/middle/bottom)
static func create_line_pattern(
	pattern_id: String,
	pattern_name: String,
	row_index: int,  # 0=top, 1=middle, 2=bottom
	symbol_uid: String,
	bonus_points: int = 0,
	bonus_mult: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = pattern_name
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "%s line - all %s symbols" % [
		["top", "middle", "bottom"][row_index],
		symbol_uid
	]
	
	# Build cells array
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# Mark required cells (entire row)
	for reel in range(5):
		cells[reel * 3 + row_index] = 1
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	# Add effects
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	
	return pattern

# Diagonal pattern (top-left to bottom-right)
static func create_diagonal_tlbr_pattern(
	pattern_id: String,
	symbol_uid: String,
	bonus_points: int = 0,
	bonus_mult: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = "Diagonal TL-BR"
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "Diagonal from top-left to bottom-right - %s" % symbol_uid
	
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# Top-left to bottom-right: (0,0) → (1,1) → (2,2) → (3,1) → (4,0)
	cells[0 * 3 + 0] = 1  # Reel 0, Row 0 (top)
	cells[1 * 3 + 1] = 1  # Reel 1, Row 1 (middle)
	cells[2 * 3 + 2] = 1  # Reel 2, Row 2 (bottom)
	cells[3 * 3 + 1] = 1  # Reel 3, Row 1 (middle)
	cells[4 * 3 + 0] = 1  # Reel 4, Row 0 (top)
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	
	return pattern

# Diagonal pattern (top-right to bottom-left)
static func create_diagonal_trbl_pattern(
	pattern_id: String,
	symbol_uid: String,
	bonus_points: int = 0,
	bonus_mult: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = "Diagonal TR-BL"
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "Diagonal from top-right to bottom-left - %s" % symbol_uid
	
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# Top-right to bottom-left: (4,0) → (3,1) → (2,2) → (1,1) → (0,0)
	cells[4 * 3 + 0] = 1  # Reel 4, Row 0 (top)
	cells[3 * 3 + 1] = 1  # Reel 3, Row 1 (middle)
	cells[2 * 3 + 2] = 1  # Reel 2, Row 2 (bottom)
	cells[1 * 3 + 1] = 1  # Reel 1, Row 1 (middle)
	cells[0 * 3 + 0] = 1  # Reel 0, Row 0 (top)
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	
	return pattern

# V-Shape pattern (goes down then up)
static func create_v_shape_pattern(
	pattern_id: String,
	symbol_uid: String,
	bonus_mult: int = 0,
	bonus_points: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = "V-Shape"
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "V-shaped pattern - %s" % symbol_uid
	
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# V-shape: Top → Middle → Bottom → Middle → Top
	cells[0 * 3 + 0] = 1  # Reel 0, Row 0 (top)
	cells[1 * 3 + 1] = 1  # Reel 1, Row 1 (middle)
	cells[2 * 3 + 2] = 1  # Reel 2, Row 2 (bottom)
	cells[3 * 3 + 1] = 1  # Reel 3, Row 1 (middle)
	cells[4 * 3 + 0] = 1  # Reel 4, Row 0 (top)
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	
	return pattern

# Reverse V-Shape pattern (goes up then down)
static func create_reverse_v_shape_pattern(
	pattern_id: String,
	symbol_uid: String,
	bonus_mult: int = 0,
	bonus_points: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = "Reverse V-Shape"
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "Reverse V-shaped pattern - %s" % symbol_uid
	
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# Reverse V-shape: Bottom → Middle → Top → Middle → Bottom
	cells[0 * 3 + 2] = 1  # Reel 0, Row 2 (bottom)
	cells[1 * 3 + 1] = 1  # Reel 1, Row 1 (middle)
	cells[2 * 3 + 0] = 1  # Reel 2, Row 0 (top)
	cells[3 * 3 + 1] = 1  # Reel 3, Row 1 (middle)
	cells[4 * 3 + 2] = 1  # Reel 4, Row 2 (bottom)
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	
	return pattern

# All 5 symbols (complete line horizontally)
static func create_complete_line_pattern(
	pattern_id: String,
	symbol_uid: String,
	bonus_mult: int = 0,
	bonus_points: int = 0
) -> Pattern:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = "Complete Line"
	pattern.target_symbol_uid = symbol_uid
	pattern.description = "All 5 symbols in a line - %s" % symbol_uid
	
	var cells = PackedInt32Array()
	cells.resize(15)
	for i in range(15):
		cells[i] = 0
	
	# All middle row
	for reel in range(5):
		cells[reel * 3 + 1] = 1
	
	pattern.cells = cells
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	if bonus_mult > 0:
		pattern.pattern_effects.append(
			AddMultEffect.new(bonus_mult, [symbol_uid])
		)
	if bonus_points > 0:
		pattern.pattern_effects.append(
			AddPointsEffect.new(bonus_points, [symbol_uid])
		)
	
	return pattern

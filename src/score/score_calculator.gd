# src/score/score_calculator.gd
# REFACTORED: Patterns now independently match only same-symbol fills
# Only returns the BEST matched pattern (highest score)

extends Node

var patterns: Array[Pattern]

func _ready():
	patterns = PatternLoader.get_patterns()

signal pattern_completed(bool)
# ============================================================================
# MAIN CALCULATION FUNCTIONS
# ============================================================================
func calculate_score_with_state(slot_grid_result: Array, game_state) -> Dictionary:
	var divider = "=================================================================================="
	print("\n" + divider)
	print("SCORE CALCULATION STARTED")
	print(divider)

	if game_state == null:
		print("[WARNING] No game_state provided, calculating without effects")
		return calculate_score(slot_grid_result)

	print("[INFO] Active Effects: %d" % game_state.active_effects.size())
	for effect in game_state.active_effects:
		print("  - %s" % effect.effect_id)

	var base_points = 0
	var total_mult = 0
	var matched_patterns = []
	var highlight_positions = []  # Track positions to highlight

	# ========================================================================
	# PATTERN MATCHING - EACH PATTERN MATCHES INDEPENDENTLY
	# ========================================================================
	print("\n--- PATTERN MATCHING ---")
	for pattern in patterns:
		var pattern_match_result = check_pattern_match(slot_grid_result, pattern)
		
		if pattern_match_result.matched:
			print("\n✓ PATTERN MATCHED: %s" % pattern.pattern_name)
			
			# Get all matched positions for this pattern
			var positions = pattern_match_result.positions
			var pattern_points = 0
			var pattern_mult = 0
			
			# Calculate score for each symbol in the pattern
			for position in positions:
				var symbol: Symbol = slot_grid_result[position.x][position.y]
				
				if symbol:
					# Apply symbol effects
					var symbol_context = apply_symbol_effects(symbol, game_state, position, slot_grid_result)
					pattern_points += symbol_context.points
					pattern_mult += symbol_context.mult
					
					print("  [%d,%d] %s: %d pts, +%d mult" % [position.x, position.y, symbol.uid, symbol_context.points, symbol_context.mult])
			
			# Apply pattern's own effects
			var pattern_effect_context = {
				"points": pattern_points,
				"mult": pattern_mult,
				"pattern": pattern,
				"game_state": game_state
			}
			pattern_effect_context = pattern.apply_pattern_effects(pattern_effect_context)
			
			pattern_points = pattern_effect_context.get("points", pattern_points)
			pattern_mult = pattern_effect_context.get("mult", pattern_mult)
			
			# Store all matched patterns with their calculated scores
			matched_patterns.append({
				"pattern": pattern,
				"points": pattern_points,
				"mult": pattern_mult,
				"type": "pattern",
				"positions": positions,
				"score": pattern_points * max(pattern_mult, 1)  # Calculate individual score
			})
			
			print("  Pattern Total: %d pts, +%d mult (score: %d)" % [pattern_points, pattern_mult, pattern_points * max(pattern_mult, 1)])

	# ========================================================================
	# FREE FLOW MATCHING
	# ========================================================================
	print("\n--- FREE FLOWING LINES ---")
	var free_flow_results = check_free_flowing_lines(slot_grid_result)
	for result in free_flow_results:
		if result.matched:
			print("\n✓ FREE FLOW MATCHED: %s (length: %d)" % [result.get("line_type", "flowing_path"), result.length])
			print("  Path: %s" % " → ".join(result.path_description))
			
			var symbol: Symbol = result.symbol
			var flow_points = 0
			var flow_mult = 0
			
			for position in result.positions:
				var symbol_context = apply_symbol_effects(symbol, game_state, position, slot_grid_result)
				flow_points += symbol_context.points
				flow_mult += symbol_context.mult
				
				print("  [%d,%d]: %d pts, +%d mult" % [position.x, position.y, symbol_context.points, symbol_context.mult])
			
			# Store free flow matches with their calculated scores
			matched_patterns.append({
				"pattern": null,
				"points": flow_points,
				"mult": flow_mult,
				"type": "free_flow",
				"positions": result.positions,
				"score": flow_points * max(flow_mult, 1)  # Calculate individual score
			})
			
			# Play payout sound for free flow matches
			AudioManager.global_audio_player.set_stream(AudioManager.sound_payout)
			AudioManager.global_audio_player.play()
			
			print("  Flow Total: %d pts, +%d mult (score: %d)" % [flow_points, flow_mult, flow_points * max(flow_mult, 1)])
	
	# ========================================================================
	# SELECT BEST MATCH
	# ========================================================================
	var best_match = null
	var best_score = 0
	
	for match in matched_patterns:
		if match.score > best_score:
			best_score = match.score
			best_match = match
	
	# Use best match or default values if no matches
	if best_match != null:
		base_points = best_match.points
		total_mult = best_match.mult
		highlight_positions = best_match.positions.duplicate()
		
		print("\n--- BEST MATCH SELECTED ---")
		print("  Type: %s" % best_match.type)
		if best_match.pattern:
			print("  Pattern: %s" % best_match.pattern.pattern_name)
		print("  Score: %d" % best_match.score)
	else:
		print("\n--- NO MATCHES FOUND ---")
	
	if total_mult < 0:
		total_mult = 1
	
	var final_multiplier = total_mult
	var total_score = base_points * final_multiplier

	print("\n" + divider)
	print("RESULTS:")
	print("  Base Points: %d" % base_points)
	print("  Multiplier Bonus: +%d (final mult: %dx)" % [total_mult, final_multiplier])
	print("  Final Score: %d pts × %d = %d" % [base_points, final_multiplier, total_score])
	print("  Best Match Only: %s" % ("Yes" if best_match != null else "No"))
	print("  Highlight Positions: %d" % highlight_positions.size())
	print(divider + "\n")

	return {
		"total_score": total_score,
		"matched_patterns": [best_match] if best_match != null else [],  # Only return best match
		"mult": final_multiplier,
		"points": base_points,
		"highlight_positions": highlight_positions
	}

func calculate_score(slot_grid_result: Array) -> Dictionary:
	return calculate_score_with_state(slot_grid_result, null)

# ============================================================================
# PATTERN MATCHING - REFACTORED FOR INDEPENDENT SAME-SYMBOL MATCHING
# ============================================================================

func check_pattern_match(slot_grid_result: Array, pattern: Pattern) -> Dictionary:
	"""
	Check if a pattern matches the grid.
	NEW: Pattern matches INDEPENDENTLY - all required cells must have the SAME symbol.
	This means if a pattern requires 5 cells, all 5 must be the same symbol type.
	"""
	if pattern == null:
		return {"matched": false, "positions": []}
	
	var total_required_cells = pattern.get_cell_count()
	var matched_positions = []
	var first_symbol_uid = ""  # Track the first symbol we find
	
	# Check each required cell
	for reel in range(5):
		for row in range(3):
			if pattern.is_required_cell(reel, row):
				# Get symbol at this position
				var symbol: Symbol = slot_grid_result[reel][row]
				
				if symbol:
					# First symbol found - set the expected uid for this pattern match
					if first_symbol_uid == "":
						first_symbol_uid = symbol.uid
					
					# Only match if symbol is the same as the first one found
					if symbol.uid == first_symbol_uid:
						matched_positions.append(Vector2i(reel, row))
	
	# Pattern matches if ALL required cells are filled with the SAME symbol
	var matched = (matched_positions.size() >= total_required_cells)
	
	return {
		"matched": matched,
		"pattern": pattern,
		"cells_filled": matched_positions.size(),
		"total_required": total_required_cells,
		"positions": matched_positions,
		"symbol_uid": first_symbol_uid
	}

func get_pattern_positions(grid: Array, pattern: Pattern) -> Array:
	"""Get all positions required by a pattern"""
	var positions = []
	for reel in range(5):
		for row in range(3):
			if pattern.is_required_cell(reel, row):
				positions.append(Vector2i(reel, row))
	return positions

# ============================================================================
# SYMBOL EFFECT APPLICATION
# ============================================================================

func apply_symbol_effects(symbol: Symbol, game_state, position: Vector2i = Vector2i(-1, -1), grid: Array = []) -> Dictionary:
	var context = {
		"points": symbol.base_points,
		"mult": symbol.base_mult,
		"symbol": symbol,
		"position": position,
		"grid": grid,
		"game_state": game_state
	}

	if game_state == null or game_state.active_effects == null or game_state.active_effects.is_empty():
		return context

	# Sort effects by priority (highest first)
	var sorted_effects = game_state.active_effects.duplicate()
	sorted_effects.sort_custom(func(a, b): return a.priority > b.priority)

	# Apply all matching effects
	for effect in sorted_effects:
		if effect.timing == Effect.EffectTiming.DURING_SCORING and effect.target == Effect.EffectTarget.SYMBOL:
			if effect.matches(symbol) and effect.can_apply(context):
				context = effect.apply(context)
	
	return context

# ============================================================================
# FREE FLOWING LINE MATCHING
# ============================================================================

func check_free_flowing_lines(slot_grid_result: Array) -> Array:
	var results = []
	for start_row in range(3):
		var flow_result = check_flowing_path(slot_grid_result, start_row)
		if flow_result.matched:
			results.append(flow_result)
	return results

func check_flowing_path(slot_grid_result: Array, start_row: int) -> Dictionary:
	if slot_grid_result.is_empty():
		return {"matched": false}
	
	var first_reel = slot_grid_result[0] as Array
	if start_row >= first_reel.size():
		return {"matched": false}

	var starting_symbol: Symbol = first_reel[start_row]
	var matched_positions = [Vector2i(0, start_row)]
	var current_row = start_row
	var path_description = ["R0:Row%d" % start_row]

	# Try to match through all 5 reels
	for reel_index in range(1, slot_grid_result.size()):
		var reel = slot_grid_result[reel_index] as Array
		var found_match = false
		
		# Try: straight, up, down
		var directions = [
			{"offset": 0, "name": "STRAIGHT"},
			{"offset": -1, "name": "UP"},
			{"offset": 1, "name": "DOWN"}
		]

		for direction in directions:
			var test_row = current_row + direction.offset
			if test_row < 0 or test_row >= reel.size():
				continue
			
			var test_symbol: Symbol = reel[test_row]
			if test_symbol and test_symbol.uid == starting_symbol.uid:
				found_match = true
				matched_positions.append(Vector2i(reel_index, test_row))
				path_description.append("R%d:Row%d(%s)" % [reel_index, test_row, direction.name])
				current_row = test_row
				break
		
		if not found_match:
			break

	var consecutive_count = matched_positions.size()
	var is_matched = consecutive_count == 5

	return {
		"matched": is_matched,
		"symbol": starting_symbol,
		"positions": matched_positions,
		"length": consecutive_count,
		"line_type": "flowing_path",
		"start_row": start_row,
		"path_description": path_description
	}

# ============================================================================
# GRID ANALYSIS HELPERS
# ============================================================================

func analyze_grid_state(grid: Array) -> Dictionary:
	"""Analyze the grid and count symbol occurrences"""
	var symbol_counts = {}
	var positions_by_symbol = {}
	
	for col in range(grid.size()):
		for row in range(grid[col].size()):
			var symbol = grid[col][row]
			if symbol:
				var uid = symbol.uid
				if not symbol_counts.has(uid):
					symbol_counts[uid] = 0
					positions_by_symbol[uid] = []
				symbol_counts[uid] += 1
				positions_by_symbol[uid].append(Vector2i(col, row))
	
	return {
		"counts": symbol_counts,
		"positions": positions_by_symbol
	}

func is_valid_position(pos: Vector2i, grid: Array) -> bool:
	"""Check if a position is valid in the grid"""
	return pos.x >= 0 and pos.x < grid.size() and pos.y >= 0 and pos.y < grid[pos.x].size()

func get_neighbors(pos: Vector2i, grid: Array, include_diagonals: bool = true) -> Array:
	"""Get all neighbors of a position"""
	var neighbors = []
	var offsets = [
		Vector2i(-1, 0),   # Left
		Vector2i(1, 0),    # Right
		Vector2i(0, -1),   # Up
		Vector2i(0, 1)     # Down
	]
	
	if include_diagonals:
		offsets.append_array([
			Vector2i(-1, -1),  # Up-Left
			Vector2i(-1, 1),   # Down-Left
			Vector2i(1, -1),   # Up-Right
			Vector2i(1, 1)     # Down-Right
		])
	
	for offset in offsets:
		var check_pos = pos + offset
		if is_valid_position(check_pos, grid):
			neighbors.append({
				"position": check_pos,
				"symbol": grid[check_pos.x][check_pos.y]
			})
	
	return neighbors

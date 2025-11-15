# src/score/score_calculator.gd (REFACTORED WITH EFFECTS)
extends Node

var patterns: Array[Pattern]

func _ready():
	patterns = PatternLoader.get_patterns()

# Main scoring method with game state
func calculate_score_with_state(slot_grid_result: Array, game_state) -> Dictionary:
	if game_state == null:
		return calculate_score(slot_grid_result)
	
	var total_score = 0
	var matched_patterns = []
	
	# Check each pattern
	for pattern in patterns:
		var pattern_match_result = check_pattern_match(slot_grid_result, pattern)
		
		if pattern_match_result.matched:
			var pattern_score = calculate_pattern_score_with_effects(
				pattern, 
				pattern_match_result, 
				game_state
			)
			total_score += pattern_score
			
			matched_patterns.append({
				"pattern": pattern,
				"match_data": pattern_match_result,
				"score": pattern_score
			})
	
	# Free-flowing lines (if no patterns matched)
	if matched_patterns.is_empty():
		var free_flow_results = check_free_flowing_lines(slot_grid_result)
		
		for result in free_flow_results:
			if result.matched:
				var line_score = calculate_free_flow_score_with_effects(
					result, 
					slot_grid_result, 
					game_state
				)
				total_score += line_score
				
				matched_patterns.append({
					"pattern": null,
					"match_data": result,
					"score": line_score,
					"type": "free_flow"
				})
	
	return {
		"total_score": total_score,
		"matched_patterns": matched_patterns
	}

# Legacy method (no effects)
func calculate_score(slot_grid_result: Array) -> Dictionary:
	return calculate_score_with_state(slot_grid_result, null)

# ============================================
# CENTRALIZED EFFECT APPLICATION
# ============================================

# Calculate pattern score WITH effects applied
func calculate_pattern_score_with_effects(
	pattern: Pattern, 
	match_result: Dictionary, 
	game_state
) -> int:
	var points = 0
	var mult = 0
	
	# Apply effects to each symbol in the pattern
	for pattern_value in match_result.fulfilled_lines:
		var match_data = match_result.symbol_matches[pattern_value]
		var symbol: Symbol = match_data.symbol
		
		# Apply symbol-level effects (from relic effects or symbol upgrades)
		var symbol_context = apply_symbol_effects(symbol, game_state)
		
		points += symbol_context.points
		mult += symbol_context.mult
	
	# Apply global score effects (score multipliers, etc.)
	var score_context = apply_global_score_effects(points, mult, game_state)
	
	return score_context.points * score_context.mult

# Calculate free-flow score WITH effects applied
func calculate_free_flow_score_with_effects(
	match_result: Dictionary, 
	slot_grid_result: Array, 
	game_state
) -> int:
	var points = 0
	var mult = 0
	var symbol: Symbol = match_result.symbol
	
	# Apply effects to each position of the flowing line
	for position in match_result.positions:
		var symbol_context = apply_symbol_effects(symbol, game_state)
		points += symbol_context.points
		mult += symbol_context.mult
	
	# Apply global score effects
	var score_context = apply_global_score_effects(points, mult, game_state)
	
	var final_score = (score_context.points * score_context.mult) / 2
	return final_score

# HELPER: Apply all symbol-targeting effects to a single symbol
func apply_symbol_effects(symbol: Symbol, game_state) -> Dictionary:
	var context = {
		"points": symbol.base_points,
		"mult": symbol.base_mult,
		"symbol": symbol
	}
	
	# Null checks only - no .has() calls
	if game_state == null:
		return context
	
	if game_state.active_effects == null:
		return context
		
	if game_state.active_effects.is_empty():
		return context
	
	# Apply all DURING_SCORING + SYMBOL-targeting effects
	for effect in game_state.active_effects:
		if effect.timing == Effect.EffectTiming.DURING_SCORING:
			if effect.target == Effect.EffectTarget.SYMBOL:
				if effect.matches(symbol):
					context = effect.apply(context)
	
	return context

# HELPER: Apply all global score-targeting effects
func apply_global_score_effects(points: int, mult: int, game_state) -> Dictionary:
	var context = {
		"points": points,
		"mult": mult
	}
	
	# Null checks only - no .has() calls
	if game_state == null:
		return context
	
	if game_state.active_effects == null:
		return context
		
	if game_state.active_effects.is_empty():
		return context
	
	# Apply all DURING_SCORING + SCORE-targeting effects
	for effect in game_state.active_effects:
		if effect.timing == Effect.EffectTiming.DURING_SCORING:
			if effect.target == Effect.EffectTarget.SCORE:
				context = effect.apply(context)
	
	return context

# ============================================
# LEGACY SCORING (NO EFFECTS)
# ============================================

func calculate_pattern_score(pattern: Pattern, match_result: Dictionary) -> int:
	var points = 0
	var mult = 0
	
	for pattern_value in match_result.fulfilled_lines:
		var match_data = match_result.symbol_matches[pattern_value]
		var symbol: Symbol = match_data.symbol
		points += symbol.base_points
		mult += symbol.base_mult
	
	return points * mult

func calculate_free_flow_score(match_result: Dictionary, slot_grid_result: Array) -> int:
	var points = 0
	var mult = 0
	var symbol: Symbol = match_result.symbol
	
	for position in match_result.positions:
		points += symbol.base_points
		mult += symbol.base_mult
	
	var final_score = (points * mult) / 2
	return final_score

# ============================================
# PATTERN MATCHING (UNCHANGED)
# ============================================

func check_pattern_match(slot_grid_result: Array, pattern: Pattern) -> Dictionary:
	var symbol_matches = {}
	var required_symbol_count = pattern.get_pattern_symbol_count()
	
	for reel_index in slot_grid_result.size():
		var reel = slot_grid_result[reel_index] as Array
		
		for symbol_index in reel.size():
			var symbol: Symbol = reel[symbol_index]
			var pattern_value = pattern.get_symbol_at_position(reel_index, symbol_index)
			
			if pattern_value > 0:
				if not symbol_matches.has(pattern_value):
					symbol_matches[pattern_value] = {
						"symbol": symbol,
						"positions": [],
						"count": 0
					}
				
				var match_data = symbol_matches[pattern_value]
				if match_data.count == 0 or match_data.symbol.uid == symbol.uid:
					match_data.positions.append(Vector2i(reel_index, symbol_index))
					match_data.count += 1
					if match_data.count == 1:
						match_data.symbol = symbol
	
	var matched = false
	var fulfilled_lines = []
	
	if pattern.has_to_fulfill_all_symbols():
		matched = symbol_matches.size() == required_symbol_count
		if matched:
			for pattern_value in symbol_matches.keys():
				var match_data = symbol_matches[pattern_value]
				var required_positions = count_pattern_value_occurrences(pattern, pattern_value)
				if match_data.count < required_positions:
					matched = false
					break
				else:
					fulfilled_lines.append(pattern_value)
	else:
		for pattern_value in symbol_matches.keys():
			var match_data = symbol_matches[pattern_value]
			var required_positions = count_pattern_value_occurrences(pattern, pattern_value)
			if match_data.count >= required_positions:
				matched = true
				fulfilled_lines.append(pattern_value)
	
	return {
		"matched": matched,
		"symbol_matches": symbol_matches,
		"fulfilled_lines": fulfilled_lines
	}

func count_pattern_value_occurrences(pattern: Pattern, value: int) -> int:
	var count = 0
	for cell in pattern.cells:
		if cell == value:
			count += 1
	return count

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
	
	for reel_index in range(1, slot_grid_result.size()):
		var reel = slot_grid_result[reel_index] as Array
		var found_match = false
		
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
			
			if test_symbol.uid == starting_symbol.uid:
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

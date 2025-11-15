extends Node

var patterns: Array[Pattern]

func _ready():
	patterns = PatternLoader.get_patterns()

func calculate_score(slot_grid_result: Array) -> Dictionary:
	var total_score = 0
	var matched_patterns = []
	
	# Check each pattern
	for pattern in patterns:
		var pattern_match_result = check_pattern_match(slot_grid_result, pattern)
		
		if pattern_match_result.matched:
			# Calculate score for this pattern (you'll implement this)
			var pattern_score = calculate_pattern_score(pattern, pattern_match_result)
			total_score += pattern_score
			
			matched_patterns.append({
				"pattern": pattern,
				"match_data": pattern_match_result,
				"score": pattern_score
			})
	
	return {
		"total_score": total_score,
		"matched_patterns": matched_patterns
	}

func check_pattern_match(slot_grid_result: Array, pattern: Pattern) -> Dictionary:
	var symbol_matches = {}  # Dictionary to track which symbols match pattern positions
	var required_symbol_count = pattern.get_pattern_symbol_count()
	
	# Iterate through each reel (column)
	for reel_index in slot_grid_result.size():
		var reel = slot_grid_result[reel_index] as Array
		
		# Check each symbol position in the reel (row)
		for symbol_index in reel.size():
			var symbol: Symbol = reel[symbol_index]
			var pattern_value = pattern.get_symbol_at_position(reel_index, symbol_index)
			
			# If this position is part of the pattern (non-zero value)
			if pattern_value > 0:
				# Initialize tracking for this pattern symbol if not exists
				if not symbol_matches.has(pattern_value):
					symbol_matches[pattern_value] = {
						"symbol": symbol,
						"positions": [],
						"count": 0
					}
				
				# Check if this is the first symbol for this pattern value or if it matches
				var match_data = symbol_matches[pattern_value]
				if match_data.count == 0 or match_data.symbol.uid == symbol.uid:
					match_data.positions.append(Vector2i(reel_index, symbol_index))
					match_data.count += 1
					if match_data.count == 1:
						match_data.symbol = symbol
	
	# Determine if pattern is matched based on hasToFulfillAllSymbols
	var matched = false
	var fulfilled_lines = []
	
	if pattern.has_to_fulfill_all_symbols():
		# All pattern symbol groups must be fulfilled
		matched = symbol_matches.size() == required_symbol_count
		if matched:
			for pattern_value in symbol_matches.keys():
				var match_data = symbol_matches[pattern_value]
				# Count how many positions this pattern value requires
				var required_positions = count_pattern_value_occurrences(pattern, pattern_value)
				if match_data.count < required_positions:
					matched = false
					break
				else:
					fulfilled_lines.append(pattern_value)
	else:
		# At least one pattern symbol group must be fulfilled
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

# Override this function to implement your scoring logic
func calculate_pattern_score(pattern: Pattern, match_result: Dictionary) -> int:
	# This is where you'll implement your scoring logic
	# You have access to:
	# - pattern: The matched pattern
	# - match_result: Contains:
	#   - matched: bool
	#   - symbol_matches: Dictionary with symbol data per pattern value
	#   - fulfilled_lines: Array of which pattern lines were fulfilled
	
	# Example placeholder:
	var points = 0
	var mult = 0
	
	# You can access the matched symbols like this:
	for pattern_value in match_result.fulfilled_lines:
		var match_data = match_result.symbol_matches[pattern_value]
		var symbol = match_data.symbol
		points += symbol.points
		mult += symbol.mult
	
	return points * mult

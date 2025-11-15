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

    # If no patterns matched, check for free-flowing lines
    if matched_patterns.is_empty():
        print("[FREE FLOW] No patterns matched, checking free-flowing lines...")
        var free_flow_results = check_free_flowing_lines(slot_grid_result)

        for result in free_flow_results:
            if result.matched:
                var line_score = calculate_free_flow_score(result, slot_grid_result)
                total_score += line_score

                matched_patterns.append({
                    "pattern": null,  # No pattern, it's a free flow
                    "match_data": result,
                    "score": line_score,
                    "type": "free_flow"
                })

    return {
        "total_score": total_score,
        "matched_patterns": matched_patterns
    }

func check_free_flowing_lines(slot_grid_result: Array) -> Array:
    print("[FREE FLOW] Starting free-flowing line check...")
    var results = []

    # Check each starting position in the first reel (rows 0, 1, 2)
    for start_row in range(3):
        print("[FREE FLOW] Checking starting position: Row %d" % start_row)

        # Check all possible flowing paths from this starting position
        var flow_result = check_flowing_path(slot_grid_result, start_row)
        if flow_result.matched:
            print("[FREE FLOW] ✓ Flowing path matched from row %d: %d symbols" % [start_row, flow_result.length])
            print("[FREE FLOW]   Path: %s" % str(flow_result.positions))
            results.append(flow_result)
        else:
            print("[FREE FLOW] ✗ No flowing path from row %d" % start_row)

    print("[FREE FLOW] Total free-flowing lines found: %d" % results.size())
    return results

func check_flowing_path(slot_grid_result: Array, start_row: int) -> Dictionary:
    print("[FREE FLOW - PATH] Starting from row %d" % start_row)

    if slot_grid_result.is_empty():
        print("[FREE FLOW - PATH] Empty grid!")
        return {"matched": false}

    var first_reel = slot_grid_result[0] as Array
    if start_row >= first_reel.size():
        print("[FREE FLOW - PATH] Start row out of bounds!")
        return {"matched": false}

    var starting_symbol: Symbol = first_reel[start_row]
    var matched_positions = [Vector2i(0, start_row)]
    var current_row = start_row
    var path_description = ["R0:Row%d" % start_row]

    print("[FREE FLOW - PATH] Starting symbol UID: %s" % starting_symbol.uid)

    # MUST go left to right, checking each reel consecutively
    for reel_index in range(1, slot_grid_result.size()):
        var reel = slot_grid_result[reel_index] as Array
        var found_match = false
        var next_row = -1
        var direction_taken = ""

        # Try three possible directions: straight (0), up (-1), down (+1)
        var directions = [
            {"offset": 0, "name": "STRAIGHT"},
            {"offset": -1, "name": "UP"},
            {"offset": 1, "name": "DOWN"}
        ]

        for direction in directions:
            var test_row = current_row + direction.offset

            # Check if this direction is valid (within bounds)
            if test_row < 0 or test_row >= reel.size():
                print("[FREE FLOW - PATH] Reel %d: %s to row %d - OUT OF BOUNDS" % [reel_index, direction.name, test_row])
                continue

            var test_symbol: Symbol = reel[test_row]
            print("[FREE FLOW - PATH] Reel %d: %s to row %d - Symbol UID: %s" % [reel_index, direction.name, test_row, test_symbol.uid])

            # Check if symbol matches
            if test_symbol.uid == starting_symbol.uid:
                print("[FREE FLOW - PATH] ✓ MATCH found going %s!" % direction.name)
                found_match = true
                next_row = test_row
                direction_taken = direction.name
                matched_positions.append(Vector2i(reel_index, test_row))
                path_description.append("R%d:Row%d(%s)" % [reel_index, test_row, direction_taken])
                current_row = test_row
                break  # Take the first matching direction (prioritize straight, then up, then down)
            else:
                print("[FREE FLOW - PATH] ✗ No match (got %s, need %s)" % [test_symbol.uid, starting_symbol.uid])

        # CRITICAL: If no match found in THIS reel, the chain MUST break
        # We cannot skip reels - must have consecutive left-to-right matches
        if not found_match:
            print("[FREE FLOW - PATH] CHAIN BROKEN: No matching symbol in reel %d" % reel_index)
            break

    var consecutive_count = matched_positions.size()
    # Flowing path MUST connect all 5 reels
    var is_matched = consecutive_count == 5

    if consecutive_count < 5:
        print("[FREE FLOW - PATH] Final result: FAILED - Only %d/5 reels connected (need all 5)" % consecutive_count)
    else:
        print("[FREE FLOW - PATH] Final result: MATCHED - All 5 reels connected!")
    print("[FREE FLOW - PATH] Full path: %s" % " -> ".join(path_description))

    return {
        "matched": is_matched,
        "symbol": starting_symbol,
        "positions": matched_positions,
        "length": consecutive_count,
        "line_type": "flowing_path",
        "start_row": start_row,
        "path_description": path_description
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

# Override this function to implement your scoring logic for patterns
func calculate_pattern_score(pattern: Pattern, match_result: Dictionary) -> int:
    var points = 0
    var mult = 0

    for pattern_value in match_result.fulfilled_lines:
        var match_data = match_result.symbol_matches[pattern_value]
        var symbol = match_data.symbol
        points += symbol.points
        mult += symbol.mult

    return points * mult

# Scoring logic for free-flowing lines
func calculate_free_flow_score(match_result: Dictionary, slot_grid_result: Array) -> int:
    var points = 0
    var mult = 0
    var symbol = match_result.symbol

    for position in match_result.positions:
        points += symbol.points
        mult += symbol.mult

    var final_score = (points * mult) / 2

    print("[FREE FLOW - SCORE] Symbol: %s" % symbol.uid)
    print("[FREE FLOW - SCORE] Total points: %d, Total mult: %d" % [points, mult])
    print("[FREE FLOW - SCORE] Path taken: %s" % " -> ".join(match_result.path_description))
    print("[FREE FLOW - SCORE] Calculating score for %s line with %d symbols" % [match_result.line_type, match_result.length])
    print("[FREE FLOW - SCORE] Final score: (%d * %d) / 2 = %d" % [points, mult, final_score])

    return final_score

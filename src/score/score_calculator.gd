# src/score/score_calculator.gd
extends Node

var patterns: Array[Pattern]

func _ready():
    patterns = PatternLoader.get_patterns()

func calculate_score_with_state(slot_grid_result: Array, game_state) -> Dictionary:
    var divider = "=================================================================================="
    print("\n" + divider)
    print("SCORE CALCULATION STARTED")
    print(divider)

    if game_state == null:
        print("[WARNING] No game_state provided, calculating without effects")
        return calculate_score(slot_grid_result)

    var base_points = 0
    var total_mult = 0
    var matched_patterns = []

    # PATTERN MATCHING
    for pattern in patterns:
        var pattern_match_result = check_pattern_match(slot_grid_result, pattern)
        if pattern_match_result.matched:
            var pattern_points = 0
            var pattern_mult = 0

            for pattern_value in pattern_match_result.fulfilled_lines:
                var match_data = pattern_match_result.symbol_matches[pattern_value]
                var symbol: Symbol = match_data.symbol

                for position in match_data.positions:
                    var symbol_context = apply_symbol_effects(symbol, game_state, position, slot_grid_result)
                    pattern_points += symbol_context.points
                    pattern_mult += symbol_context.mult

            base_points += pattern_points
            total_mult += pattern_mult

            matched_patterns.append({"pattern": pattern, "points": pattern_points, "mult": pattern_mult})

    # FREE FLOW
    var free_flow_results = check_free_flowing_lines(slot_grid_result)
    for result in free_flow_results:
        if result.matched:
            var symbol: Symbol = result.symbol
            var flow_points = 0
            var flow_mult = 0

            for position in result.positions:
                var symbol_context = apply_symbol_effects(symbol, game_state, position, slot_grid_result)
                flow_points += symbol_context.points
                flow_mult += symbol_context.mult

            base_points += flow_points
            total_mult += flow_mult

            matched_patterns.append({"pattern": null, "points": flow_points, "mult": flow_mult, "type": "free_flow"})

    # FINAL CALCULATION
    if total_mult <= 0:
        total_mult = 1

    var total_score = base_points * total_mult

    print("FINAL: %d pts × %d mult = %d" % [base_points, total_mult, total_score])
    print(divider + "\n")

    return {"total_score": total_score, "matched_patterns": matched_patterns, "mult": total_mult, "points": base_points}

func apply_symbol_effects(symbol: Symbol, game_state, position: Vector2i = Vector2i(-1, -1), grid: Array = []) -> Dictionary:
    var context = {"points": symbol.base_points, "mult": symbol.base_mult, "symbol": symbol, "position": position, "grid": grid}

    if game_state == null or game_state.active_effects == null or game_state.active_effects.is_empty():
        return context

    var sorted_effects = game_state.active_effects.duplicate()
    sorted_effects.sort_custom(func(a, b): return a.priority > b.priority)

    for effect in sorted_effects:
        if effect.timing == Effect.EffectTiming.DURING_SCORING and effect.target == Effect.EffectTarget.SYMBOL:
            if effect.matches(symbol) and effect.can_apply(context):
                context = effect.apply(context)

    # CRITICAL FIX: Convert 0 or negative mult to 1 AFTER all effects
    if context.mult < 0:
        context.mult = 0

    return context

# Grid helpers
func analyze_grid_state(grid: Array) -> Dictionary:
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
    return {"counts": symbol_counts, "positions": positions_by_symbol}

func is_valid_position(pos: Vector2i, grid: Array) -> bool:
    return pos.x >= 0 and pos.x < grid.size() and pos.y >= 0 and pos.y < grid[pos.x].size()

func get_neighbors(pos: Vector2i, grid: Array, include_diagonals: bool = true) -> Array:
    var neighbors = []
    var offsets = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]
    if include_diagonals:
        offsets.append_array([Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(1, 1)])
    for offset in offsets:
        var check_pos = pos + offset
        if is_valid_position(check_pos, grid):
            neighbors.append({"position": check_pos, "symbol": grid[check_pos.x][check_pos.y]})
    return neighbors

func calculate_score(slot_grid_result: Array) -> Dictionary:
    return calculate_score_with_state(slot_grid_result, null)

# Pattern matching (unchanged)
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
                    symbol_matches[pattern_value] = {"symbol": symbol, "positions": [], "count": 0}
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

    return {"matched": matched, "symbol_matches": symbol_matches, "fulfilled_lines": fulfilled_lines}

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
        var directions = [{"offset": 0, "name": "STRAIGHT"}, {"offset": -1, "name": "UP"}, {"offset": 1, "name": "DOWN"}]

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

    return {"matched": is_matched, "symbol": starting_symbol, "positions": matched_positions, "length": consecutive_count, "line_type": "flowing_path", "start_row": start_row, "path_description": path_description}

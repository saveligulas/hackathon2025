# src/effects/rerollSymbolEffect.gd
extends Effect
class_name RerollSymbolEffect

@export var reroll_symbol_uid: String = ""
@export var replace_with_uid: String = ""  # Empty = random

func _init(from_uid: String, to_uid: String = ""):
	reroll_symbol_uid = from_uid
	replace_with_uid = to_uid
	effect_id = "reroll_%s" % from_uid
	timing = EffectTiming.AFTER_SPIN
	target = EffectTarget.GRID
	description = "Reroll %s symbols" % from_uid
	if to_uid != "":
		description += " into %s" % to_uid

func apply(context: Dictionary) -> Dictionary:
	if not context.has("grid") or not context.has("game_state"):
		return context
	
	var grid = context.grid
	var game_state = context.game_state
	
	# Get available symbols from game state
	if not game_state or not game_state.player_data:
		return context
	
	var available_symbols = []
	if game_state.player_data.reels.size() > 0:
		available_symbols = game_state.player_data.reels[0].symbols.duplicate()
	
	if available_symbols.is_empty():
		return context
	
	# Reroll matching symbols in the grid
	for col in range(grid.size()):
		for row in range(grid[col].size()):
			var symbol = grid[col][row]
			if symbol and symbol.uid == reroll_symbol_uid:
				if replace_with_uid != "":
					# Find and use specific replacement
					for replacement in available_symbols:
						if replacement.uid == replace_with_uid:
							grid[col][row] = replacement
							break
				else:
					# Random replacement
					grid[col][row] = available_symbols[randi() % available_symbols.size()]
	
	context.grid = grid
	return context

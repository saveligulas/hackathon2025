extends Resource
class_name Pattern

# Reel ordered in reels so first 3 indexes are a reel and so on
@export var cells: PackedInt32Array = [
	0,0,0,0,0,
	0,0,0,0,0,
	0,0,0,0,0,
]
@export var symbol_count: int
@export var hasToFulfillAllSymbols: bool

func has_to_fulfill_all_symbols():
	return hasToFulfillAllSymbols

func get_pattern_symbol_count():
	return symbol_count
	
func get_symbol_at_position(reel: int, symbol: int):
	return cells[reel * 3 + symbol]

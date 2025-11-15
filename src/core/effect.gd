# src/core/effect.gd
class_name Effect
extends Resource

enum EffectTiming {
	BEFORE_SPIN,
	AFTER_SPIN,
	DURING_SCORING,
	AFTER_SCORING
}

enum EffectTarget {
	SYMBOL,    # Affects individual symbol
	REEL,      # Affects a full reel
	GRID,      # Affects the entire grid
	SCORE      # Works globally during scoring
}

@export var effect_id: String
@export var timing: EffectTiming = EffectTiming.DURING_SCORING
@export var target: EffectTarget = EffectTarget.SYMBOL
@export var description: String = ""

# NEW: Symbol filtering
@export var target_symbol_uids: Array[String] = []  # Empty = affects all symbols
@export var exclude_symbol_uids: Array[String] = []

func apply(context: Dictionary) -> Dictionary:
	# Each subclass implements its logic
	return context

func can_apply(context: Dictionary) -> bool:
	# Override in subclasses for conditional effects
	return true

func matches(symbol: Symbol) -> bool:
	# Check if this effect applies to the given symbol
	
	# If targeting specific symbols
	if target_symbol_uids.size() > 0:
		if not symbol.uid in target_symbol_uids:
			return false
	
	# If excluding specific symbols
	if exclude_symbol_uids.size() > 0:
		if symbol.uid in exclude_symbol_uids:
			return false
	
	return true

# src/effects/multiplyPointsEffect.gd (VERIFY THIS)
extends Effect
class_name MultiplyPointsEffect

@export var multiplier: float = 2.0

func _init(mult: float = 2.0, symbol_uids: Array[String] = []):
	multiplier = mult
	target_symbol_uids = symbol_uids  # ← MUST be set correctly
	effect_id = "multiply_points_%.1fx" % mult
	if symbol_uids.size() > 0:
		effect_id += "_" + "_".join(symbol_uids)
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	description = "×%.1f points" % mult
	if symbol_uids.size() > 0:
		description += " for " + ", ".join(symbol_uids)

func apply(context: Dictionary) -> Dictionary:
	if context.has("points"):
		context.points = int(context.points * multiplier)
	return context

# ADD THIS matches() method if missing:
func matches(symbol: Symbol) -> bool:
	# If targeting specific symbols
	if target_symbol_uids.size() > 0:
		if not symbol.uid in target_symbol_uids:
			return false
	
	# If excluding specific symbols
	if exclude_symbol_uids.size() > 0:
		if symbol.uid in exclude_symbol_uids:
			return false
	
	return true

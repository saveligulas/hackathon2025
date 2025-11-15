# src/effects/multiplyPointsEffect.gd
extends Effect
class_name MultiplyPointsEffect

@export var multiplier: float = 2.0

func _init(mult: float = 2.0, symbol_uids: Array[String] = []):
	multiplier = mult
	var target_symbol_uids = symbol_uids
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

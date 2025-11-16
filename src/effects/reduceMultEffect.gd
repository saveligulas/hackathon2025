# src/effects/reduceMultEffect.gd
extends Effect
class_name ReduceMultEffect

@export var mult_reduction: int = 1

func _init(reduction: int = 1, symbol_uids: Array[String] = []):
	mult_reduction = reduction
	target_symbol_uids = symbol_uids
	effect_id = "reduce_mult_%d" % reduction
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	priority = -10  # Apply after positive effects
	description = "-%d mult" % reduction
	if symbol_uids.size() > 0:
		description += " for " + ", ".join(symbol_uids)

func apply(context: Dictionary) -> Dictionary:
	if context.has("mult"):
		# FIXED: Allow mult to go to 0 (don't prevent with max(1, ...))
		context.mult -= mult_reduction
	return context

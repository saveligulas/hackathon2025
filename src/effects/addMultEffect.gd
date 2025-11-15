# src/effects/addMultEffect.gd
extends Effect
class_name AddMultEffect

@export var mult_to_add: int = 1

func _init(value: int = 1, symbol_uids: Array[String] = []):
	mult_to_add = value
	target_symbol_uids = symbol_uids
	effect_id = "add_mult_%d" % value
	if symbol_uids.size() > 0:
		effect_id += "_" + "_".join(symbol_uids)
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	description = "+%d mult" % value
	if symbol_uids.size() > 0:
		description += " for " + ", ".join(symbol_uids)

func apply(context: Dictionary) -> Dictionary:
	if context.has("mult"):
		context.mult += mult_to_add
	return context

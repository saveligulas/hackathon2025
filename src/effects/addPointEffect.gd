# src/effects/AddPointsEffect.gd
extends Effect
class_name AddPointsEffect

@export var points_to_add: int = 1
@export var symbol_uid: String = "" # optional filter, empty means all

func _init(value: int = 1):
	points_to_add = value
	effect_id = "add_points_%d" % value
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	description = "+%d points to symbol" % value

func apply(context: Dictionary) -> Dictionary:
	if context.has("points"):
		context.points += points_to_add * context.get("stack_count", 1)
	return context

func matches(symbol: Symbol) -> bool:
	return symbol_uid == "" or symbol.uid == symbol_uid

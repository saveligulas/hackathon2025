# src/effects/addPointEffect.gd
extends Effect
class_name AddPointsEffect

@export var points_to_add: int = 1

func _init(value: int = 1, symbol_uids: Array[String] = []):
    points_to_add = value
    target_symbol_uids = symbol_uids
    effect_id = "add_points_%d" % value
    if symbol_uids.size() > 0:
        effect_id += "_" + "_".join(symbol_uids)
    timing = EffectTiming.DURING_SCORING
    target = EffectTarget.SYMBOL
    description = "+%d points" % value
    if symbol_uids.size() > 0:
        description += " for " + ", ".join(symbol_uids)

func apply(context: Dictionary) -> Dictionary:
    if context.has("points"):
        context.points += points_to_add
    return context

func matches(symbol: Symbol) -> bool:
    # Use the base class filtering logic

    # If targeting specific symbols
    if target_symbol_uids.size() > 0:
        if not symbol.uid in target_symbol_uids:
            return false

    # If excluding specific symbols
    if exclude_symbol_uids.size() > 0:
        if symbol.uid in exclude_symbol_uids:
            return false

    return true

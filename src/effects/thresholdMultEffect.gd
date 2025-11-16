# src/effects/thresholdMultEffect.gd
extends Effect
class_name ThresholdMultEffect

@export var required_symbol_uid: String = "palm"
@export var required_count: int = 4
@export var bonus_mult: int = 3

func _init(symbol_uid: String = "palm", threshold: int = 4, mult: int = 3):
	required_symbol_uid = symbol_uid
	required_count = threshold
	bonus_mult = mult
	effect_id = "threshold_mult_%s_%d" % [symbol_uid, threshold]
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	priority = 100
	description = "+%d mult to all if %d+ %s on board" % [mult, threshold, symbol_uid]

func can_apply(context: Dictionary) -> bool:
	if not context.has("grid"):
		return false
	
	var grid = context.grid
	
	# FIX: Get ScoreCalculator from GameManager
	var game_manager = GameManager
	if not game_manager.has_node("ScoreCalculator"):
		return false
	
	var score_calc = game_manager.get_node("ScoreCalculator")
	var grid_state = score_calc.analyze_grid_state(grid)
	
	var count = grid_state.counts.get(required_symbol_uid, 0)
	return count >= required_count

func apply(context: Dictionary) -> Dictionary:
	context.mult += bonus_mult
	return context

# src/effects/thresholdBonusEffect.gd
extends Effect
class_name ThresholdBonusEffect

@export var required_symbol_uid: String = "currency"
@export var required_count: int = 3
@export var bonus_points: int = 50

func _init(symbol_uid: String = "currency", threshold: int = 3, points: int = 50):
	required_symbol_uid = symbol_uid
	required_count = threshold
	bonus_points = points
	effect_id = "threshold_%s_%d" % [symbol_uid, threshold]
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	priority = 100
	description = "+%d points to all if %d+ %s on board" % [points, threshold, symbol_uid]

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
	context.points += bonus_points
	return context

# src/effects/adjacentBonusEffect.gd
extends Effect
class_name AdjacentBonusEffect

@export var target_neighbor_uid: String = "eye"
@export var bonus_mult: int = 1

func _init(neighbor_uid: String = "eye", mult_bonus: int = 1):
	target_neighbor_uid = neighbor_uid
	bonus_mult = mult_bonus
	effect_id = "adjacent_bonus_%s" % neighbor_uid
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	priority = 50
	description = "+%d mult per adjacent %s symbol" % [mult_bonus, neighbor_uid]

func apply(context: Dictionary) -> Dictionary:
	# Check if we have grid context
	if not context.has("position") or not context.has("grid"):
		return context
	
	if not context.has("game_state"):
		return context
	
	var pos = context.position
	var grid = context.grid
	
	# FIX: Get ScoreCalculator from GameManager Node, NOT from game_state
	var game_manager = GameManager
	if not game_manager.has_node("ScoreCalculator"):
		push_error("ScoreCalculator not found in GameManager!")
		return context
	
	var score_calc = game_manager.get_node("ScoreCalculator")
	
	# Count adjacent matching symbols
	var adjacent_count = 0
	var neighbors = score_calc.get_neighbors(pos, grid, true)
	
	for neighbor in neighbors:
		if neighbor.symbol and neighbor.symbol.uid == target_neighbor_uid:
			adjacent_count += 1
	
	# Add mult bonus
	context.mult += adjacent_count * bonus_mult
	
	return context

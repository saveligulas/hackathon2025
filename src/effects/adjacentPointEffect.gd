# src/effects/adjacentPointsEffect.gd
extends Effect
class_name AdjacentPointsEffect

@export var target_neighbor_uid: String = "man"
@export var bonus_points: int = 2

func _init(neighbor_uid: String = "man", points_bonus: int = 2):
	target_neighbor_uid = neighbor_uid
	bonus_points = points_bonus
	effect_id = "adjacent_points_%s" % neighbor_uid
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SYMBOL
	priority = 50
	description = "+%d points per adjacent %s symbol" % [points_bonus, neighbor_uid]

func apply(context: Dictionary) -> Dictionary:
	if not context.has("position") or not context.has("grid"):
		return context
	
	if not context.has("game_state"):
		return context
	
	var pos = context.position
	var grid = context.grid
	
	# Get ScoreCalculator from GameManager
	var game_manager = GameManager
	if not game_manager.has_node("ScoreCalculator"):
		push_error("ScoreCalculator not found in GameManager!")
		return context
	
	var score_calc = game_manager.get_node("ScoreCalculator")
	
	var adjacent_count = 0
	var neighbors = score_calc.get_neighbors(pos, grid, true)
	
	for neighbor in neighbors:
		if neighbor.symbol and neighbor.symbol.uid == target_neighbor_uid:
			adjacent_count += 1
	
	context.points += adjacent_count * bonus_points
	return context

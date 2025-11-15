# src/effects/patternBonusEffect.gd
extends Effect
class_name PatternBonusEffect

@export var bonus_points: int = 50
@export var min_patterns_required: int = 2

func _init(points: int = 50, min_patterns: int = 2):
	bonus_points = points
	min_patterns_required = min_patterns
	effect_id = "pattern_bonus_%d_pts" % points
	timing = EffectTiming.AFTER_SCORING
	target = EffectTarget.SCORE
	description = "+%d points when %d+ patterns match" % [points, min_patterns]

func can_apply(context: Dictionary) -> bool:
	if not context.has("score"):
		return false
	var score_data = context.score
	if not score_data.has("matched_patterns"):
		return false
	return score_data.matched_patterns.size() >= min_patterns_required

func apply(context: Dictionary) -> Dictionary:
	if context.has("score"):
		var score_data = context.score
		if score_data.has("total_score"):
			score_data.total_score += bonus_points
	return context

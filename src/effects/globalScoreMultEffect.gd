# src/effects/globalScoreMultEffect.gd
extends Effect
class_name GlobalScoreMultEffect

@export var score_multiplier: float = 1.5

func _init(mult: float = 1.5):
	score_multiplier = mult
	effect_id = "global_score_mult_%.1f" % mult
	timing = EffectTiming.DURING_SCORING
	target = EffectTarget.SCORE
	description = "×%.1f to final score" % mult

func apply(context: Dictionary) -> Dictionary:
	if context.has("points"):
		context.points = int(context.points * score_multiplier)
	if context.has("mult"):
		context.mult = int(context.mult * score_multiplier)
	return context

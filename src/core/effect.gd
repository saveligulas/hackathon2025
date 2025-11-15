# src/effects/Effect.gd

class_name Effect
extends Resource

enum EffectTiming {
	BEFORE_SPIN,
	AFTER_SPIN,
	DURING_SCORING,
	AFTER_SCORING
}

enum EffectTarget {
	SYMBOL,    # Affects individual symbol
	REEL,      # Affects a full reel
	GRID,      # Affects the entire grid
	SCORE      # Works globally during scoring
}

@export var effect_id: String
@export var timing: EffectTiming = EffectTiming.DURING_SCORING
@export var target: EffectTarget = EffectTarget.SYMBOL
@export var description: String = ""

func apply(context: Dictionary) -> Dictionary:
	# Each subclass implements its logic
	return context

func matches(symbol: Symbol) -> bool:
	return true  # default: all

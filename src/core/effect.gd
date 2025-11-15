# src/core/Effect.gd
class_name Effect
extends Resource

enum EffectTiming {
	BEFORE_SPIN,      # Before symbols are determined
	AFTER_SPIN,       # After grid is generated, before scoring
	DURING_SCORING,   # Modify score calculation
	AFTER_SCORING     # After final score
}

enum EffectTarget {
	SYMBOL,           # Affects individual symbol
	REEL,             # Affects entire reel
	GRID,             # Affects entire grid
	SCORE,            # Affects score calculation
	GLOBAL            # Game-wide effect
}

@export var effect_id: String
@export var effect_name: String
@export var description: String
@export var timing: EffectTiming
@export var target: EffectTarget
@export var stack_count: int = 1
@export var is_permanent: bool = false

# Override in derived classes
func apply(context: Dictionary) -> Dictionary:
	push_error("apply() must be implemented in derived class")
	return context

func can_apply(context: Dictionary) -> bool:
	return true

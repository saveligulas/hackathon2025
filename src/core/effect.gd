# src/core/effect.gd
class_name Effect
extends Resource

enum EffectTiming {
    BEFORE_SPIN,
    AFTER_SPIN,
    DURING_SCORING,
    AFTER_SCORING
}

enum EffectTarget {
    SYMBOL,
    REEL,
    GRID,
    SCORE
}

@export var effect_id: String
@export var timing: EffectTiming = EffectTiming.DURING_SCORING
@export var target: EffectTarget = EffectTarget.SYMBOL
@export var description: String = ""
@export var priority: int = 0  # NEW: Higher priority = applies first

# Symbol filtering
@export var target_symbol_uids: Array[String] = []
@export var exclude_symbol_uids: Array[String] = []

# NEW: Persistent state for stacking effects
var persistent_state: Dictionary = {}

func apply(context: Dictionary) -> Dictionary:
    return context

func can_apply(context: Dictionary) -> bool:
    return true

func matches(symbol: Symbol) -> bool:
    if target_symbol_uids.size() > 0:
        if not symbol.uid in target_symbol_uids:
            return false

    if exclude_symbol_uids.size() > 0:
        if symbol.uid in exclude_symbol_uids:
            return false

    return true

# NEW: Reset persistent state (call between runs/rounds)
func reset_state_effect():
    persistent_state.clear()

# NEW: Helper for stacking effects
func increment_stack(key: String = "stack", max_stacks: int = 999):
    if not persistent_state.has(key):
        persistent_state[key] = 0
    persistent_state[key] = min(persistent_state[key] + 1, max_stacks)
    return persistent_state[key]

func get_stack(key: String = "stack") -> int:
    return persistent_state.get(key, 0)

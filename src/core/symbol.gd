# src/core/Symbol.gd (ADD THIS METHOD)
class_name Symbol
extends Resource

@export var uid: String = "PLACEHOLDER"
@export var symbol_name: String = ""
@export var description: String = "Placeholder"
@export var texture: Texture2D = null

# Base stats
@export var base_points: int = 1
@export var base_mult: int = 1

# Effects that modify this symbol
var symbol_effects: Array[Effect] = []

# Calculate effective stats (base + modifiers)
func get_effective_points(context: Dictionary = {}) -> int:
    var total = base_points
    # For now, just return base (effects come later)
    return total

func get_effective_mult(context: Dictionary = {}) -> int:
    var total = base_mult
    # For now, just return base (effects come later)
    return total

func add_effect(effect: Effect) -> void:
    symbol_effects.append(effect)

func remove_effect(effect_id: String) -> void:
    symbol_effects = symbol_effects.filter(func(e): return e.effect_id != effect_id)

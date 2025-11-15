# src/core/Relic.gd
class_name Relic
extends Resource

@export var relic_id: String
@export var relic_name: String
@export var description: String
@export var icon: Texture2D
@export var rarity: String = "common"

# Effects this relic provides
@export var relic_effects: Array[Effect] = []

func activate(game_state: GameState) -> void:
	for effect in relic_effects:
		game_state.add_active_effect(effect)

func deactivate(game_state: GameState) -> void:
	for effect in relic_effects:
		game_state.remove_active_effect(effect.effect_id)

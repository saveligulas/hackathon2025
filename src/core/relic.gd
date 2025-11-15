# src/relics/Relic.gd
class_name Relic
extends Control

enum Rarity {
    COMMON,
    UNCOMMON,
    RARE,
    EPIC,
    LEGENDARY
}

@export var relic_id: String = ""
@export var relic_name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var rarity: Rarity = Rarity.COMMON
@export var relic_effects: Array[Effect] = []

func activate(game_state):
    for effect in relic_effects:
        game_state.add_active_effect(effect)
    print("Activated", relic_name)

func deactivate(game_state):
    for effect in relic_effects:
        game_state.remove_active_effect(effect.effect_id)
    print("Deactivated", relic_name)

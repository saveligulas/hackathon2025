# src/core/GameState.gd
class_name GameState
extends Resource

# Player data
var player_data: PlayerData

# Active relics
var active_relics: Array[Relic] = []

# Active global effects (from relics, temporary bonuses, etc.)
var active_effects: Array[Effect] = []

# Current spin result
var current_grid: Array = []
var current_score: Dictionary = {}

func get_player_data() -> PlayerData:
	return player_data

func activate_all_player_relics() -> void:
	for relic in player_data.relics:
		active_relics.append(relic)
		for effect in relic.relic_effects:
			active_effects.append(effect)


func add_active_effect(effect: Effect) -> void:
	# Check if effect stacks
	var existing = active_effects.filter(func(e): return e.effect_id == effect.effect_id)
	if existing.size() > 0:
		existing[0].stack_count += 1
	else:
		active_effects.append(effect)

func remove_active_effect(effect_id: String) -> void:
	active_effects = active_effects.filter(func(e): return e.effect_id != effect_id)

func get_effects_by_timing(timing: Effect.EffectTiming) -> Array[Effect]:
	return active_effects.filter(func(e): return e.timing == timing)

func equip_relic(relic: Relic) -> void:
	active_relics.append(relic)
	relic.activate(self)

func unequip_relic(relic_id: String) -> void:
	var relic = active_relics.filter(func(r): return r.relic_id == relic_id)
	if relic.size() > 0:
		relic[0].deactivate(self)
		active_relics.erase(relic[0])

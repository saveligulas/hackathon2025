# src/relics/cursed_treasure_relic.gd
extends Relic

func _init():
	relic_id = "cursed_treasure"
	relic_name = "Cursed Treasure"
	description = "All symbols gain +50 points, but Eye symbols lose -2 mult"
	icon = null
	rarity = Rarity.LEGENDARY
	relic_effects = [
		AddPointsEffect.new(50, []),  # Empty array = all symbols
		ReduceMultEffect.new(2, ["eye"])
	]

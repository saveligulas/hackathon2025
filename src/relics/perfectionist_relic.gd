# src/relics/perfectionist_relic.gd
extends Relic

func _init():
	relic_id = "perfectionist"
	relic_name = "The Perfectionist"
	description = "+200 points when 3+ patterns match, but -1 mult to all Currency symbols"
	icon = null
	rarity = Rarity.LEGENDARY
	relic_effects = [
		PatternBonusEffect.new(200, 3),
		ReduceMultEffect.new(1, ["currency"])
	]

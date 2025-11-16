# src/relics/palm_readers_network_relic.gd
extends Relic

func _init():
	relic_id = "palm_readers_network"
	relic_name = "Palm Reader's Network"
	description = "If 4+ Palm symbols: all Palms gain +3 mult and +20 points"
	icon = null
	rarity = Rarity.EPIC
	relic_effects = [
		ThresholdBonusEffect.new("palm", 4, 20),
		ThresholdMultEffect.new("palm", 4, 3)
	]

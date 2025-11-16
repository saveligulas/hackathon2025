# src/relics/currency_magnet_relic.gd
extends Relic

func _init():
	relic_id = "currency_magnet"
	relic_name = "Currency Magnet"
	description = "If 3+ currency symbols appear, all symbols gain +25 points"
	icon = null
	rarity = Rarity.EPIC
	relic_effects = [
		ThresholdBonusEffect.new("currency", 3, 25)
	]

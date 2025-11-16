# src/relics/risky_gamblers_coin_relic.gd
extends Relic

func _init():
	relic_id = "risky_gamblers_coin"
	relic_name = "Risky Gambler's Coin"
	description = "Currency symbols: +5 mult, but Palm symbols: -1 mult"
	icon = null
	rarity = Rarity.LEGENDARY
	relic_effects = [
		AddMultEffect.new(5, ["currency"]),
		ReduceMultEffect.new(1, ["palm"])
	]

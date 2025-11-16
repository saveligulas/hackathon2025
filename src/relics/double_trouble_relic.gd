# src/relics/double_trouble_relic.gd
extends Relic

func _init():
	relic_id = "double_trouble"
	relic_name = "Double Trouble"
	description = "Eye and Palm symbols gain +4 mult, but Fingerprint symbols lose -2 mult"
	icon = null
	rarity = Rarity.EPIC
	relic_effects = [
		AddMultEffect.new(4, ["eye", "palm"]),
		ReduceMultEffect.new(2, ["fingerprint"])
	]

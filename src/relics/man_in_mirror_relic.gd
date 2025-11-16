# src/relics/man_in_mirror_relic.gd
extends Relic

func _init():
	relic_id = "man_in_mirror"
	relic_name = "Man in the Mirror"
	description = "Man symbols gain +2 points per adjacent Man symbol"
	icon = null
	rarity = Rarity.UNCOMMON
	relic_effects = [
		AdjacentPointsEffect.new("man", 2)
	]

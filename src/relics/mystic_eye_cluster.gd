# src/relics/mystic_eye_cluster_relic.gd
extends Relic

func _init():
	relic_id = "mystic_eye_cluster"
	relic_name = "Mystic Eye Cluster"
	description = "Eye symbols gain +1 mult per adjacent Eye symbol"
	icon = null
	rarity = Rarity.RARE
	relic_effects = [
		AdjacentBonusEffect.new("eye", 1)
	]

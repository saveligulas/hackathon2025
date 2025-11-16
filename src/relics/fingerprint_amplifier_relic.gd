# src/relics/fingerprint_amplifier_relic.gd
extends Relic

func _init():
	relic_id = "fingerprint_amplifier"
	relic_name = "Fingerprint Amplifier"
	description = "Fingerprints gain +2 mult per adjacent Fingerprint AND +10 points"
	icon = null
	rarity = Rarity.RARE
	relic_effects = [
		AdjacentBonusEffect.new("fingerprint", 2),
		AddPointsEffect.new(10, ["fingerprint"])
	]

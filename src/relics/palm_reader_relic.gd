# src/relics/palm_reader_relic.gd
extends Relic

func _init():
	relic_id = "palm_reader"
	relic_name = "Palm Reader's Charm"
	description = "Palm and Fingerprint symbols get +2 mult"
	icon = null
	rarity = Rarity.UNCOMMON
	relic_effects = [
		AddMultEffect.new(2, ["palm", "fingerprint"])
	]

func _ready():
	if $TextureRect:
		$TextureRect.texture = icon
	if $Label:
		$Label.text = relic_name

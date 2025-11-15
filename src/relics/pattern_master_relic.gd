# src/relics/pattern_master_relic.gd
extends Relic

func _init():
	relic_id = "pattern_master"
	relic_name = "Pattern Master's Trophy"
	description = "Gain +100 points when 2 or more patterns match"
	icon = null
	rarity = Rarity.RARE
	relic_effects = [
		PatternBonusEffect.new(100, 2)
	]

func _ready():
	if $TextureRect:
		$TextureRect.texture = icon
	if $Label:
		$Label.text = relic_name

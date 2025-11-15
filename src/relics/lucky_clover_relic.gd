# src/relics/lucky_clover_relic.gd
extends Relic

func _init():
	relic_id = "lucky_clover"
	relic_name = "Lucky Clover"
	description = "Currency symbols give +3 points"
	icon = null
	rarity = Rarity.COMMON
	relic_effects = [
		AddPointsEffect.new(3, ["currency"])
	]

func _ready():
	if $TextureRect:
		$TextureRect.texture = icon
	if $Label:
		$Label.text = relic_name

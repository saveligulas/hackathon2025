# scenes/relics/GoldenCalculatorRelic.gd
extends Relic

func _init():
	relic_id = "golden_calculator"
	relic_name = "Golden Calculator"
	description = "Doubles all points from symbols."
	icon = null
	rarity = Rarity.RARE
	relic_effects = [AddPointsEffect.new()]
	print("Golden Calculator initialized with effects: ", relic_effects)

func _ready():
	# Update visual elements only
	if $TextureRect:
		$TextureRect.texture = icon
	if $Label:
		$Label.text = relic_name

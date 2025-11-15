# src/relics/fingerprint_eraser_relic.gd
extends Relic

func _init():
	relic_id = "fingerprint_eraser"
	relic_name = "Fingerprint Eraser"
	description = "All fingerprint symbols become currency symbols"
	icon = null
	rarity = Rarity.EPIC
	relic_effects = [
		RerollSymbolEffect.new("fingerprint", "currency")
	]

func _ready():
	if $TextureRect:
		$TextureRect.texture = icon
	if $Label:
		$Label.text = relic_name

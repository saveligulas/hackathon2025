# src/relics/eye_fortune_relic.gd
extends Relic

func _init():
    relic_id = "eye_fortune"
    relic_name = "Eye of Fortune"
    description = "Eye symbols have ×2 points"
    icon = null
    rarity = Rarity.UNCOMMON
    relic_effects = [
        MultiplyPointsEffect.new(2.0, ["eye"])
    ]

func _ready():
    if $TextureRect:
        $TextureRect.texture = icon
    if $Label:
        $Label.text = relic_name

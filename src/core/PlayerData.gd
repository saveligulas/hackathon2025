class_name PlayerData
extends Resource

@export var reels: Array[Reel]
var relics: Array[Relic] = []

func initialize():
	reels.resize(5)
	for i in range(5):
		reels[i] = Reel.new()
		
	var relic_scene = load("res://scenes/relics/goldenCalculatorRelic.tscn")
	var relic_instance = relic_scene.instantiate()
	relics.append(relic_instance)
	print(relics)
	print(relic_instance.relic_effects)

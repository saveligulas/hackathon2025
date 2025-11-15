class_name PlayerData
extends Resource

@export var reels: Array[Reel]
var relics: Array[Relic] = []

func initialize():
	reels.resize(5)
	for i in range(5):
		reels[i] = Reel.new()

	# Test with different relics
	var test_relics = [
		load("res://src/relics/lucky_clover_relic.gd").new(),
		load("res://src/relics/eye_fortune_relic.gd").new(),
		load("res://src/relics/palm_reader_relic.gd").new(),
		load("res://src/relics/pattern_master_relic.gd").new(),
		load("res://src/relics/fingerprint_eraser_relic.gd").new(),
	]

	for relic in test_relics:
		relics.append(relic)

	print("Initialized with %d relics" % relics.size())

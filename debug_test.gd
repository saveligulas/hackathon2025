# res://debug_test.gd
extends Node

func _ready():
	print("Starting pattern generation...")
	
	# Run the pattern generator
	var gen = preload("res://src/score/pattern_generator_extended.gd").new()
	gen.generate_all_patterns()
	
	print("Pattern generation complete!")

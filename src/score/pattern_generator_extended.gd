# src/score/pattern_generator_extended.gd
# EXPANDED PATTERN SET - 25+ casino-style patterns
# Run this to create all base + advanced patterns

extends Node

func generate_all_patterns() -> void:
	print("GENERATING 25+ CASINO PATTERNS")
	
	# ========================================================================
	# BASIC LINE PATTERNS (3 patterns)
	# ========================================================================
	print("--- BASIC LINES ---")
	create_and_save(
		"top_line", "Top Line", 
		[1,0,0, 1,0,0, 1,0,0, 1,0,0, 1,0,0],
		25, 1, "Match symbols across the top row"
	)
	
	create_and_save(
		"middle_line", "Middle Line", 
		[0,1,0, 0,1,0, 0,1,0, 0,1,0, 0,1,0],
		25, 1, "Match symbols across the middle row"
	)
	
	create_and_save(
		"bottom_line", "Bottom Line", 
		[0,0,1, 0,0,1, 0,0,1, 0,0,1, 0,0,1],
		25, 1, "Match symbols across the bottom row"
	)
	
	# ========================================================================
	# DIAGONAL PATTERNS (4 patterns)
	# ========================================================================
	print("\n--- DIAGONALS ---")
	create_and_save(
		"diagonal_tlbr", "Diagonal TL→BR", 
		[1,0,0, 0,1,0, 0,0,1, 0,1,0, 1,0,0],
		35, 2, "Diagonal from top-left to bottom-right"
	)
	
	create_and_save(
		"diagonal_trbl", "Diagonal TR→BL", 
		[0,0,1, 0,1,0, 0,0,1, 0,1,0, 0,0,1],
		35, 2, "Diagonal from top-right to bottom-left"
	)
	
	create_and_save(
		"diagonal_double", "Double Diagonal X", 
		[1,0,1, 0,1,0, 0,0,1, 0,1,0, 1,0,1],
		50, 3, "X-shaped pattern with both diagonals"
	)
	
	create_and_save(
		"diagonal_zigzag", "Zigzag Pattern", 
		[1,0,0, 0,1,0, 1,0,0, 0,1,0, 1,0,0],
		30, 2, "Zigzag pattern left-right"
	)
	
	# ========================================================================
	# V-SHAPE PATTERNS (4 patterns)
	# ========================================================================
	print("\n--- V-SHAPES ---")
	create_and_save(
		"v_shape", "V-Shape Down", 
		[1,0,0, 0,1,0, 0,0,1, 0,1,0, 1,0,0],
		40, 2, "V-shaped pattern (top→middle→bottom→middle→top)"
	)
	
	create_and_save(
		"reverse_v_shape", "V-Shape Up", 
		[0,0,1, 0,1,0, 1,0,0, 0,1,0, 0,0,1],
		40, 2, "Reverse V-shaped pattern (bottom→middle→top→middle→bottom)"
	)
	
	create_and_save(
		"wave_pattern", "Wave Left", 
		[1,0,0, 1,0,0, 0,1,0, 0,1,0, 0,0,1],
		35, 2, "Wave pattern flowing right"
	)
	
	create_and_save(
		"wave_pattern_right", "Wave Right", 
		[0,0,1, 0,0,1, 0,1,0, 0,1,0, 1,0,0],
		35, 2, "Wave pattern flowing left"
	)
	
	# ========================================================================
	# CORNER PATTERNS (4 patterns)
	# ========================================================================
	print("\n--- CORNERS ---")
	create_and_save(
		"corners_all", "All Corners", 
		[1,0,1, 0,0,0, 0,0,0, 0,0,0, 1,0,1],
		45, 3, "Symbols in all four corners"
	)
	
	create_and_save(
		"corners_top", "Top Corners", 
		[1,0,1, 0,0,0, 0,0,0, 0,0,0, 0,0,0],
		30, 1, "Symbols in top-left and top-right"
	)
	
	create_and_save(
		"corners_bottom", "Bottom Corners", 
		[0,0,0, 0,0,0, 0,0,0, 0,0,0, 1,0,1],
		30, 1, "Symbols in bottom-left and bottom-right"
	)
	
	create_and_save(
		"corners_sides", "Side Corners", 
		[1,0,0, 0,0,0, 0,0,1, 0,0,0, 1,0,0],
		35, 2, "Left and right corners connected"
	)
	
	# ========================================================================
	# PLUS/CROSS PATTERNS (3 patterns)
	# ========================================================================
	print("\n--- PLUS & CROSS PATTERNS ---")
	create_and_save(
		"plus_pattern", "Plus Sign", 
		[0,1,0, 1,1,1, 0,1,0, 1,1,1, 0,1,0],
		55, 3, "Plus sign pattern - all middle positions"
	)
	
	create_and_save(
		"cross_full", "Full Cross", 
		[1,0,1, 0,1,0, 0,0,1, 0,1,0, 1,0,1],
		60, 4, "Full cross pattern - all positions connected"
	)
	
	create_and_save(
		"t_pattern_down", "T-Shape Down", 
		[1,0,1, 0,1,0, 0,1,0, 0,1,0, 0,1,0],
		40, 2, "T-shape pointing down"
	)
	
	# ========================================================================
	# SCATTERED/FRAME PATTERNS (4 patterns)
	# ========================================================================
	print("\n--- SCATTERED & FRAMES ---")
	create_and_save(
		"frame_pattern", "Frame Border", 
		[1,0,1, 1,0,1, 1,0,1, 1,0,1, 1,0,1],
		50, 3, "Symbols on left and right edges only"
	)
	
	create_and_save(
		"scattered_5", "5-Point Scatter", 
		[1,0,1, 0,1,0, 0,0,0, 0,1,0, 1,0,1],
		45, 2, "5 corners and center"
	)
	
	create_and_save(
		"scattered_alternating", "Alternating Rows", 
		[1,0,0, 0,1,0, 1,0,0, 0,1,0, 1,0,0],
		30, 1, "Alternating pattern across rows"
	)
	
	create_and_save(
		"edges_only", "Edges Only", 
		[1,0,0, 1,0,1, 1,0,0, 1,0,1, 1,0,0],
		35, 2, "Left edge and middle column"
	)
	
	# ========================================================================
	# SPECIAL PATTERNS (4 patterns)
	# ========================================================================
	print("\n--- SPECIAL PATTERNS ---")
	create_and_save(
		"pyramid_down", "Pyramid Down", 
		[1,0,1, 0,1,0, 0,0,1, 0,1,0, 1,0,1],
		50, 3, "Pyramid expanding downward"
	)
	
	create_and_save(
		"hourglass", "Hourglass", 
		[1,0,1, 0,1,0, 0,0,1, 0,1,0, 1,0,1],
		55, 3, "Hourglass shape (diamond)"
	)
	
	create_and_save(
		"checkerboard", "Checkerboard", 
		[1,0,1, 0,1,0, 1,0,1, 0,1,0, 1,0,1],
		60, 3, "Alternating checkerboard pattern"
	)
	
	create_and_save(
		"staircase_down", "Staircase Down", 
		[1,0,0, 1,1,0, 0,1,1, 0,0,1, 0,0,1],
		40, 2, "Staircase descending pattern"
	)
	
	# ========================================================================
	# REEL-FOCUSED PATTERNS (3 patterns)
	# ========================================================================
	print("\n--- REEL-FOCUSED ---")
	create_and_save(
		"reel1_all", "Reel 1 Full", 
		[1,0,0, 1,0,0, 1,0,0, 0,0,0, 0,0,0],
		25, 1, "All symbols in reel 1 only"
	)
	
	create_and_save(
		"reel_center_3", "Center Reels 3", 
		[0,0,0, 0,1,0, 0,1,0, 0,1,0, 0,0,0],
		30, 2, "Reels 1-3 middle row only"
	)
	
	create_and_save(
		"reels_outer", "Outer Reels", 
		[1,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,1],
		35, 2, "Only first and last reel"
	)
	
	# ========================================================================
	# SUMMARY
	# =====================================
	print("✓ TOTAL PATTERNS GENERATED: 25+")
	print("Categories:")
	print("  • Basic Lines: 3")
	print("  • Diagonals: 4")
	print("  • V-Shapes: 4")
	print("  • Corners: 4")
	print("  • Plus/Cross: 3")
	print("  • Scattered/Frames: 4")
	print("  • Special: 4")
	print("  • Reel-Focused: 3")

# Helper function
func create_and_save(
	pattern_id: String,
	pattern_name: String,
	cells: Array,
	bonus_points: int,
	bonus_mult: int,
	description: String
) -> void:
	
	var pattern = Pattern.new()
	pattern.pattern_id = pattern_id
	pattern.pattern_name = pattern_name
	pattern.description = description
	pattern.cells = PackedInt32Array(cells)
	pattern.target_symbol_uid = ""
	pattern.must_fill_all_cells = true
	pattern.min_symbol_count = 5
	
	# Add effects
	pattern.pattern_effects.append(AddPointsEffect.new(bonus_points, []))
	pattern.pattern_effects.append(AddMultEffect.new(bonus_mult, []))
	
	# Save
	var file_path = "res://patterns/%s.tres" % pattern_id
	var error = ResourceSaver.save(pattern, file_path)
	
	if error == OK:
		print("  ✓ %s (%d pts, %dx mult)" % [pattern_name, bonus_points, bonus_mult])
	else:
		print("  ✗ Failed: %s" % pattern_name)

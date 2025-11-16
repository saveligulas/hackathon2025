# src/score/pattern_loader.gd
extends Node
class_name CustomPatternLoader

var patterns: Array[Pattern] = []

func _ready() -> void:
	load_all_patterns("res://patterns")

func get_patterns() -> Array[Pattern]:
	return patterns

func load_all_patterns(folder_path: String) -> void:
	patterns.clear()
	
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("Cannot open patterns folder: " + folder_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var file_path = folder_path + "/" + file_name
			var pattern: Pattern = load(file_path)
			
			if pattern != null and pattern is Pattern:
				patterns.append(pattern)
				print("✓ Loaded pattern: %s (%s)" % [pattern.pattern_name, pattern.pattern_id])
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	print("Total patterns loaded: %d" % patterns.size())

# Runtime pattern creation via factory
func create_and_register_pattern(
	pattern_id: String,
	pattern_name: String,
	row_index: int,
	symbol_uid: String,
	bonus_points: int = 0
) -> Pattern:
	
	var pattern = PatternFactory.create_line_pattern(
		pattern_id,
		pattern_name,
		row_index,
		symbol_uid,
		bonus_points
	)
	
	patterns.append(pattern)
	print("✓ Created pattern: %s (%s)" % [pattern_name, pattern_id])
	return pattern

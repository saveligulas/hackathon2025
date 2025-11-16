# src/core/shop.gd
extends Control

@onready var next_round_button: Button = $MarginContainer/VBoxContainer/Button
@onready var reward_label: Label = $MarginContainer/VBoxContainer/Reward
@onready var reward_title: Label = $"MarginContainer/VBoxContainer/Reward Title"
var run_manager = GameManager.get_node("RunManager")
var selected_relic: Relic

func _ready() -> void:
	next_round_button.pressed.connect(_on_next_round_pressed)
	var game_state = GameManager.run_manager.game_state
	
	# NEW: Auto-load all relics from folder
	var available_relics = get_available_relics(game_state)
	
	# If no relics available, show message and skip
	if available_relics.is_empty():
		reward_title.text = "No Relics Available"
		reward_label.text = "All relics have been collected!"
		return
	
	# Pick a random available relic
	var index = randi() % available_relics.size()
	var relic_path = available_relics[index]
	var script = load(relic_path)
	var relic = script.new()

	# Equip to game state
	game_state.equip_relic(relic)

	reward_title.text = relic.relic_name
	reward_label.text = relic.description

# NEW: Auto-discover all relics in the relics folder
func get_all_relic_paths() -> Array:
	var relic_paths = []
	var dir = DirAccess.open("res://src/relics/")
	
	if dir == null:
		push_error("Cannot access res://src/relics/ folder!")
		return relic_paths
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Only load .gd files
		if file_name.ends_with(".gd"):
			relic_paths.append("res://src/relics/" + file_name)
		file_name = dir.get_next()
	
	return relic_paths

# Get list of relics not yet owned
func get_available_relics(game_state) -> Array:
	var available = []
	var all_relic_paths = get_all_relic_paths()
	
	# Get owned relic IDs
	var owned_ids = []
	for relic in game_state.player_data.relics:
		owned_ids.append(relic.relic_id)
	
	# Filter out owned relics
	for relic_path in all_relic_paths:
		var script = load(relic_path)
		
		if script == null:
			push_warning("Failed to load relic script: %s" % relic_path)
			continue
		
		var temp_relic = script.new()
		
		if not temp_relic.relic_id in owned_ids:
			available.append(relic_path)
		
		# Clean up temp relic
		temp_relic.queue_free()
	
	return available

func _on_next_round_pressed():
	run_manager.advance_round()
	GameManager.change_phase(GameManager.GamePhase.PLAYING)

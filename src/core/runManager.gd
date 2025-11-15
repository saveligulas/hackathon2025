# src/run/RunManager.gd (COMPLETE VERSION)
extends Node

# Load symbols at runtime instead of export
var starting_symbols: Array[Symbol] = []

var game_state: GameState
var slot_machine_manager: SlotMachineManager

signal spin_started
signal spin_completed(result_grid: Array)
signal effects_applied(timing: int)

func _ready():
	print("RunManager loaded")
	# Load symbols at runtime
	load_starting_symbols()

func load_starting_symbols():
	# Load symbol resources at runtime instead of in scene
	starting_symbols = [
		load("res://symbols/cash_symbol.tres"),
		load("res://symbols/fingerprint_symbol.tres"),
		load("res://symbols/palm_symbol.tres"),
		load("res://symbols/man_symbol.tres"),
		load("res://symbols/eye_symbol.tres")
	]
	print("Loaded ", starting_symbols.size(), " starting symbols")

func initialize():
	game_state = GameState.new()
	
	slot_machine_manager = SlotMachineManager.new()
	
	if game_state.player_data == null:
		game_state.player_data = PlayerData.new()
		game_state.player_data.initialize()
		
		for reel in game_state.player_data.reels:
			starting_symbols.shuffle()
			reel.symbols.append_array(starting_symbols)
	#TODO: remove                        
	game_state.activate_all_player_relics()
	print("RunManager initialized with ", game_state.player_data.reels.size(), " reels")
	print("RunManager effects ", game_state.active_effects)

# In src/core/runManager.gd - in execute_spin()
func execute_spin() -> Array:
	print("Executing spin...")
	
	# Apply BEFORE_SPIN effects
	apply_effects(Effect.EffectTiming.BEFORE_SPIN)
	emit_signal("effects_applied", Effect.EffectTiming.BEFORE_SPIN)
	
	emit_signal("spin_started")
	
	# Execute the actual spin
	slot_machine_manager.spin(game_state.player_data)
	var result_grid = slot_machine_manager.result_grid
	game_state.current_grid = result_grid
	
	# Apply AFTER_SPIN effects (can modify grid) ← THIS IS CRUCIAL
	result_grid = apply_effects_to_grid(Effect.EffectTiming.AFTER_SPIN, result_grid)
	game_state.current_grid = result_grid
	emit_signal("effects_applied", Effect.EffectTiming.AFTER_SPIN)
	
	emit_signal("spin_completed", result_grid)
	return result_grid


func calculate_score() -> Dictionary:
	var score_calculator = GameManager.get_node("ScoreCalculator")
	
	# Pass game state to score calculator so it can apply effects
	var score_result = score_calculator.calculate_score_with_state(
		game_state.current_grid, 
		game_state
	)
	
	game_state.current_score = score_result
	
	# Apply AFTER_SCORING effects
	score_result = apply_effects_to_score(Effect.EffectTiming.AFTER_SCORING, score_result)
	emit_signal("effects_applied", Effect.EffectTiming.AFTER_SCORING)
	
	return score_result

func apply_effects(timing: int) -> void:
	var effects = game_state.get_effects_by_timing(timing)
	for effect in effects:
		if effect.can_apply({"game_state": game_state}):
			effect.apply({"game_state": game_state})

func apply_effects_to_grid(timing: int, grid: Array) -> Array:
	var effects = game_state.get_effects_by_timing(timing)
	var modified_grid = grid.duplicate(true)
	
	for effect in effects:
		if effect.target in [Effect.EffectTarget.GRID, Effect.EffectTarget.REEL]:
			var context = {"grid": modified_grid, "game_state": game_state}
			if effect.can_apply(context):
				var result = effect.apply(context)
				if result.has("grid"):
					modified_grid = result.grid
	
	return modified_grid

func apply_effects_to_score(timing: int, score_data: Dictionary) -> Dictionary:
	var effects = game_state.get_effects_by_timing(timing)
	var modified_score = score_data.duplicate(true)
	
	for effect in effects:
		if effect.target == Effect.EffectTarget.SCORE:
			var context = {"score": modified_score, "game_state": game_state}
			if effect.can_apply(context):
				var result = effect.apply(context)
				if result.has("score"):
					modified_score = result.score
	
	return modified_score

func reset():
	game_state = GameState.new()
	load_starting_symbols()
	initialize()

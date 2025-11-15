extends Node

var starting_symbols: Array[Symbol] = []

var game_state: GameState
var slot_machine_manager: SlotMachineManager

signal spin_started
signal spin_completed(result_grid: Array)
signal effects_applied(timing: int)
signal goal_reached
signal round_advanced

var current_goal: int = 10
var current_round: int = 1
var total_score: int = 0
var spins_this_round: int = 0
var remaining_respins: int = 3
const MAX_SPINS_PER_ROUND := 5
var score_calculated_this_spin: bool = false

func _ready():
    print("RunManager loaded")
    load_starting_symbols()

func load_starting_symbols():
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
    spins_this_round = 0
    total_score = 0
    current_goal = 10
    current_round = 1

    if game_state.player_data == null:
        game_state.player_data = PlayerData.new()
        game_state.player_data.initialize()

        for reel in game_state.player_data.reels:
            starting_symbols.shuffle()
            reel.symbols.append_array(starting_symbols)

    game_state.activate_all_player_relics()
    print("RunManager initialized with ", game_state.player_data.reels.size(), " reels")
    print("RunManager effects ", game_state.active_effects)

# Call this at the start of each spin
func execute_spin() -> Array:
    print("Executing spin...")
    
    if not can_spin():
        print("No spins left this round!")
        GameManager.change_phase(GameManager.GamePhase.GAMEOVER)
        return []
    
    spins_this_round += 1
    remaining_respins = 3
    score_calculated_this_spin = false  # NEW: Reset flag each spin
    
    # ... rest of your existing execute_spin code
    apply_effects(Effect.EffectTiming.BEFORE_SPIN)
    emit_signal("effects_applied", Effect.EffectTiming.BEFORE_SPIN)
    emit_signal("spin_started")
    
    slot_machine_manager.spin(game_state.get_player_data())
    var result_grid = slot_machine_manager.result_grid
    game_state.current_grid = result_grid
    
    result_grid = apply_effects_to_grid(Effect.EffectTiming.AFTER_SPIN, result_grid)
    game_state.current_grid = result_grid
    
    emit_signal("effects_applied", Effect.EffectTiming.AFTER_SPIN)
    emit_signal("spin_completed", result_grid)
    
    return result_grid

# Check if score can be calculated
func can_calculate_score() -> bool:
    if game_state.current_grid.is_empty():
        return false
    
    if score_calculated_this_spin:
        print("Score already calculated for this spin")
        return false
    
    return true

# Calculate score and apply it to total
func calculate_and_apply_score() -> Dictionary:
    if not can_calculate_score():
        print("Cannot calculate score!")
        return {"total_score": 0, "matched_patterns": []}
    
    # Calculate the score
    var score_result = calculate_score()
    var points = score_result.total_score
    
    # Mark as calculated
    score_calculated_this_spin = true
    
    # Apply to total score and check goal
    on_score_evaluated(points)
    
    print("Score calculated and applied: ", points)
    return score_result
    
# NEW: Respin a single reel
func respin_reel(reel_index: int) -> Array:
    if reel_index < 0 or reel_index >= 5:
        push_error("Invalid reel index: %d" % reel_index)
        return game_state.current_grid
    
    if remaining_respins <= 0:
        print("No respins remaining!")
        return game_state.current_grid
    
    # Consume a respin
    remaining_respins -= 1
    emit_signal("respin_used", remaining_respins)
    print("Respin used on reel %d. Remaining respins: %d" % [reel_index, remaining_respins])
    
    # Get the reel data
    var reel_symbols = game_state.player_data.reels[reel_index].symbols
    var reel_size = reel_symbols.size()
    
    if reel_size == 0:
        push_error("Reel %d has no symbols!" % reel_index)
        return game_state.current_grid
    
    # Generate new random symbols for this reel
    var start_index = randi() % reel_size
    
    for row in range(3):
        var index = (start_index + row) % reel_size
        game_state.current_grid[reel_index][row] = reel_symbols[index]
    
    # Apply AFTER_SPIN effects to the modified grid
    var result_grid = apply_effects_to_grid(Effect.EffectTiming.AFTER_SPIN, game_state.current_grid)
    game_state.current_grid = result_grid
    
    print("Reel %d respun successfully" % reel_index)
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

func on_score_evaluated(score: int):
    total_score += score
    if total_score >= current_goal:
        emit_signal("goal_reached")

func advance_round():
    current_round += 1
    spins_this_round = 0
    emit_signal("round_advanced")

func reset_round_for_goal():
    @warning_ignore("narrowing_conversion")
    current_goal = int(current_goal * 1.5)
    total_score = 0

func can_spin() -> bool:
    return spins_this_round < MAX_SPINS_PER_ROUND

func get_current_goal():
    return current_goal

func get_current_round():
    return current_round

func get_total_score():
    return total_score

func get_remaining_respins():
    return remaining_respins
    
func can_respin():
    return remaining_respins > 0

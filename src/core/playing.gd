extends Node2D

@onready var respin_buttons := [
    $"Slot Machine/MarginContainer3/HBoxContainer/Button",
    $"Slot Machine/MarginContainer3/HBoxContainer/Button2",
    $"Slot Machine/MarginContainer3/HBoxContainer/Button3",
    $"Slot Machine/MarginContainer3/HBoxContainer/Button4",
    $"Slot Machine/MarginContainer3/HBoxContainer/Button5"
]
@onready var lever: AnimatedSprite2D = $"Slot Machine/Lever/Lever"
@onready var reel_container: Node2D = $ReelContainer
@onready var spinners := [
    $ReelContainer/Spin1,
    $ReelContainer/Spin2,
    $ReelContainer/Spin3,
    $ReelContainer/Spin4,
    $ReelContainer/Spin5
]
@onready var goal_label: Label = $"Slot Machine/MarginContainer/Information/Goal/Value"
@onready var score_label: Label = $"Slot Machine/MarginContainer/Information/Score/Value"
@onready var points_label: Label = $"Slot Machine/MarginContainer/Information/Calculation/Points"
@onready var mult_label: Label = $"Slot Machine/MarginContainer/Information/Calculation/Mult"
@onready var reel_spin_label: Label = $"Slot Machine/MarginContainer/Information/HBoxContainer/ReelSpin/Value"
@onready var round_label: Label = $"Slot Machine/MarginContainer/Information/HBoxContainer/Round/Value"
@onready var modifier_list: VBoxContainer = $"Slot Machine/MarginContainer/Information/ModifierContainer/Modifier"
@onready var spins_left: Label = $"Slot Machine/MarginContainer2/Spins/Value"
@onready var respins_left: Label = $"Slot Machine/MarginContainer/Information/HBoxContainer/ReelSpin/Value"

var is_spinning: bool = false
var run_manager: Node

@onready var machine_noises: AudioStreamPlayer = $MachineNoises
@onready var background_music: AudioStreamPlayer = $BackgroundMusic


func _ready():
    print("Playing scene ready")
    background_music.set_stream(AudioManager.sound_main_theme_loopable)
    background_music.play()

    # Get run manager from GameManager
    if not GameManager.has_node("RunManager"):
        push_error("RunManager not found in GameManager!")
        return

    run_manager = GameManager.get_node("RunManager")

    # Connect to signals from run manager
    run_manager.spin_started.connect(_on_spin_started)
    run_manager.spin_completed.connect(_on_spin_completed)
    run_manager.effects_applied.connect(_on_effects_applied)
    run_manager.goal_reached.connect(_on_goal_reached)
    run_manager.round_advanced.connect(_on_round_advanced)
    update_ui_labels()

    if reel_container.get_child_count() == 0:
        push_error("ReelContainer has no children!")

func _on_button_pressed():
    if is_spinning:
        return

    lever.play("pull")
    machine_noises.set_stream(AudioManager.sound_lever)
    machine_noises.play()
    run_manager.execute_spin()


func _on_spin_started():
    is_spinning = true
    reel_container.start_spinners()
    reel_container.prepare_all_reels()
    update_ui_labels()

func _on_spin_completed(result_grid: Array):
    print("\n=== Spin Result ===")

    for i in range(5):
        var column_symbols: Array[Symbol] = []
        for row in range(3):
            var sym = result_grid[i][row]
            column_symbols.append(sym)
            if sym:
                print("Col ", i, " Row ", row, ": ", sym.description, " (", sym.base_points, " pts)")

        reel_container.display_reel(i, column_symbols)

    await get_tree().create_timer(1.0).timeout
    await stagger_reveal()

    # NEW: Update score preview AND highlight pattern immediately
    update_score_preview()

    update_ui_labels()
    is_spinning = false

    print("Spin completed. Waiting for player to press Ready button...")

func _on_effects_applied(timing: int):
    print("[EFFECT] Effects applied at timing: ", timing)

func stagger_reveal():
    for i in range(spinners.size()):
        spinners[i].hide()
        reel_container.reveal_column(i)
        machine_noises.set_stream(AudioManager.sound_reel_stop)
        machine_noises.play()
        await get_tree().create_timer(0.15).timeout

func update_ui_labels():
    goal_label.text = str(run_manager.get_current_goal())
    score_label.text = str(run_manager.get_total_score())
    round_label.text = str(run_manager.get_current_round())
    spins_left.text = str(run_manager.MAX_SPINS_PER_ROUND - run_manager.spins_this_round)
    respins_left.text = str(run_manager.get_remaining_respins())
    update_modifiers_ui()


func _on_goal_reached():
    await get_tree().create_timer(3).timeout
    GameManager.change_phase(GameManager.GamePhase.SHOP)
    run_manager.reset_round_for_goal()
    AudioManager.global_audio_player.set_stream(AudioManager.sound_victory)
    AudioManager.global_audio_player.play()

func _on_round_advanced():
    update_ui_labels()

func _on_respin_used(remaining_respins: int):
    print("Respin used! Remaining: ", remaining_respins)
    update_ui_labels()

func _on_respin_button_pressed() -> void:
    handle_respin(0)

func _on_respin_button2_pressed() -> void:
    handle_respin(1)

func _on_respin_button3_pressed() -> void:
    handle_respin(2)

func _on_respin_button_4_pressed() -> void:
    handle_respin(3)

func _on_respin_button5_pressed() -> void:
    handle_respin(4)

func handle_respin(reel_index: int):
    if is_spinning:
        print("Spinning, can't respin now")
        return

    if not run_manager.can_respin():
        print("No respins left!")
        return

    is_spinning = true
    print("Starting respin for reel %d" % reel_index)

    reel_container.hide_reel(reel_index)
    spinners[reel_index].show()
    reel_container.start_spinner_for_reel(reel_index)

    await get_tree().create_timer(0.3).timeout
    var new_grid = run_manager.respin_reel(reel_index)

    await get_tree().create_timer(0.8).timeout

    var column_symbols: Array[Symbol] = []
    for row in range(3):
        var sym = new_grid[reel_index][row]
        column_symbols.append(sym)
        if sym:
            print("Respin Col ", reel_index, " Row ", row, ": ", sym.description)

    reel_container.display_reel(reel_index, column_symbols)

    spinners[reel_index].hide()
    reel_container.reveal_column(reel_index)
    machine_noises.set_stream(AudioManager.sound_reel_stop)
    machine_noises.play()

    await get_tree().create_timer(0.5).timeout

    # NEW: Update preview and highlighting after respin
    update_score_preview()

    update_ui_labels()
    is_spinning = false
    print("Respin for reel %d completed" % reel_index)


func update_modifiers_ui():
    for child in modifier_list.get_children():
        child.queue_free()
    run_manager = GameManager.get_node("RunManager")
    var active_relics = run_manager.game_state.active_relics

    for relic in active_relics:
        var label = Label.new()
        label.text = relic.relic_name
        label.add_theme_font_size_override("font_size", 28)
        modifier_list.add_child(label)

func _on_ready_button_pressed() -> void:
    if is_spinning:
        print("Can't calculate score while spinning")
        return

    if not run_manager.can_calculate_score():
        print("No spin to calculate!")
        return

    print("Calculating final score for this spin...")

    # Calculate and apply score
    var score_result = run_manager.calculate_and_apply_score()

    # Optional: Show a brief animation or feedback
    await get_tree().create_timer(1.0).timeout

    # Update all UI labels
    update_ui_labels()

    # Check if we've reached the goal
    if run_manager.get_total_score() >= run_manager.get_current_goal():
        print("Goal reached!")

    print("Score applied. Total score: ", run_manager.get_total_score())

# NEW: Update score preview with highlighting
func update_score_preview() -> void:
    var preview = run_manager.preview_score()

    update_label_anim(points_label, int(points_label.text), preview.points, 1.5)
    update_label_anim(mult_label, int(mult_label.text), preview.mult, 1.5)

    # NEW: Highlight the matched pattern positions
    highlight_pattern_positions(preview.get("highlight_positions", []))

func update_label_anim(label: Label, start_value: int, end_value: int, duration: float=1.5):
    if end_value > start_value:
        label.pivot_offset = label.size / 2

        var tween = create_tween()
        tween.tween_method(
            func(value): label.text = str(round(value)),
            start_value, end_value, duration
        )

# NEW: Highlight all positions for current matched pattern
func highlight_pattern_positions(positions: Array) -> void:
    """Highlight symbols at the given positions"""
    # First clear any existing highlights
    clear_pattern_highlighting()

    # Then highlight the new positions
    for position in positions:
        highlight_symbol_at_position(position.x, position.y)

# NEW: Clear all highlighting
func clear_pattern_highlighting() -> void:
    """Remove highlighting from all symbols"""
    # Iterate through all reels
    for reel_index in range(reel_container.reel_nodes.size()):
        var reel_display = reel_container.reel_nodes[reel_index]

        # Each reel has symbol_positions array
        if reel_display.has_method("get_children"):
            for row in range(reel_display.symbol_positions.size()):
                var position_node = reel_display.symbol_positions[row]

                # Get the symbol display (first child of position node)
                if position_node.get_child_count() > 0:
                    var symbol_display = position_node.get_child(0)

                    # Call highlight method if it exists
                    if symbol_display.has_method("set_highlighted"):
                        symbol_display.set_highlighted(false)

# NEW: Highlight a single symbol at reel/row
func highlight_symbol_at_position(reel: int, row: int) -> void:
    """Highlight the symbol at the given reel and row"""
    # Bounds check
    if reel < 0 or reel >= reel_container.reel_nodes.size():
        push_warning("Invalid reel index: %d" % reel)
        return

    var reel_display = reel_container.reel_nodes[reel]

    # Check if row is valid
    if row < 0 or row >= reel_display.symbol_positions.size():
        push_warning("Invalid row index: %d for reel %d" % [row, reel])
        return

    var position_node = reel_display.symbol_positions[row]

    # Get the symbol display (first child of position node)
    if position_node.get_child_count() > 0:
        var symbol_display = position_node.get_child(0)

        # Call highlight method if it exists
        if symbol_display.has_method("set_highlighted"):
            symbol_display.set_highlighted(true)
            print("Highlighted symbol at [%d,%d]" % [reel, row])
        else:
            push_warning("Symbol display at [%d,%d] has no set_highlighted method" % [reel, row])
    else:
        push_warning("No symbol display found at [%d,%d]" % [reel, row])

# NEW: Optional - highlight with animation
func highlight_symbol_animated(reel: int, row: int) -> void:
    """Highlight a symbol with a pulsing animation"""
    if reel < 0 or reel >= reel_container.reel_nodes.size():
        return

    var reel_display = reel_container.reel_nodes[reel]
    if row < 0 or row >= reel_display.symbol_positions.size():
        return

    var position_node = reel_display.symbol_positions[row]
    if position_node.get_child_count() > 0:
        var symbol_display = position_node.get_child(0)

        # First highlight it
        if symbol_display.has_method("set_highlighted"):
            symbol_display.set_highlighted(true)

        # Then create pulsing animation
        var tween = create_tween()
        tween.set_loops(3)  # Pulse 3 times
        tween.tween_property(symbol_display, "scale", Vector2(1.1, 1.1), 0.2)
        tween.tween_property(symbol_display, "scale", Vector2(1.0, 1.0), 0.2)

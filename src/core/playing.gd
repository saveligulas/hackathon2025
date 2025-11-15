# src/core/playing.gd (COMPLETE REPLACEMENT)
extends Node2D

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

var is_spinning: bool = false
var run_manager: Node

func _ready():
    print("Playing scene ready")

    # Get run manager from GameManager
    if not GameManager.has_node("RunManager"):
        push_error("RunManager not found in GameManager!")
        return

    run_manager = GameManager.get_node("RunManager")

    # Connect to signals from run manager
    run_manager.spin_started.connect(_on_spin_started)
    run_manager.spin_completed.connect(_on_spin_completed)
    run_manager.effects_applied.connect(_on_effects_applied)

    if reel_container.get_child_count() == 0:
        push_error("ReelContainer has no children!")

func _on_button_pressed():
    if is_spinning:
        return

    lever.play("pull")
    run_manager.execute_spin()

func _on_spin_started():
    is_spinning = true
    reel_container.start_spinners()
    reel_container.prepare_all_reels()

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

    await get_tree().create_timer(1).timeout
    await stagger_reveal()

    # Calculate score using run manager
    var score_result = run_manager.calculate_score()
    print("=== Final Score: ", score_result.total_score, " ===")

    is_spinning = false

func _on_effects_applied(timing: int):
    print("[EFFECT] Effects applied at timing: ", timing)

func stagger_reveal():
    for i in range(spinners.size()):
        spinners[i].hide()
        reel_container.reveal_column(i)
        await get_tree().create_timer(0.15).timeout

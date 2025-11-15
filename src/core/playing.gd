extends Node2D

@onready var lever: AnimatedSprite2D = $"Slot Machine/Button/Lever"
@onready var reel_container: Node2D = $ReelContainer
@onready var spinners := [
    $ReelContainer/Spin1,
    $ReelContainer/Spin2,
    $ReelContainer/Spin3,
    $ReelContainer/Spin4,
    $ReelContainer/Spin5
]
var is_spinning: bool = false

func _ready():
    print("Playing scene ready")
    if reel_container.get_child_count() == 0:
        push_error("ReelContainer has no children!")
        return

func _on_button_pressed():
    if is_spinning:
        return

    lever.play("pull")
    spin_reels()

func spin_reels():
    is_spinning = true
    reel_container.start_spinners()
    reel_container.prepare_all_reels()

    if not GameManager.has_node("RunManager"):
        push_error("RunManager not found")
        is_spinning = false
        return

    var run_manager = GameManager.get_node("RunManager")

    if run_manager.slot_machine_manager == null:
        push_error("SlotMachineManager not initialized")
        is_spinning = false
        return

    run_manager.slot_machine_manager.spin(run_manager.player_data)

    print("\nSpin Result")

    for i in range(5):
        var column_symbols: Array[Symbol] = []

        for row in range(3):
            var sym = run_manager.slot_machine_manager.result_grid[i][row]
            column_symbols.append(sym)
            if sym:
                print("Col ", i, " Row ", row, ": ", sym.description, " (", sym.points, " pts)")

        reel_container.display_reel(i, column_symbols)
    spin_finished()

func spin_finished():
    is_spinning = false
    await get_tree().create_timer(1).timeout

    await stagger_reveal()

    var run_manager = GameManager.get_node("RunManager")
    var result_grid = run_manager.slot_machine_manager.result_grid
    var score_calculator = GameManager.get_node("ScoreCalculator")
    print(score_calculator.calculate_score(result_grid))

func stagger_reveal():
    for i in range(spinners.size()):
        spinners[i].hide()

        reel_container.reveal_column(i)

        await get_tree().create_timer(0.15).timeout

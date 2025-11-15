extends Node2D

@onready var lever: AnimatedSprite2D = $"Slot Machine/Button/Lever"
@onready var reel_container: Node2D = $ReelContainer

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
<<<<<<< HEAD
	is_spinning = true
	
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
	on_reel_spin_complete()

func on_reel_spin_complete():
	await get_tree().create_timer(0.1).timeout
	on_spin_finished()
	is_spinning = false
=======
    is_spinning = true

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
    _on_reel_spin_complete()

func _on_reel_spin_complete():
    await get_tree().create_timer(0.1).timeout
    on_spin_finished()
    is_spinning = false
>>>>>>> 6d9022c6fd5ad041a6b22871bcb72ab1a259f4a1

func on_spin_finished():
    var run_manager = GameManager.get_node("RunManager")
    var result_grid = run_manager.slot_machine_manager.result_grid
    # TODO: Scoring System with ScoringCalculator Maybe in Global or RunManager

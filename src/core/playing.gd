extends Node2D

@onready var lever: AnimatedSprite2D = $"Slot Machine/Button/Lever"
@onready var reel_container: Node2D = $ReelContainer

var reel_displays: Array = []
var is_spinning: bool = false

func _ready():
    print("Playing scene ready")
    
    if reel_container.get_child_count() == 0:
        push_error("ReelContainer has no children!")
        return
    
    for i in range(reel_container.get_child_count()):
        var reel = reel_container.get_child(i)
        reel.position = Vector2(i * 120, 0)
        reel_displays.append(reel)
        reel.spin_complete.connect(_on_reel_spin_complete)
    
    print("Loaded ", reel_displays.size(), " reels")

func _on_button_pressed():
    if is_spinning:
        return
    
    lever.play("pull")
    spin_reels()

func spin_reels():
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
        
        reel_displays[i].spin(0, column_symbols)

func _on_reel_spin_complete():
    await get_tree().create_timer(0.1).timeout
    on_spin_finished()
    is_spinning = false

func on_spin_finished():
    var run_manager = GameManager.get_node("RunManager")
    var result_grid = run_manager.slot_machine_manager.result_grid
    # TODO: Scoring System with ScoringCalculator Maybe in Global or RunManager

extends Node2D

const reel_display = preload("res://scenes/reelDisplay.tscn")
var reel_nodes: Array[ReelDisplay] = []
@onready var spinners := [
    $Spin1,
    $Spin2,
    $Spin3,
    $Spin4,
    $Spin5
]

func _ready() -> void:
    for i in range(5):
        var child = reel_display.instantiate()
        child.position = Vector2(i * 155, 0)
        child.name = "Child_" + str(i)
        add_child(child)
        reel_nodes.append(child)


func display_reel(column: int, symbols: Array[Symbol]):
    reel_nodes[column].display_symbols(symbols)

func prepare_all_reels():
    for reel in reel_nodes:
        reel.prepare_for_spin()

func reveal_column(column: int):
    if column < 0 or column >= reel_nodes.size():
        push_error("Invalid reel index: " + str(column))
        return

    if reel_nodes[column].has_method("reveal"):
        reel_nodes[column].reveal()
    else:
        push_warning("ReelDisplay has no 'reveal()' function")

func start_spinners():
    for spinner in spinners:
        spinner.show()

func start_spinner_for_reel(reel_index: int) -> void:
    if reel_index < 0 or reel_index >= spinners.size():
        return

    # Play spinner animation for this specific reel
    spinners[reel_index].show()
    if spinners[reel_index].has_method("play"):
        spinners[reel_index].play("spin")  # Or whatever your spinner animation is called

# In src/symbol/reel_container.gd
func hide_reel(column: int):
    if column < 0 or column >= reel_nodes.size():
        push_error("Invalid reel index: " + str(column))
        return

    reel_nodes[column].hide()

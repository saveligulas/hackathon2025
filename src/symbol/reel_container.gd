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
		spinner.play("spin")

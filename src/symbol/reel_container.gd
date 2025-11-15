extends Node2D

const reel_display = preload("res://scenes/reelDisplay.tscn")
var reel_nodes: Array[ReelDisplay] = []

func _ready() -> void:
	for i in range(5):
		var child = reel_display.instantiate()
		child.position = Vector2(i * 120, 0)
		child.name = "Child_" + str(i)
		add_child(child)
		reel_nodes.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func display_reel(column: int, symbols: Array[Symbol]):
	reel_nodes[column].display_symbols(symbols)
	
	

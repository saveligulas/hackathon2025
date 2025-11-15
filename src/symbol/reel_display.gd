extends Node2D

class_name ReelDisplay

signal spin_complete

var symbol_scene = preload("res://scenes/symbolDisplay.tscn")
var symbol_positions: Array[Node2D] = []

func _ready():
	for i in range(3):
		var pos = Node2D.new()
		pos.position = Vector2(0, i * 178)
		add_child(pos)
		symbol_positions.append(pos)

func spin(_duration: float, final_symbols: Array[Symbol]):
	set_result(final_symbols)
	spin_complete.emit()

func display_symbols(symbols: Array[Symbol]):
	set_result(symbols)

func set_result(symbols: Array[Symbol]):
	for pos in symbol_positions:
		for child in pos.get_children():
			child.queue_free()

	for i in range(min(3, symbols.size())):
		if symbols[i] != null:
			var symbol_display = symbol_scene.instantiate()
			symbol_display.symbol_data = symbols[i]
			symbol_positions[i].add_child(symbol_display)

extends Node

@export var starting_symbols: Array[Symbol] = []
@export var player_data: PlayerData
var slot_machine_manager: SlotMachineManager

func initialize():
	slot_machine_manager = SlotMachineManager.new()

	if starting_symbols.size() < 1:
		print("Creating test symbols...")

		for i in 6:
			var test_symbol = Symbol.new()
			test_symbol.points = [1, 2, 3, 5, 10, 15][i]
			test_symbol.mult = 1
			test_symbol.description = "Test Symbol " + str(i)
			starting_symbols.append(test_symbol)

	if player_data == null:
		player_data = PlayerData.new()
		player_data.initialize()

		for reel in player_data.reels:
			for j in 5:
				var random_symbol = starting_symbols.pick_random().duplicate() as Symbol
				reel.symbols.append(random_symbol)


func reset():
	pass  # TODO: Implement reset logic

func _ready():
	print("I LOADED RUNMANAGER")

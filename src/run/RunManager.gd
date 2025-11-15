extends Node

@export var starting_symbols: Array[Symbol] = []
@export var player_data: PlayerData
var slot_machine_manager: SlotMachineManager

func initialize():
	slot_machine_manager = SlotMachineManager.new()

	if player_data == null:
		player_data = PlayerData.new()
		player_data.initialize()

		for reel in player_data.reels:
			starting_symbols.shuffle()
			reel.symbols.append_array(starting_symbols)


func reset():
	pass  # TODO: Implement reset logic

func _ready():
	print("I LOADED RUNMANAGER")

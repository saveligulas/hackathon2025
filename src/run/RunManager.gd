class_name RunManagerClass
extends Node

@export var starting_symbols: Array[Symbol] = []
@export var player_data: PlayerData
var slot_machine_manager: SlotMachineManager

func initialize():
	slot_machine_manager = SlotMachineManager.new()
	
	if starting_symbols.size() < 1:
		push_error("No starting symbols found")
		return
	
	if player_data == null:
		player_data = PlayerData.new()
		player_data.initialize()
		for reel in player_data.reels:
			var random_symbol = starting_symbols.pick_random().duplicate() as Symbol
			reel.symbols.append(random_symbol)

func reset():
	pass  # TODO: Implement reset logic

func _ready():
	print("I LOADED RUNMANAGER")

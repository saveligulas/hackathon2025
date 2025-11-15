class_name SlotMachineManager
extends RefCounted

var result_grid: Array = []  # 5x3 grid

func _init():
    result_grid.resize(5)
    for i in range(5):
        result_grid[i] = []
        result_grid[i].resize(3)

func spin(player_data: PlayerData):
    for col in range(5):
        var reel_symbols = player_data.reels[col].symbols
        var reel_size = reel_symbols.size()
        if reel_size == 0:
            continue

        var start_index = randi() % reel_size

        for row in range(3):
            var index = (start_index + row) % reel_size
            result_grid[col][row] = reel_symbols[index]

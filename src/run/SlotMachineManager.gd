class_name SlotMachineManager
extends RefCounted

var result_grid: Array = []  # 5x3 grid

func _init():
    result_grid.resize(5)
    for i in range(5):
        result_grid[i] = []
        result_grid[i].resize(3)

func spin(player_data: PlayerData):
    for column in range(5):
        for row in range(3):
            if player_data.reels[column].symbols.size() > 0:
                result_grid[column][row] = player_data.reels[column].symbols.pick_random()

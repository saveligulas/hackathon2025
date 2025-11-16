class_name PlayerData
extends Resource

@export var reels: Array[Reel]
var relics: Array[Relic] = []

func initialize():
    reels.resize(5)
    for i in range(5):
        reels[i] = Reel.new()

func set_relic(relic: Relic):
    relics.append(relic)

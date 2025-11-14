class_name PlayerData
extends Resource

@export var reels: Array[Reel] = []

func initialize():
	reels.resize(5)
	for i in range(5):
		reels[i] = Reel.new()

# src/core/gameManager.gd (FIXED)
extends Node

enum GamePhase {
	MENU,
	PLAYING,
	SHOP,
	GAMEOVER
}

signal game_phase_changed

@onready var run_manager: Node = $RunManager

var current_phase: GamePhase = GamePhase.MENU

func _ready() -> void:
	print("Game Manager initialized")

func change_phase(new_phase: GamePhase) -> void:
	var previous_phase = current_phase
	current_phase = new_phase
	game_phase_changed.emit(new_phase)
	handle_phase_transition(new_phase, previous_phase)

func handle_phase_transition(new_phase: GamePhase, previous_phase: GamePhase):
	match new_phase:
		GamePhase.MENU:
			print("GamePhase: Change to Menu")
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

		GamePhase.PLAYING:
			print("GamePhase: Change to Playing")
			if previous_phase == GamePhase.MENU:
				run_manager.initialize()  # ← THIS WAS MISSING!
			get_tree().change_scene_to_file("res://scenes/playing.tscn")

		GamePhase.SHOP:
			print("GamePhase: Change to Shop")
			get_tree().change_scene_to_file("res://scenes/shop.tscn")

		GamePhase.GAMEOVER:
			print("GamePhase: Change to Game Over")
			run_manager.reset()

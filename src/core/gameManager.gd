extends Node

enum GameState {MENU, PLAYING, SHOP, GAME_OVER}
signal game_state_changed

@export
var current_state := GameState.MENU:
	set(value):
		current_state = value
		_handle_state_change(value)

func _ready() -> void:
	print("Game Manager initialized")

func _process(_delta: float) -> void:
	pass

func reset_game():
	# Reset points and stuff.
	pass

func _handle_state_change(new_state):
	game_state_changed.emit(new_state)
	_handle_state_transition(new_state)

func _handle_state_transition(new_state):
	match new_state:
		GameState.MENU:
			print("[GameState] Change to Menu")
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
		GameState.PLAYING:
			print("[GameState] Change to Playing")
			get_tree().change_scene_to_file("res://scenes/playing.tscn")
		GameState.SHOP:
			print("[GameState] Change to Shop")
		GameState.GAME_OVER:
			print("[GameState] Change to Game Over")

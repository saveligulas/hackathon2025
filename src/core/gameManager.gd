extends Node

enum GameState {MENU, PLAYING, SHOP, GAME_OVER}
signal game_state_changed

@export
var current_state := GameState.PLAYING:
	set(value):
		current_state = value
		_handle_state_change(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game Manager initialized")

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		GameState.PLAYING:
			print("[GameState] Change to Playing")
		GameState.SHOP:
			print("[GameState] Change to Shop")
		GameState.GAME_OVER:
			print("[GameState] Change to Game Over")

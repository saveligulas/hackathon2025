extends Node

enum GameState {MENU, PLAYING, SHOP, GAME_OVER}
signal game_state_changed
@onready var run_manager = $RunManager

@export
var current_state := GameState.MENU:
	set(value):
		var previous_state = current_state
		current_state = value
		_handle_state_change(value, previous_state)

func _ready() -> void:
	print("Game Manager initialized")

func _process(_delta: float) -> void:
	pass

func _handle_state_change(new_state, previous_state):
	game_state_changed.emit(new_state)
	_handle_state_transition(new_state, previous_state)

func _handle_state_transition(new_state, previous_state):
	match new_state:
		GameState.MENU:
			print("[GameState] Change to Menu")
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
		GameState.PLAYING:
			print("[GameState] Change to Playing")
			if (previous_state == GameState.MENU):
				run_manager.Initialize()
			get_tree().change_scene_to_file("res://scenes/playing.tscn")
		GameState.SHOP:
			print("[GameState] Change to Shop")
			get_tree().change_scene_to_file("res://scenes/shop.tscn")
		GameState.GAME_OVER:
			print("[GameState] Change to Game Over")
			run_manager.Reset()
			
func _on_main_menu_play_button_pressed():
	print("FUCK YOU JASON")

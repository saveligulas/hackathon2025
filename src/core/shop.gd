extends Control

@onready var next_round_button: Button = $MarginContainer/VBoxContainer/Button
var run_manager = GameManager.get_node("RunManager")

func _ready() -> void:
    next_round_button.pressed.connect(_on_next_round_pressed)

func _on_next_round_pressed():
    run_manager.advance_round()
    GameManager.change_phase(GameManager.GamePhase.PLAYING)

extends Control

@onready var button: Button = $Button

func _ready() -> void:
    button.pressed.connect(_back_to_main_menu)

func _back_to_main_menu():
    GameManager.change_phase(GameManager.GamePhase.MENU)

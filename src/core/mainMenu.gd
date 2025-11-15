extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var quit: Button = $VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_play_pressed() -> void:
    GameManager.current_state = GameManager.GameState.PLAYING


func _on_quit_pressed() -> void:
    get_tree().quit()

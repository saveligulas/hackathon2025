extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var quit: Button = $VBoxContainer/Quit
@onready var main_menu_theme: AudioStreamPlayer = $MainMenuTheme

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_theme.set_stream(AudioManager.sound_main_theme)
	main_menu_theme.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	GameManager.change_phase(GameManager.GamePhase.PLAYING)


func _on_quit_pressed() -> void:
	get_tree().quit()

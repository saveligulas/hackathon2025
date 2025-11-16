extends Node
var sound_lever: AudioStream = preload("res://assets/sounds/lever.ogg")
var sound_reel_stop: AudioStream = preload("res://assets/sounds/reel_stop.ogg")
var sound_payout: AudioStream = preload("res://assets/sounds/payout.ogg")
var sound_main_theme: AudioStream = preload("res://assets/music/Music_MainTheme.ogg")
var sound_main_theme_loopable: AudioStream = preload("res://assets/music/Music_MainTheme_Loopable.ogg")
var sound_victory: AudioStream = preload("res://assets/sounds/victory.mp3")
var sound_lose: AudioStream = preload("res://assets/sounds/lose.mp3")
var global_audio_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_audio_player = AudioStreamPlayer.new()
	add_child(global_audio_player)
	global_audio_player.max_polyphony = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

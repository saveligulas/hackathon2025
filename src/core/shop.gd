extends Control

@onready var next_round_button: Button = $MarginContainer/VBoxContainer/Button
@onready var reward_label: Label = $MarginContainer/VBoxContainer/Reward
@onready var reward_title: Label = $"MarginContainer/VBoxContainer/Reward Title"
var run_manager = GameManager.get_node("RunManager")
var selected_relic: Relic
const RELIC_SCRIPT_PATHS = [
    "res://src/relics/eye_fortune_relic.gd",
    "res://src/relics/fingerprint_eraser_relic.gd",
    "res://src/relics/golden_calculator_relic.gd",
    "res://src/relics/lucky_clover_relic.gd",
    "res://src/relics/palm_reader_relic.gd",
    "res://src/relics/pattern_master_relic.gd"
]


func _ready() -> void:
    next_round_button.pressed.connect(_on_next_round_pressed)
    var game_state = GameManager.run_manager.game_state
    # Pick a random relic script
    var index = randi() % RELIC_SCRIPT_PATHS.size()
    var script = load(RELIC_SCRIPT_PATHS[index])
    var relic = script.new()

    # Equip to game state
    game_state.equip_relic(relic)

    reward_title.text = relic.relic_name
    reward_label.text = relic.description


func _on_next_round_pressed():
    run_manager.advance_round()
    GameManager.change_phase(GameManager.GamePhase.PLAYING)

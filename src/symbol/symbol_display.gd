extends Node2D

@export var symbol_data: Symbol:
    set(value):
        symbol_data = value
        update_display()

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func _ready():
    if symbol_data:
        update_display()

func update_display():
    if not is_node_ready():
        return
    
    if symbol_data == null:
        return
    
    # Different colors for different point values
    match symbol_data.points:
        1: color_rect.color = Color.RED
        2: color_rect.color = Color.BLUE
        3: color_rect.color = Color.GREEN
        5: color_rect.color = Color.YELLOW
        10: color_rect.color = Color.PURPLE
        _: color_rect.color = Color.WHITE
    
    # Show point value
    label.text = str(symbol_data.points)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

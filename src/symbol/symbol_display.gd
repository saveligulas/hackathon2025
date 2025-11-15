extends Node2D

@export var symbol_data: Symbol:
    set(value):
        symbol_data = value
        update_display()

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

# Optional: Add Sprite2D for when designer provides sprites
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

func _ready():
    if symbol_data:
        update_display()

func update_display():
    if not is_node_ready():
        return

    if symbol_data == null:
         return

    color_rect.size.x = 140
    color_rect.size.y = 157

    if "texture" in symbol_data and symbol_data.texture != null:
        if sprite:
            sprite.texture = symbol_data.texture
            sprite.show()
        if color_rect:
            color_rect.hide()
    else:
        if sprite:
            sprite.hide()
        if color_rect:
            color_rect.show()

            match symbol_data.points:
                1: color_rect.color = Color.RED
                2: color_rect.color = Color.BLUE
                3: color_rect.color = Color.GREEN
                5: color_rect.color = Color.YELLOW
                10: color_rect.color = Color.PURPLE
                _: color_rect.color = Color.WHITE

            label.text = str(symbol_data.points)
            label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
            label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

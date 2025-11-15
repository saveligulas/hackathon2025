extends Node2D

@export var symbol_data: Symbol:
    set(value):
        symbol_data = value
        update_display()

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label
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
            sprite.scale = Vector2(0.5, 0.5)
            sprite.translate(Vector2(70, 78))
            sprite.show()
    else:
        print("Symbol missing texture")

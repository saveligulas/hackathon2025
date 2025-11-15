class_name SpinModifier
extends Resource

var modifier_order: int
@export var description: String

func apply_modifier():
	push_error("apply_modifier() must be implemented in derived class")

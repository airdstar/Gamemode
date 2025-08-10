extends Node
class_name Tool

var ground : bool = true

func pick_up() -> void:
	ground = false

func drop() -> void:
	ground = true

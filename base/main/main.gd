extends Node

func _ready() -> void:
	get_node(^"/root/Main")

func open_lobby() -> void:
	Game.lobby = preload("res://base/lobby.tscn").instantiate()
	add_child(Game.lobby)

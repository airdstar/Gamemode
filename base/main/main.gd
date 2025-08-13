extends Node

func _ready() -> void:
	Game.hud = $HUD

func open_lobby() -> void:
	Game.lobby = preload("res://base/lobby.tscn").instantiate()
	add_child(Game.lobby)

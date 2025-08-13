extends Node3D

var minigame : Minigame

@onready var playerlist = $Playerlist

func _ready() -> void:
	pass

func give_point(area: Area3D) -> void:
	area.get_parent().get_parent().update_score(1)

func oob(area: Area3D) -> void:
	area.get_parent().death()

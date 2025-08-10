extends Node3D

var current_minigame : Minigame = null
var next_minigame : Minigame = null

@onready var playerlist = $Playerlist
@onready var hud = $HUD

func _ready() -> void:
	pass


func give_point(area: Area3D) -> void:
	area.get_parent().get_parent().update_score(1)

func oob(area: Area3D) -> void:
	area.get_parent().death()

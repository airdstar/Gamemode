extends Node
class_name Rules

@export_category("Minigame")

@export var time : float = 30.0
@export var teams : int = 0
@export var respawns : int = 0

@export_category("Location")

@export var use_lobby : bool = false
@export var maps : Array[String]

@export_category("Player")

@export_enum("Third Person", "First Person", "Special") var camera : int
